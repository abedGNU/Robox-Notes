; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; In this file you handle :
;	- Inizialization										OnApplicationStart()
;   - Generation of new missions							OnNextMission()
;   - Write a mission as a sequence oc macro-operations		RegisterMission()
;   - Execution of macro to send commands to agv			OnExpandMacro()
;   - Monitor the execution of commands execution			OnExecuteMicro()
;   - Execute commands given from the command line			OnCommandInterpreter()
;   - Handle I/O of the plant								OnUpdateIO()
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Script to test the MGV
; 
; Version 01.00 of 29/10/2017
;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Input/outputs definition
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$define MAJOR_VERSION 1
$define MINOR_VERSION 0
$define BUILD_VERSION 0

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Missions
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$define MIS_NULL							0
$define MIS_TEST_MGV						1

$define MIS_LOAD_ONLY						10
$define MIS_UNLOAD_ONLY						11
$define MIS_TO_BATTERY_CHARGE				12
$define MIS_TO_HOME							13
$define MIS_TO_POINT						14

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Macro operations
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$undef MAC_LOAD
$undef MAC_UNLOAD

; Movement to waypoint
$define MAC_MOVE_TO_WP					100
; Wait for the amount of seconds specified in par1
$define MAC_WAIT_S						101
; Load a trolley from the point defined by par1
; par2 is true if there is a toilet on the trolley
$define MAC_LOAD_TROLLEY				102
; Unload a trolley on the point defined by par1
$define MAC_UNLOAD_TROLLEY				103

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Micro SYSTEM
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$define S_START_WAIT					100
$define S_EXEC_WAIT						101

; Timer to handle wait systems
timeout timerWait[MAX_AGV]


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Operations
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Parametri
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$define MIN_BATTERY				30.0	; Minimum level of battery charge for the agv to operate.
										; Under this level the mission to go charge battery
										; has the maximum priority
$define MAX_BATTERY_FOR_CHARGE	80.0	; Maximum level of battery charge for the agv to go charge battery.
										; Above this level the agv never goes to charge battery,
										; even when there is nothing to do.

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Definitions
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Useful constants
$define SEC_TO_GG (1.0/(3600.0*24.0))	; Multiply value in seconds to obtain value in days

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Useful points, defined on the map
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Point to wait for choosing the unload station
$define ID_WAIT_FOR_TOILET_UNLOAD	4000
; Point where operator loads toilets on empty trolley
$define ID_LOAD_TOILETS				2001
; Point to wait for decision of where to take an empty trolley
$define ID_EXIT_FROM_UNLOAD_AREA	2002

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; 	Global variables
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Flag for agv charging battery
bool bInCharge[MAX_AGV] = false

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Prototypes of local functions
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
forward RegisterMission(uint, uint, int = 0, int = 0) : uint

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Function called at program startup
;	Operations to initialize the plant.
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
code OnApplicationStart() : bool
	SetVersioneManager(nvmake(MAJOR_VERSION, MINOR_VERSION, BUILD_VERSION))

	XMapParams mpar
	;
	;	Very important: before changing some parameters, load defaults!!!
	;
	AgvGetMapParams(@mpar)
	; Set vehicle dimensions: length, width
	mpar.setSymmetricalVehicleDimension(2300, 900)
	;
	;	Parameters to calculate length of paths
	;
	mpar.dHandicapForRotation = 8000			; Distance added when using a cross for rotation
	mpar.dHandicapForCurve = 4000				; Distance added when using a curve
	mpar.dDistanzaDaIncrocioOkFermata = 0		; Minimum distance from cross to allow agv stop executing a movement
	;
	;	Parameters to modify path assignment
	;
	mpar.bOkInversioneSuIncrocio = false		; True to permit inversion on a cross point
	mpar.bNoFermataSuIncrocio = true			; True does forbid to stop on a cross point
	mpar.bNoMovSuTrattiPrenotati = false		; True to forbid movement that ends on a point reserved for movement by another agv
	mpar.bPalletBloccaPercorso = true			; Load unit (trolley) on path blocks the agv
;	mpar.bDontMoveOnDestMove = true				; Do not 
	mpar.bNoPercorsoAgvDisab = false			; Exclude paths occupied by agv that are not enabled
	mpar.bNoPercorsoAgvNoMis = false			; Exclude paths occupied by agv that are not executing a mission
	;
	;	Set parameters
	;
	AgvSetMapParams(@mpar)

	AgvSetLunghezzaMove(12000)
	
	SetAccessLevelForOperation(DefQual_OpTrascinaAgvSuLinea, ACCESS_INST)
	
	return true
end

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	User requested application exit
;	WARNING: if returns FALSE the program does not exit
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
code OnApplicationStop() : bool
	return true
end

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Called by AgvManager when a mission has been aborted.
;	Do not call this function !!!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
code OnAbortMission(uint uAgv)

	select (AgvActualMissionCode(uAgv))
	
		default
			break
	end
end

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Do the job assigned to the macro that has actually to be executed
;
;	Return TRUE when all work has been done, and the macro is finished.
;
;	Return FALSE when the work has not been finished: the function
;	will be called again for this macro
;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
code OnExpandMacro(uint uAgv, uint uMission, uint iMacroCode, int iPar1, int iPar2, int iPar3, int) : bool
	;
	;	Macro expansion, depending by the macro code
	;
	select (iMacroCode)	
		case MAC_MOVE_TO_WP
			; iPar1 = Waypoint id
			; iPar2 = (bool) do concatenate next macro
			select (AgvMoveToWayPoint(uAgv, uMission, WpFl_RicalcolaPercorsi | WpFl_EliminaCompletato))
				case EsitoMov_MovimentoCompletato	; Completed movement
				case EsitoMov_RaggiuntoWaypoint		; Waypoint reached
					if (iPar2)
						AgvComputeNextMacro(uAgv)
					endif
					return true
				default
					return false
			endselect
			return true
			
		case MAC_CHARGE_STOP
			AgvRegisterSystemBloccante(uAgv, uMission, S_CHARGE_STOP)
			AgvRegisterOperation(uAgv, uMission, O_CHARGE, O_CHARGE_STOP)
			AgvComputeNextMacro(uAgv)
			break
			
		case MAC_END
			SetAgvMessage(uAgv, "")
			AgvRegisterSystemBloccante(uAgv, uMission, S_END)
			break

		default
			qt_warning("Unknown macro: " + iMacroCode)
			break
    end
	return TRUE
end

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Execution of the actions related to vehicle operations,
;	and execution of the SYSTEM micro.
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
code OnExecuteMicro(uint uAgv, bool bLastCall, int iMicroCode, int iPar0, int iPar1, int iPar2, int, int, int userId, int iMission, int) : bool
	XVehicleInfo vInfo
	AgvGetVehicleInfo(uAgv, @vInfo)

	select (iMicroCode)

		case MIC_MOVE
		case MIC_CURVE
		case MIC_ROTATION
			return true

		case MIC_OPERATION

		case MIC_SYSTEM
			select (iPar0)
				case S_NULL
					; Micro of that type are generated by AgvManager, I am not intereseted on it.
					break

				case S_END
					; End of mission
					if (vInfo.uStatus & VST_EXEC_COMANDO)
						MultiMessageState(uAgv, "Agv " + (uAgv + 1) + ": wait for agv commands finished")
						return false
					endif
					MultiMessageState(uAgv, "Agv " + (uAgv + 1) + ": finished executing commands")
					AgvStopMission(uAgv)
					SetAgvMessage(uAgv, "")
					break
				default
					qt_warning("Unknown MIC_SYSTEM : " + iPar0 + " (mission = " + iMission + ", par1 = " + iPar1 + ")")
					break
			end
			break

		case MIC_PASSANTE
			select (iPar0)
				default
					qt_warning("Unknown MIC_PASSANTE : " + iPar0 + " (mission = " + iMission + ", par1 = " + iPar1 + ")")
					break
			end
			break
			
		case MIC_WAIT
			if (bLastCall)
				MessageState("Agv " + (uAgv + 1) + ": passthrough operation executed")
				return true
			end
			return false

		default
			qt_warning("Unknown micro: " + iMicroCode + " (mission = " + iMission + ", par0 = " + iPar0 + ", par1 = " + iPar1 + ")")
			break

	end
	return true
end

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Called when the user drags an agv (uAgv) to a point in map (uUser)
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
code OnAgvDroppedToPoint(uint uAgv, uint uUser)
	if (uAgv >= MAX_AGV)
		MessageBox("Invalid AGV number: " + (uAgv + 1))
		return
	end
	if (not AgvInAutomatico(uAgv))
		MessageBox("AGV " + (uAgv + 1) + " is not in automatic mode.")
		return
	end
	if (AgvAbilitato(uAgv))
		MessageBox("AGV " + (uAgv + 1) + " is enabled." + chr(10) + "Please disable it to give commands.")
		return
	end
	if (AgvActualMissionCode(uAgv) != MIS_NULL)
		MessageBox("AGV " + (uAgv + 1) + " is already executing a mission")
		return
	end
	;
	AgvStartMission(uAgv, MIS_TO_POINT, "mission to point")
	;
	uint wpidx
	uchar destOrientation = 'X'
	bool concatenateNext = true
	;
	wpidx = AgvAddWaypoint(uAgv, uUser, destOrientation)
	AgvAddMacro(uAgv, MAC_MOVE_TO_WP, wpidx, concatenateNext)
	;
	AgvAddMacro(uAgv, MAC_END, MIS_TO_POINT)
end
