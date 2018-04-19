;
$define AGVMANAGER_7_2
                             ; XMovingOperationData
                             ; XMapParams::setSymmetricalVehicleDimension()
                             ; XMapParams::setVehicleDimension()
                             ; AgvSetPositionReservation()
                             ; AgvReleasePositionReservation()
                             ; BeginEventReport()
                             ; EndEventReport()
                             ; XMapParams::dHandicapForRotation, XMapParams::dHandicapForCurve
                             ; DistanceFromUser()
                             ; AssignedPathLength() 
; Introdotte in 7.2.5
                             ; AgvCrossByUserIdExists()
                             ; AgvCrossByCrossIdExists()
                             ; AgvGetCrossUserByCrossUserId()
                             ; AgvGetCrossUserByCrossId()
; Introdotte in 7.2.6
                             ; AgvGetMapDescription()
$define AGVMANAGER_7_3
                             ; AgvOnPathIntersectionMask()
; Introdotte in 7.3.1
                             ; XByteArray.setBigEndian()
$define AGVMANAGER_7_4
                             ; AgvRemoveAllMacro()
$define AGVMANAGER_7_5
                             ; Translation of many functions in English
                             ; MessaggioDebugMissione() -> OnNextMissionDebugMessage()
                             ; AgvSetInfoCaricoAgv() -> AgvSetAgvLoadInfo()
                             ; VehicleAlarmCode()
                             ; VehicleAlarmString()
;
; ~~~~~~~~~~~~~~~~~~~~
; Open() generic flags
; ~~~~~~~~~~~~~~~~~~~~
$define OFMODE_READ      1	; Opens the file in read-only mode
$define OFMODE_WRITE     2	; Opens the file in write-only mode. If this flag is used with another flag,
; e.g. IO_ReadOnly or IO_Raw or IO_Append, the file is not truncated; but if used on its own (or with IO_Truncate), the file is truncated
$define OFMODE_READWRITE 3	; Opens the file in read/write mode, equivalent to (IO_ReadOnly | IO_WriteOnly)
$define OFMODE_APPEND    6	; Opens the file in append mode.
; This mode is very useful when you want to write something to a log file. The file index is set to the end of the file.
$define OFMODE_TRUNCATE  8	; Truncates the file
$define OFMODE_RAW       32	; Raw (non-buffered) file access
;
;	Lettura/scrittura su file di testo ascii
;
object XAsciiFile
	uint pFile	; INTERNAL POINTER - DO NOT TOUCH
	internal 0x09001000 Constructor()
	internal 0x09001001 Destructor()
	internal 0x09001002 Open(string, uint) : bool
	internal 0x09001003 Close()
	internal 0x09001010 Write(string,bool acapo=true) : bool	; acapo è dipendente dal s.o.
	internal 0x09001011 Read() : string
	internal 0x09001012 atEof() : bool
	internal 0x09001013 lastErrorString() : string
endobject
;
;	Lettura/scrittura su file binario
;
object XBinaryFile
	uint pFile	; INTERNAL POINTER - DO NOT TOUCH
	internal 0x09001200 Constructor()
	internal 0x09001201 Destructor()
	internal 0x09001202 Open(string, uint): bool
	internal 0x09001203 Close()
	internal 0x09001204 SeekAbs(uint)
	internal 0x09001205 SeekRel(int)
	internal 0x09001206 SeekToBegin()
	internal 0x09001207 SeekToEnd()
	internal 0x09001208 GetPosition(): uint
	internal 0x09001209 GetLength(): uint
	internal 0x0900120A Read(char @): bool
	internal 0x0900120B Read(uchar @): bool
	internal 0x0900120C Read(int16 @): bool
	internal 0x0900120D Read(uint16 @): bool
	internal 0x0900120E Read(int @): bool
	internal 0x0900120F Read(uint @): bool
	internal 0x09001210 Read(float @): bool
	internal 0x09001211 Read(real @): bool
	internal 0x09001212 Read(bool @): bool
	internal 0x09001213 Read(string, uint): bool
	internal 0x09001214 Read(object @): bool
	internal 0x09001215 Write(char @): bool
	internal 0x09001216 Write(uchar @): bool
	internal 0x09001217 Write(int16 @): bool
	internal 0x09001218 Write(uint16 @): bool
	internal 0x09001219 Write(int @): bool
	internal 0x0900121A Write(uint @): bool
	internal 0x0900121B Write(float @): bool
	internal 0x0900121C Write(real @): bool
	internal 0x0900121D Write(bool @): bool
	internal 0x0900121E Write(string, uint): bool
	internal 0x0900121F Write(object @): bool
endobject
;
; * * * Tokenizzatore * * *
;
; Token types
;
$define XTKT_EOL     0	; Fine linea
$define XTKT_TOKEN   1	; Token generico
$define XTKT_LIT     2	; Literally	@xxx
$define XTKT_DIR     3	; Direttiva	$xxx
$define XTKT_STRING  5	; Stringa "xxx"
$define XTKT_INTEGER 6	; Numero intero
$define XTKT_REAL    7	; Numero reale
;
; Codici errore per SyntaxMatch()
$define SYNTAX_OK         0	; Match sintassi OK
$define SYNTAX_BAD_TEMPL -1	; Formato/contenuto template non valido
$define SYNTAX_ERROR     -2	; Errori di sintassi
$define SYNTAX_MISSVALUE -3	; Valore mancante (su tipo *)
$define SYNTAX_RANGE_MIN -4	; Valore inferiore a minimo richiesto
$define SYNTAX_RANGE_MAX -5	; Valore maggiore a massimo richiesto
$define SYNTAX_EXTRA_IGN -6	; Contenuto extra ignorato
$define SYNTAX_INT_ERROR -7	; Errore interno
$define SYNTAX_NOMATCH   -8	; No match
;
;	Definizione 'token' per xtokenizer
;
object XToken
	string strToken
	int iType	; Type (XTKT_xxx)
	int iOffset	; Buffer offset
endobject
;
;	Interprete di sintassi predefinite
;
object XTokenizer
	uint pTK	; INTERNAL POINTER - DO NOT TOUCH
	internal 0x09002000 Constructor()
	internal 0x09002001 Destructor()
	internal 0x09002003 Tokenize(string): int
	internal 0x09002004 Clear()
	internal 0x09002005 GetCount(): int
	internal 0x09002006 GetToken(int, XToken @): bool
	internal 0x09002007 GetTokenType(uint): int
	internal 0x09002008 GetTokenString(uint): string
	internal 0x09002009 GetTokenOffset(uint): int
	internal 0x0900200A AddTokenCode(string, int)
	internal 0x0900200B GetTokenCode(uint): int
	internal 0x0900200C GetTokenCode(string): int
	internal 0x0900200D SyntaxMatch(int, string): int
	internal 0x09002011 SyntaxExplain(string): string
	internal 0x09002012 AddSyntax(string, int)
	internal 0x09002013 SearchSyntax(): int
	internal 0x09002014 GetSyntax(): string
	internal 0x09002015 GetExplain(): string
	internal 0x09002016 DataString(uint): string
;	internal 0x09002017 DataReal(uint): real
	internal 0x09002018 LoadFromFile(string): bool
	internal 0x09002019 GetIntParam( uint, uint=0 ): int
	internal 0x09002020 GetRealParam( uint, uint=0 ): real
	internal 0x09002021 GetStrParam( uint, uint=0 ): string
	internal 0x09002022 NumValues( uint ) : uint
endobject
;
; Livelli di accesso
$define LIV_QUAL_USER1 0
$define LIV_QUAL_USER2 1
$define LIV_QUAL_USER3 2
$define LIV_QUAL_INST  3
$define LIV_QUAL_NO_OP 4
$define ACCESS_USER1 0
$define ACCESS_USER2 1
$define ACCESS_USER3 2
$define ACCESS_INST  3
$define ACCESS_NO_OP 4

;
; Definizioni costanti utili
$define SEC2GG           1.15741e-05	; Costante di conversione da secondi a giorni
$define MAX_AGV          32	; Numero massimo di agv gestibili da AgvManager
$define MAX_BATTERY_CAP  1000	; Massimo valore della capacità batteria scaricabile (verificare software su agv)
$define MAX_DIST         1e+99	; Valore funzionalmente equivalente a +∞
$define INT_MAX          2147483647	; Massimo valore intero rappresentabile

;
; Definizione codici modalita veicolo per veicolo inerziale
$define VM_NULL        0
$define VM_MANUALE     1
$define VM_CICLO_0     2
$define VM_PUNTO_INIZ  3
$define VM_AUTOMATICO  4
$define VM_MANU_EMERG  5

;
; Definizione codici modalita veicolo per veicolo con guida a filo
$define MOD_NULL            0
$define MOD_WAIT_CICLO0     1
$define MOD_RUN_CICLO0      2
$define MOD_MANUAL          3
$define MOD_RICERCA_SNAZI   4
$define MOD_SEMI_AUTO       5
$define MOD_AUTOMATICO      6
$define MOD_STAND_BY        7
$define MOD_MANUAL_EMG      8

;
; Definizione codici macro
$define MAC_NULL             0
$define MAC_MOVE_TO_USER     1
$define MAC_MOVE_TO_XY       2
$define MAC_CHARGE_BATT      3
$define MAC_CHARGE_STOP      4
$define MAC_LOAD             5
$define MAC_UNLOAD           6
$define MAC_END              7
$define MAC_MOVE_AND_LOAD    8
$define MAC_MOVE_AND_UNLOAD  9

;
; Definizione literally per orientazione agv
$define agvOrient_any           'X'
$define agvOrient_ffw           'F'
$define agvOrient_rev           'R'
$define agvOrient_left          'S'
$define agvOrient_right         'D'
$define agvOrient_longitudinal  'L'
$define agvOrient_trasversal    'T'
$define agvOrient_ahead         'A'
$define agvOrient_backwards     'I'
$define agvOrient_invalid       '#'

;
; Definizione codici micro
$define MIC_NULL              0
$define MIC_MOVE              1
$define MIC_CURVE             2
$define MIC_ROTATION          4
$define MIC_OPERATION         5
$define MIC_SYSTEM            6
$define MIC_PASSANTE          7
$define MIC_WAIT              8
$define MIC_MOVING_OPERATION  9

;
; Definizione codici operazioni
$define O_LOAD          2
$define O_UNLOAD        3
$define O_CHARGE        4
$define O_CHARGE_START  1
$define O_CHARGE_STOP   2

;
; Definizione codici micro System
$define S_NULL          0	; Serve (ad esempio) a spezzare le MIC_MOVE
$define S_END           1
$define S_CHARGE_WAIT   3
$define S_CHARGE_START  4
$define S_CHARGE_STOP   5
$define S_CONCAT_MACRO  8	; Concatena immediatamente la macro successiva

;
; Definizione codici user flags
;
; Flags riservati ad AgvManager :
$define UF_MODIFIED            1
$define UF_NO_FREQ             2
$define UF_INUSE               4
$define UF_PRE_INUSE           8
$define UF_PALLET_SU_PERCORSO  32
$define UF_MASK_FLAGS_AGVM     4095
; Flags impostabili da script ed usati da AgvManager
$define UF_ACCESSIBLE          0x00001000	; Passaggio attraverso user possibile (default vero)
$define UF_FORCE_STOP          0x00002000	; Obbligo di spezzare movimento
$define UF_NO_STOP             0x00004000	; Punto di sosta vietata
$define UF_NO_STOP_CROSS       0x00008000	; È vietato fermare l'agv su questo incrocio
$define UF_FORCE_BREAK_CROSS   0x00010000	; Obbligo di spezzare movimento su incrocio
$define UF_BLINK_ICON          0x00020000	; Se sito in attesa di missione o riservato, icona blinka
$define UF_NO_INVERSIONE       0x00040000	; Vietato fare inversione su questo punto
; Flags impostabili da script e non usati da AgvManager
$define UF_RESERVED            0x00080000	; Prenotato da agv per missione (viene disegnato bollo rosso)
$define UF_MISS_OK             0x00100000	; Sito in attesa di missione (viene disegnato bollo verde)
$define UF_FLAG_XSCRIPT        0x01000000	; Primo flag utilizzabile liberamente da script
;  Esempio d'uso :
;  $define UF_MY_FLAG_1			shl(UF_FLAG_XSCRIPT,1)
;  $define UF_MY_FLAG_2			shl(UF_FLAG_XSCRIPT,2)

;
; Operatori per operazioni bit a bit sui flags
$define OP_SET	 0
$define OP_OR	 1
$define OP_AND	 2

;
; Definizione flags veicolo
; Nota Bene: Controllare che il veicolo mandi correttamente questi flags !!!
$define VST_POTENZA_ATTIVA   1
$define VST_EXEC_COMANDO     2
$define VST_CARICO_PRESENTE  8
$define VST_CARICA_INCORSO   4

;
;	Informazioni associate a punto USER
;
object XSiteInfo
	bool bAttiva           ; (rw)
	bool bPriorita         ; (rw)
	bool bPresenza         ; (rw)
	bool bVasiPieni        ; (rw)
	bool bInAllarme        ; (rw)
	bool bVisibile         ; (rw)
	uint uTipo             ; (rw)
	uint uFlags            ; (ro)
	real dStoreTime        ; (ro) in giorni
	uint uLato             ; (ro) [L (sinistra) | R (destra) | C (centro)]
	uint uExtendedPalletId ; (ro) Identificativo informazioni estese pallet (se presenti)
endobject
;
;	Definizione univoca della posizione in mappa
;
object XDefPosizioneAgv
	uint uLine
	int iPos
	uchar uDirV
endobject
;
;	Definizione dell'ultima posizione comandata/assegnata all'agv
;
object XLastMoveInfo
	bool isValid
	uint uLine
	int iPos
	uchar uDirV
	uint uUserId
endobject
;
;	Informazioni stato attuale veicolo
;
object XVehicleInfo
	uint uLineID            ; Id. linea attuale agv
	int iPosition           ; Posizione [mm] dell'agv sulla linea attuale
	int iAngle              ; Angolo in gradi attuale dell'agv
	uint uMode              ; Modalità attuale veicolo (vedi etichette VM_***)
	uint uStatus            ; Flag di stato veicolo (vedi etichette VST_***)
	uint uAlarmStatus       ; Flag di allarme veicolo
	uint uBatteryCapacity   ; Capacità batteria:
                            ; 0		= Batteria completamente carica
                            ; 1000	= Batteria completamente scarica
	float dBatteryPerc      ; Percentuale carica batteria : 0.0	= completamente scarica, 100.0 = completamente carica
	uint uMission           ; Id. missione attuale agv
	uint uCommand           ; Id. comando attuale agv
	uint uDirV              ; Direzione sul corridoio: uno tra [FRSD]
	uint uExtendedPalletId  ; Identificativo informazioni estese pallet (se presenti)
	XLastMoveInfo lastMove  ; Ultimo movimento registrato (.isValid indica validità, in più se non valido, .uLine == 0)
	XLastMoveInfo destMove  ; Destinazione finale (.isValid indica validità, in più se non valido, .uLine == 0)
endobject
;
;
;	Parametri definizione comportamento movimentazione veicoli
;
object XMapParams
	internal 0x02000093 setSymmetricalVehicleDimension(int length, int width, int diagonal=0)
	internal 0x02000094 setVehicleDimension(int length_front, int length_rear, int width_left, int width_right, int radius = 0)
	int iLunghVeicolo                  ; Larghezza veicolo (per anticollisione)
	int iLarghVeicolo                  ; Lunghezza veicolo (per anticollisione)
	int iDiagVeicolo                   ; Diagonale veicolo (per anticollisione, autocalcolata se == 0)
	int iVehicleLengthFront            ; Lunghezza veicolo dal centro in avanti (per anticollisione)
	int iVehicleLengthRear             ; Lunghezza veicolo dal centro all'indietro (per anticollisione)
	int iVehicleWidthLeft              ; Larghezza veicolo dal centro verso sinistra (per anticollisione)
	int iVehicleWidthRight             ; Larghezza veicolo dal centro verso destra (per anticollisione)
	int iVehicleRadius                 ; Raggio di massimo ingombro durante rotazione (per anticollisione)
	real dHandicapIncrocio             ; Distanza aggiunta per uso incrocio (DEPRECATO)
	real dHandicapForRotation          ; Distanza aggiunta per ogni rotazione
	real dHandicapForCurve             ; Distanza aggiunta per ogni curva
	real dUseHandicap                  ; Handicap per segmenti prenotati in senso contrario
	real dFattoreCurva                 ; (Non usato, deprecato) Fattore moltiplicativo dell'ingombro in caso di curva
	real dAngMinCurvaOk                ; Angolo per cui il cambio di corridoio è possibile con una rotazione anche se c'è divieto di ingombro dei quadranti (cambio verso)
	real dHandicapIncontraDestMove     ; Distanza aggiunta se si incontra un veicolo fermo. Se negativa non si passa proprio (ricerca di un percorso alternativo)
	real dHandicapMarciaIndietro       ; Handicap moltiplicativo per tratti a marcia indietro
	real dDistanzaDaIncrocioOkFermata  ; Distanza minima per fermata prima o dopo un incrocio in prenotazione movimento
	bool bOkInversioneSuIncrocio       ; Ok inversione su incrocio
	bool bNoFermataSuIncrocio          ; Vietato fermare su incrocio
	bool bPalletBloccaPercorso         ; Non si passa su user di tipo 'C' occupato
	bool bNoMovSuTrattiPrenotati      ; Non muovere gli agv su tratti prenotati da altri agv
	bool bNoPercorsoAgvNoMis          ; Escludi dal percorso tratti su cui si trovano agv non in missione
	bool bNoPercorsoAgvDisab          ; Escludi dal percorso tratti su cui si trovano agv disabilitati (e non in missione)
	bool bDontMoveOnDestMove          ; Non muovere un agv se andrebbe a finire sulla destinazione di un altro agv
	int iAgvPosThreshold              ; Soglia di posizione agv
endobject
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione report impianto
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000001 AddReportLine(int iAgv, string msg)	; Aggiunge riga nel report
$define REPCODE_FIRST_USER_TYPE	100	; Primo codice disponibile per tipi custom
internal 0x02000002 AddReportType(int, string) : bool				; Aggiunge tipo con descrizione disponibile nel report
internal 0x02000003 SetAgvPositionForReport(uint uAgv, int pos)		; Impostazione stazione associata ad agv per allarmi (finisce nel campo 'idposizione' in caso di allarme agv)
; Aggiunge linea di tipo custom nel report
internal 0x02000004 AddReportCustomLine(int type, string desc, int codall=0, int idpos=0) : bool
internal 0x02000005 AddReportCustomLine(int type, int iagv, string desc, int codall, int idpos) : bool
internal 0x02000006 BeginEventReport(int eid, int iagv, string desc, int type=0, int codall=0, int idpos=0) : bool
internal 0x02000007 EndEventReport(int eid) : bool
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;    Gestione generale impianto    ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
internal 0x02000008 VehicleExists(uint uAgv) : bool					; Test esistenza agv
$define DefQual_OpModificaPresenzaPallet       1	; Modify pallet presence
$define DefQual_OpModificaTipoSito             2	; Modify site type
$define DefQual_OpModificaPrioritaSito         3	; Modify site priority
$define DefQual_OpForzaInputOutput             4	; Force input/output
$define DefQual_OpInviaComandiSQL              5	; Execute SQL commands
$define DefQual_OpInviaComandiDiretti          6	; Send commands to vehicle
$define DefQual_OpAnnullaMissione              7	; Abort mission in progress
$define DefQual_OpDisabilitaVeicolo            8	; Disable vehicle
$define DefQual_OpAbilitaSito                  9	; Enable site
$define DefQual_OpEsciConMissioniInCorso       10	; Exit with missions in progress
$define DefQual_OpModificaNomeSito             11	; Modify site name
$define DefQual_OpModificaDirettaNomeSito      12	; Directly modify site name
$define DefQual_OpModificaDataPallet           13	; Modify store date
$define DefQual_OpModificaColoreTipo           14	; Modify color assigned to type
$define DefQual_OpModificaNomeTipo             15	; Change name assigned to type
$define DefQual_OpVediTuttiITipi               16	; Show all available types
$define DefQual_OpVediTipoZero                 17	; Show type with 0 index
$define DefQual_OpAnnullaMissioneVeicoloFermo  18	; Abort mission (stopped vehicle)
$define DefQual_OpTrascinaAgvSuSite            19	; Drag vehicle to site
$define DefQual_OpTrascinaAgvSuFixedUser       20	; Drag vehicle to generic user
$define DefQual_OpTrascinaAgvSuLinea           21	; Drag vehicle to line
$define DefQual_OpForzaStatoSemaforo           22	; Force semaphore state
$define DefQual_OpVediReport                   23	; Show alarms report
$define DefQual_OpChiudiApplicazione           24	; Exit application
$define DefQual_OpApriFinestraModificaSito     25	; Open window to modify site
$define DefQual_OpIgnAgvNonComunicaManuale     26	; Ignore vehicle not communicating (in manual mode)
$define DefQual_OpIgnAgvNonComunicaAutomatico  27	; Ignore vehicle not communicating (in automatic mode)
$define DefQual_OpIgnoraAgvInManuale           28	; Ignore agv in manual mode
$define DefQual_OpScegliDialogModificaSito     29	; Choose if use standard site's modify dialog or provided from script
$define DefQual_OpMostraPrenotazioni           30	; Permit to show reservations
$define DefQual_OpVediInfoVeicoloDebug         31	; Show vehicle's debug informations
$define DefQual_OpVediComandiInviati           32	; Show informations about sent commands
$define DefQual_OpVediSalvataggioDB            33	; Show informations about storing storage to database
$define DefQual_OpDisconnettiClientRemoto      34	; Force remote client to disconnect
$define DefQual_OpVediDettaglioPercorsi        35	; Show paths details
$define DefQual_OpZoomLibero                   36	; Zoom in/out
$define DefQual_OpMostraGeometriePrenotazione  37	; Show geometries
$define DefQual_OpCambiaLinguaProgramma        38	; Cambia lingua
internal 0x02000009 ActualAccessLevel() : int				; Ritorna il livello di accesso attuale
internal 0x02000009 LivelloQualificaAttuale() : int				; Ritorna il livello di accesso attuale
internal 0x0200000A SetAccessLevelForOperation(uint,int)			; Parametri : tipo operazione,livello minimo richiesto
internal 0x0200000A SetQualificaPerOperazione(uint,int)			; Parametri : tipo operazione,livello minimo richiesto
; AgvAbilitaSegmento() :
;  Abilita o disabilita i segmenti di una linea, da user uDa (che deve esistere) a iA.
;  - Se iA == 0 si va verso quote positive fino al primo incrocio
;  - Se iA < 0  si va verso quote negative fino al primo incrocio
;  - Se iA > 0  identifica un user limite (se non esiste si va da uDa a fine linea)
;  Il parametro bProsegui (presente in vecchie versioni del comando) non ha più
;  senso di esistere ed è stato eliminato
;  Se iAgv >= 0 l'abilitazione vale per il solo agv indicato
internal 0x02000011 AgvAbilitaSegmento(bool bAbil,uint uDa,int iA,int iAgv=-1) : bool
; AgvRiservaSegmento() :
;  Assegna un tratto di linea ad uno o più agv. Assegnare un tratto
;  ha effetto sul calcolo di nuovi percorsi: l'agv continua il movimento se lo stesso è già
;  stato prenotato, ma esclude i tratti assegnati ad altri agv dal calcolo di nuovi percorsi.
;  La gestione degli user limite (uDa,iA) è la stessa che per AgvAbilitaSegmento()
internal 0x02000012 AgvRiservaSegmento(uint uAgvMask,bool bSet,uint uDa,int iA) : bool
internal 0x02000013 AgvGetCurrentTime() : real		; NB: Ritorna il tempo in giorni!
internal 0x02000014 AgvGetUserFlags(int) : uint
internal 0x02000015 AgvExitApplication()
internal 0x02000016 AgvSetInfoStr(uint, string)	; Impostazione stringa che compare sul sinottico (finestra informazioni agv)
internal 0x02000018 AgvInRange(uint uAgv, uint userId, uint distance) : bool
internal 0x02000019 AgvCrossByUserIdExists(uint cross_user_id) : bool	; Test esistenza incrocio
internal 0x0200001A AgvCrossByCrossIdExists(uint cross_id) : bool	; Test esistenza incrocio
internal 0x0200001B AgvGetCrossUserByCrossUserId(uint cross_user_id, uint line) : uint	; Identificativo punto incrocio su linea specificata
internal 0x0200001C AgvGetCrossUserByCrossId(uint cross_id, uint line) : uint	; Identificativo punto incrocio su linea specificata
internal 0x0200001D AgvGetUserPos(uint user,uint line) : int				; Posizione punto sulla linea indicata
internal 0x0200001E AgvSetComunicazioneViaFilo(bool)			; Per gestione punti senza frequenza
internal 0x0200001F AgvUserExists(uint uCode) : bool					; Esistenza punto generico
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione mappa
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; AgvSetMapParams() : lunghezza, larghezza, handicap incrocio, handicap user in uso, fattore curva
internal 0x02000090 AgvSetMapParams(int lungh, int largh, real dinc, real duser, real dcurve)
internal 0x02000091 AgvGetMapParams(XMapParams@)		; Richiesta parametri mappa attuali
internal 0x02000092 AgvSetMapParams(XMapParams@)	; Impostazione parametri mappa tramite struttura dati
internal 0x02000095 AgvGetMapDescription() : string	; Richiesta descrizione mappa
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione agv
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000070 AgvGetVehicleInfo(uint uAgv,XVehicleInfo @info) : bool	; Richiesta informazioni veicolo
internal 0x02000071 AgvStartMission(uint uAgv,uint uCode,string desc) : bool	; Inizio missione
; AgvStopMission(<indice agv>) Segnala terminazione normale missione
;	Svuota la coda delle macro di tutte le macro eventualmente presenti.
internal 0x02000072 AgvStopMission(uint uAgv)
; AgvSetLunghezzaMove() : Impostazione lunghezza tratto di movimento spedito al veicolo
; max : è il massimo movimento spedito al veicolo
; min : è il minimo movimento spedibile al veicolo
internal 0x02000073 AgvSetLunghezzaMove(int max,int min=-1)
; ATTENZIONE: le funzioni di calcolo della distanza ritornano la
;	distanza tra il punto indicato e l'ultimo punto per cui è stato
;	registrato un movimento.
;	La distanza ritornata coincide con la distanza dell'agv dal punto
;	specificato solo se l'agv è fermo.
internal 0x02000074 DistanceFromUser(uint uAgv, int idUser) : real						; Calcola la distanza dell'agv uAgv dall'user uUser
internal 0x02000075 DistanceFromUser(uint uAgv, int userId, int @rotCount, int @curveCount) : real	; Calcola la distanza dell'agv uagv dall'user userid, tornando il conteggio di rotazioni e curve
internal 0x02000074 DistanzaDaUser(uint uAgv, int idUser) : real						; Calcola la distanza dell'agv uAgv dall'user uUser
internal 0x02000076 DistanzaDaPosizione(uint uAgv,uint uLine,int iPos,uint uDir) : real	; Calcola la distanza dell'agv dalla posizione specificata
internal 0x02000077 AssignedPathLength(uint uAgv) : real	; Ritorna la distanza (sul percorso spedito all'agv) che l'agv deve ancora percorrere
internal 0x02000077 DistanzaDaPercorrere(uint uAgv) : real	; Ritorna la distanza (sul percorso spedito all'agv) che l'agv deve ancora percorrere
internal 0x02000078 AssignedPathLength(uint uAgv, int @rotCount, int @curveCount) : real	; Ritorna la distanza (sul percorso spedito all'agv) che l'agv deve ancora percorrere
internal 0x02000079 ReservedPathLength(uint uAgv) : real	; Ritorna la distanza prenotata ma non spedita all'agv
internal 0x02000079 DistanzaPrenotata(uint uAgv) : real	; Ritorna la distanza prenotata ma non spedita all'agv
internal 0x0200007A AgvOnPathIntersectionMask(uint uAgv) : uint
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Registrazione MACRO istruzioni
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000150 AgvAddMacro(uint uAgv,uint uCode,int iPar1=0,int iPar2=0,int iPar3=0,int iPar4=0) : bool
internal 0x02000151 AgvComputeNextMacro(uint uagv)	; Forza l'esecuzione della prossima macro in coda anche se non è terminata l'esecuzione di tutte le micro.
internal 0x02000152 AgvRemoveAllMacro(uint uAgv)		; Rimozione di tutte le macro accodate
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Registrazione istruzioni di movimento
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000153 AgvRegisterMoveTo(uint uAgv,uint uMission,uint userDest,uchar uDirDest='X') : int				; Registrazione tratti di movimento
internal 0x02000154 AgvRegisterMoveToLine(uint uAgv,uint uMission,uint uLine,int iPos,uint uDirDest='X') : bool	;	Registrazione movimento a posizione generica
; Prenotazione percorso: il percorso viene prenotato, ma non viene spedito alcun movimento all'agv
internal 0x02000155 AgvAssignPath(uint agv,uint mission,uint user,uchar orientation) : bool
internal 0x02000155 AgvPrenotaPercorso(uint agv,uint mission,uint user,uchar orientation) : bool
internal 0x02000156 AgvAssignPath(uint agv,uint mission,uint line,int position,uchar orientation) : bool
internal 0x02000156 AgvPrenotaPercorso(uint agv,uint mission,uint line,int position,uchar orientation) : bool
; Elimina tutto il percorso non ancora registrato per la spedizione all'agv
internal 0x02000157 AgvUnassignPath(uint uAgv)
internal 0x02000157 AgvRimuoviPrenotazionePercorso(uint uAgv)
;
; Valori di ritorno per funzioni di registrazione movimento
$define EsitoMov_MovimentoCompletato             0	; Fine del tratto prenotato
$define EsitoMov_RaggiuntoWaypoint               1	; Raggiunto waypoint, ce ne sono altri
$define EsitoMov_UserIntermedioRaggiunto         2	; L'agv ha raggiunto l'user desiderato sul tratto prenotato
$define EsitoMov_MovimentoInCorso                3	; Registrato un nuovo tratto di movimento oppure agv in movimento
$define EsitoMov_AttesaTurnoPassaggio            4	; Agv fermo per attesa percorso libero (modalità normale)
$define EsitoMov_AttesaSbloccoPercorso           5	; Agv bloccati sul percorso (non blocco reciproco)
$define EsitoMov_AttesaSemaforo                  6	; Agv fermo per attesa semaforo
$define EsitoMov_DestinazioneSuTrattoPrenotato   8	; Destinazione agv su tratto prenotato (agv bloccato)
$define EsitoMov_UserIntermedioNonEsiste         9	; User intermedio non trovato sul percorso (agv bloccato)
$define EsitoMov_BloccoReciproco                 10	; Un altro agv blocca questo agv e ne è bloccato a sua volta
$define EsitoMov_MovimentoImpossibile            11	; Movimento impossibile (ad esempio per tratti disabilitati dopo la prenotazione)
$define EsitoMov_AgvNonEsiste                    12	; Agv indicato non esiste
$define EsitoMov_WaypointNonEsiste               13	; Nessun waypoint in coda
$define MoveResult_CompletedMovement             0	; Fine del tratto prenotato
$define MoveResult_WaypointReached               1	; Raggiunto waypoint, ce ne sono altri
$define MoveResult_IntermediatePointReached      2	; L'agv ha raggiunto l'user desiderato sul tratto prenotato
$define MoveResult_AgvIsMoving                   3	; Registrato un nuovo tratto di movimento oppure agv in movimento
$define MoveResult_WaitForShift                  4	; Agv fermo per attesa percorso libero (modalità normale)
$define MoveResult_PathIsBlocked                 5	; Agv bloccati sul percorso (non blocco reciproco)
$define MoveResult_WaitForSemaphore              6	; Agv fermo per attesa semaforo
$define MoveResult_DestinationOnAssignedPath     8	; Destinazione agv su tratto prenotato (agv bloccato)
$define MoveResult_IntermediatePointNotFound     9	; User intermedio non trovato sul percorso (agv bloccato)
$define MoveResult_ReciprocalBlock               10	; Un altro agv blocca questo agv e ne è bloccato a sua volta
$define MoveResult_ImpossibleMovement            11	; Movimento impossibile (ad esempio per tratti disabilitati dopo la prenotazione)
$define MoveResult_AgvDoesNotExist               12	; Agv indicato non esiste
$define MoveResult_WaypointDoesNotExist          13	; Nessun waypoint in coda

internal 0x02000158 AgvMuoviSuPrenotazione(uint uagv, uint missione, uint userintermedio = 0) : int	; Registrazione (spedizione all'agv) del percorso prenotato
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Registrazione istruzioni di movimento con waypoint
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000080 AgvAddWaypoint(uint uAgv,uint uLine,int iPos,uchar uVerso) : uint	; Aggiunta di un punto al percorso da eseguire
internal 0x02000081 AgvAddWaypoint(uint uAgv,uint uUserDest,uchar uVerso) : uint		; Aggiunta di un punto al percorso da eseguire
;
; Movimento a waypoint successivo.
; I codici di ritorno usati sono gli stessi della funzione AgvMuoviSuPrenotazione()
; Flag disponibili :
$define WpFl_RicalcolaPercorsi	0x0001	; Ricalcola i percorsi tra un punto e l'altro, cambiandoli se ce ne sono di migliori
$define WpFl_EliminaCompletato	0x0002	; Elimina il waypoint corrente, una volta completato il movimento
internal 0x02000082 AgvMoveToWayPoint(uint uAgv, uint uMission, uint flags = 0) : int
;
; Identificativo waypoint attuale
internal 0x02000083 AgvActualWayPointId(uint uAgv) : uint
;
; Eliminazione waypoint attuale (generazione warning se c'è ancora strada da percorrere)
internal 0x02000084 AgvDeleteActualWaypoint(uint uAgv) : bool
;
; Esattamente uguale alla funzione AgvRimuoviPrenotazionePercorso(uint uAgv)
internal 0x02000085 AgvClearAllWaypoints(uint uAgv)
;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Definizione tipi per prenotazione percorso statica per agv
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$define rdtReserveLastPosition           1	; Riserva l'ultima posiziona comandata all'agv
$define rdtReserveActualPosition         2	; Riserva la posizione attuale dell'agv
;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Flags per impostazione prenotazione percorso statica per agv
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$define rdfUnreserve_explicit            1	; La prenotazione viene rimossa solo su chiamata esplicita
$define rdfUnreserve_newPathAssigned     2	; La prenotazione viene rimossa in seguito all'assegnazione di un nuovo percorso all'agv
$define rdfUnreserve_missionStart        4	; La prenotazione viene rimossa alla chiamata di agvstartmission()
$define rdfUnreserve_missionEnd          8	; La prenotazione viene rimossa alla chiamata di agvstopmission()
$define rdfUnreserve_missionAborted      16	; La prenotazione viene rimossa quando una missione viene abortita
internal 0x02000086 AgvSetPositionReservation(uint uAgv, uint type, uint flags) : bool	; Impedisce ad altri agv di occupare la posizione specificata
internal 0x02000087 AgvReleasePositionReservation(uint uAgv) : bool		; Rilascia la posizione attualmente riservata all'agv
;
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Registrazione MICRO istruzioni
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000160 AgvRegisterOperation(uint uAgv, uint uMis, int iOpeType, int iPar1=0, int iPar2=0, int iPar3=0, int iPar4=0, uint uUser=0)
$define OpeMov_Translate 'T'
$define OpeMov_Rotate 'R'
$define OpeMov_Jump 'J'
;
;	Struttura per definizione dati per operazione con movimento
;
object XMovingOperationData
	uint pObj	; INTERNAL POINTER - DO NOT TOUCH
	internal 0x02000170 Constructor()
	internal 0x02000171 Destructor()
	internal 0x02000172 Init(uint uAgv, uint uMis, int iOpeType, int iPar1 = 0, int iPar2 = 0, int iPar3 = 0, int iPar4 = 0, uint uUser = 0,) : bool
	internal 0x02000173 AppendMovement(char type, real speed, real space) : bool
	internal 0x02000174 AppendJump(int line, int pos, uchar verso) : bool
	internal 0x02000175 AppendJump(int userId) : bool
	internal 0x02000176 AppendJump(real pos_thr, real ang_thr_deg) : bool
endobject
internal 0x02000161 AgvRegisterMovingOperation(uint uAgv, uint uMis, int iOpeType, int iPar1, int iPar2, int iPar3, int iPar4, uint uUser, int nmove, char tm1, real sp1, real pm1, char tm2=0, real sp2=0.0, real pm2=0.0, char tm3=0, real sp3=0.0, real pm3=0.0, char tm4=0, real sp4=0.0, real pm4=0.0) : bool
internal 0x02000162 AgvRegisterMovingOperation(XMovingOperationData @data) : bool
internal 0x02000163 AgvRegisterPassante(uint uAgv, uint uMis, int iOpeType, int iPar1=0, int iPar2=0, int iPar3=0, int iPar4=0, uint uUser=0)
internal 0x02000164 AgvRegisterWait(uint uagv, uint umis, int iopetype=0, int iPar1=0, int iPar2=0, int iPar3=0, int iPar4=0, int iUserId=0)
internal 0x02000165 AgvRegisterSystemPassante(uint uAgv, uint uMis, int iCode, int iPar1=0, int iPar2=0, int iPar3=0, int iPar4=0, uint uUser=0)
internal 0x02000166 AgvRegisterSystemBloccante(uint uAgv, uint uMis, int iCode, int iPar1=0, int iPar2=0, int iPar3=0, int iPar4=0, uint uUser=0)
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione carico su veicolo
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x0200000B AgvExecLoad(uint uAgv, uint uSiteId, int pos_x=0, int pos_y=0) : bool
internal 0x0200000C AgvExecUnload(uint uAgv, uint uSiteId) : bool
internal 0x0200000D AgvSetAgvLoadInfo(uint uAgv, bool bPres, uint uTipo, bool bVasiPieni=true, string nomePallet="", int pos_x=0, int pos_y=0)	; Impostazione diretta carico agv. NB: SetImmagineCaricoAgv() imposta l'immagine visibile quando il carico è presente.
internal 0x0200000D AgvSetInfoCaricoAgv(uint uAgv,bool bPres,uint uTipo,bool bVasiPieni=true,string nomePallet="",int pos_x=0, int pos_y=0)	; Impostazione diretta carico agv. NB: SetImmagineCaricoAgv() imposta l'immagine visibile quando il carico è presente.
internal 0x0200000E SetImmagineCaricoAgv(uint uAgv,string name,bool bVasiPieni=false,int pos_x=0,int pos_y=0)
;
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Funzioni di gestione per tipi di celle/carico
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$define DEFAULT_NUM_TIPI	DEF_NUM_TIPI							; Massimo numero di tipi di celle/carico
internal 0x02000700 AgvSetTypeColor(uint uTipo,uint colore)		; Imposta colore tipo
internal 0x02000701 AgvSetDescTipo(uint uTipo,string desc)		; Imposta descrizione tipo
internal 0x02000702 AgvGetDescTipo(uint uTipo) : string			; Ritorna descrizione tipo
internal 0x02000703 AgvSetMaxNumTipi(int num)						; Imposta numero di tipi utilizzabili
internal 0x02000704 AgvGetTypeColor(uint uTipo) : uint			; Ritorna colore tipo
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione semafori
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$define XSemaforo_nonesiste -1
$define XSemaforo_rosso 0
$define XSemaforo_verde 1
internal 0x02000750 AgvGetSemaphoreRequestMask(uint) : uint			; Ritorna stato richiesta semaforo. Torna la maschera degli agv che stanno chiedendo il semaforo
internal 0x02000750 AgvRichiestaSemaforo(uint) : uint			; Ritorna stato richiesta semaforo. Torna la maschera degli agv che stanno chiedendo il semaforo
internal 0x02000751 AgvSetGreenSemaphore(uint, bool)					; Imposta conferma via libera semaforo
internal 0x02000751 AgvSetSemaforo(uint, bool)					; Imposta conferma via libera semaforo
internal 0x02000752 AgvGetSemaphoreColour(uint) : int					; Torna colore semaforo
internal 0x02000752 AgvGetColoreSemaforo(uint) : int			; Torna colore semaforo
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione punti USER
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Allineamento riguadro rispetto al sito:
$define XSiteTFlag_Up           0x00010000	; Allinea testo sito sopra
$define XSiteTFlag_Down         0x00020000	; Allinea testo sito sotto
$define XSiteTFlag_Left         0x00040000	; Allinea testo sito a destra
$define XSiteTFlag_Right        0x00080000	; Allinea testo sito a sinistra
; Allineamento testo all'interno del riquadro :
$define XSiteTFlag_AlignLeft    0x00000001
$define XSiteTFlag_AlignRight   0x00000002
$define XSiteTFlag_AlignHCenter 0x00000004
$define XSiteTFlag_AlignJustify 0x00000008
$define XSiteTFlag_AlignTop     0x00000020
$define XSiteTFlag_AlignBottom  0x00000040
$define XSiteTFlag_AlignVCenter 0x00000080
$define XSiteTFlag_AlignCenter  0x00000084
internal 0x02000040 SiteExists(uint uCode) : bool							; Esistenza sito
internal 0x02000041 SetSiteStoreTime( int, real )
; Modifica flags punto user, uOp è uno tra OP_SET, OP_OR, OP_AND ed indica
; l'operazione da eseguire bit a bit tra i flag attuali del punto uUser ed i flags uFlags
internal 0x02000056 AgvSetUserFlags(uint uUser, uint uFlags, uint uOp)
$define XSitePropertyFlg_volatile	0x00000001	; Non salvare su disco
$define XSitePropertyFlg_hidden		0x00000002	; Non mostrare su sinottico
internal 0x02000042 AddIntProperty(uint id,string name,string spg,int liv,uint flags=0) : bool	; Aggiunta proprietà di tipo int (par: sito,nome proprietà,spiegazione proprietà, livello richiesto per modifica)
internal 0x02000043 AddStrProperty(uint id,string name,string spg,int liv,uint flags=0) : bool	; Aggiunta proprietà di tipo stringa
internal 0x02000044 SetIntProperty(uint,string,int) : bool			; Set proprietà di tipo int
internal 0x02000045 SetStrProperty(uint,string,string) : bool		; Set proprietà di tipo stringa
internal 0x02000046 SiteHasIntProperty(uint,string) : bool			; Test esistenza proprietà di tipo int
internal 0x02000047 SiteHasStrProperty(uint,string) : bool			; Test esistenza proprietà di tipo string
internal 0x02000048 IntProperty(uint,string) : int					; Valore proprietà di tipo int
internal 0x02000049 StrProperty(uint,string) : string				; Valore proprietà di tipo stringa
; Imposta file immagine per sito con indice id :
; Il parametro ovr, se vero, impedisce che l'immagine possa essere modificata
; a seguito del'impostazione di un pallet con informazioni estese.
internal 0x0200004A SetImmagineSito(uint id,string name,bool ovr=false)
internal 0x0200004B SetSiteAlarm(uint site,bool alarm = true,string txt = "")
internal 0x0200004C SiteInAlarm(uint) : bool
internal 0x02000057 SiteAlarmText(uint id) : string
internal 0x0200004D SetSiteName(uint,string)
internal 0x0200004E GetSiteName(uint) : string
internal 0x0200004F SetSiteText(uint,string,uint flags=0)			; Imposta testo per sito, flags vedere XSiteTFlag_
internal 0x02000050 GetSiteStoreDate(uint) : string					; Ritorna la data di inizio stoccaggio
internal 0x02000051 AgvGetSitePos(int, uint@, int@, uint@) : bool	; sito,linea,posizione,lato
internal 0x02000052 AgvGetSiteInfo(int userid, XSiteInfo @sinfo) : bool
internal 0x02000053 AgvSetSiteInfo(int userid, XSiteInfo @sinfo) : bool
internal 0x02000054 SetSiteTextBgColor(uint id,color bg,color bd=0,uchar alpha=255)	; Imposta colore sfondo (bg), colore bordo (bd) e trasparenza (alpha) per testo sito
internal 0x02000054 SetSiteNameBgColor(uint id,color bg,color bd=0,uchar alpha=255)	; DEPRECATED
internal 0x02000055 SetSiteVisibility(uint id,bool bVisible)		; Imposta visibilità sito
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione Input/Output
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000060 AgvGetInput(uint) : bool			; Legge un singolo bit
; legge una intera input word. L'offset è a DWord (32 bit)
internal 0x02000061 AgvGetInputDWord(uint offset,uint @val) : bool
; Per le funzioni seguenti l'offset è a byte, il formato è little endian (standard Intel). Il primo byte ha offset 0
internal 0x02000062 AgvGetInputAsU8(uint offset) : uchar
internal 0x02000063 AgvGetInputAsI16(uint offset) : short
internal 0x02000064 AgvGetInputAsU16(uint offset) : ushort
internal 0x02000065 AgvGetInputAsI32(uint offset) : int
internal 0x02000066 AgvGetInputAsU32(uint offset) : uint
internal 0x02000067 AgvGetInputAsString(uint offset,uint length) : string
; Imposta singolo bit
internal 0x02000068 AgvSetOutput(uint,bool=true)
; Imposta una intera output word. L'offset è a word (16 bit)
internal 0x02000069 AgvSetOutputDWord(uint offset,uint val) : bool
; Per le funzioni seguenti l'offset è a byte. Il primo byte ha offset 0
internal 0x0200006A AgvSetOutputAsU8(uint offset,uchar val)
internal 0x0200006B AgvSetOutputAsI16(uint offset,short val)
internal 0x0200006C AgvSetOutputAsU16(uint offset,ushort val)
internal 0x0200006D AgvSetOutputAsI32(uint offset,int val)
internal 0x0200006E AgvSetOutputAsU32(uint offset,uint val)
internal 0x0200006F AgvSetOutputAsString(uint offset,uint length,string val)
; Per le funzioni seguenti l'offset è a byte, il formato è big endian (standard Motorola/Siemens). Il primo byte ha offset 0
internal 0x020000A0 AgvGetInputAsI16_be(uint offset) : short
internal 0x020000A1 AgvGetInputAsU16_be(uint offset) : ushort
internal 0x020000A2 AgvGetInputAsI32_be(uint offset) : int
internal 0x020000A3 AgvGetInputAsU32_be(uint offset) : uint
internal 0x020000A8 AgvSetOutputAsI16_be(uint offset,short val)
internal 0x020000A9 AgvSetOutputAsU16_be(uint offset,ushort val)
internal 0x020000AA AgvSetOutputAsI32_be(uint offset,int val)
internal 0x020000AB AgvSetOutputAsU32_be(uint offset,uint val)
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione veicoli
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000100 AgvSetAlarm(uint,bool,string="")		; Allarme generale
internal 0x02000101 AgvSetAbilitato(uint,bool)
internal 0x02000102 AgvSetIgnorato(uint,bool)
internal 0x02000103 AgvActualMissionCode(uint) : uint			; Ritorna codice missione attuale (0 == MIS_NULL)
internal 0x02000104 AgvAbilitato(uint) : bool
internal 0x02000105 AgvIgnorato(uint) : bool
internal 0x02000106 AgvDisabTermineMissione(uint)
internal 0x02000107 AgvInAutomatico(uint) : bool
internal 0x02000108 AgvGetLastUserID(uint) : uint
internal 0x02000109 AgvNonComunica(uint) : bool
internal 0x0200010A AgvReadyForNewMission(uint) : bool
;
; Flags cambio stato agv :
$define STATO_VCL_IGNORA            1	; Richiesta ignora veicolo
$define STATO_VCL_CERCA             2	; Ricerca veicolo
$define STATO_VCL_ANNULLA_MISSIONE  4	; Richiesta annullamento missione in corso
internal 0x0200010C FlagsCambioStatoAgv(uint) : uint
internal 0x0200010D SetAgvStatusDescription(uint uAgv,int stId,string desc)
internal 0x0200010D SetDescStatoAgv(uint uAgv,int stId,string desc)
internal 0x0200010E GetCodiceAllarmeAgv(uint uAgv) : int						; Ritorna codice allarme attuale ( codAll | codAx << 16 )
internal 0x0200010E VehicleAlarmCode(uint uAgv) : int						; Ritorna codice allarme attuale ( codAll | codAx << 16 )
internal 0x0200010B VehicleAlarmString(uint uAgv, bool stripCode = false) : string					; Ritorna stringa allarme attuale
; Aggiunta di un elemento alla lista dei siti interessati dalla missione dell'agv
;	- Al sito viene impostato il flag UF_RESERVED
;	- Al termine della missione, i siti rimasti in lista vengono automaticamente rimossi
internal 0x0200010F AddToMissionUserList(uint uAgv, uint uUser)
internal 0x0200010F AddToListaSitiMissione(uint uAgv, uint uUser)
internal 0x02000110 RemoveFromMissionUserList(uint uAgv, uint uUser)	; Rimozione elemento da lista
internal 0x02000110 RemoveFromListaSitiMissione(uint uAgv, uint uUser)	; Rimozione elemento da lista
;
;	Manda comandi al veicolo anche se non è in missione.
;	Viene inviato codice di missione 0. Non usare se agv in missione!
internal 0x02000111 AgvDirectOperation(uint uagv, int ope, int par1=0, int par2=0, int par3=0, int par4=0)
internal 0x02000112 AgvDirectPassante(uint uagv, int ope, int par1=0, int par2=0, int par3=0, int par4=0)
internal 0x02000113 AgvDirectWait(uint uagv, int ope, int par1=0, int par2=0, int par3=0, int par4=0)
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione lettura registri
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$define Reg_R    1	; Registro intero volatile
$define Reg_RR   2	; Registro reale volatile
$define Reg_NVR  3	; Registro intero non volatile
$define Reg_NVRR 4	; Registro reale non volatile
$define Reg_SR   5	; Registro stringa volatile
internal 0x02000120 StartReadRegister(uint agv,int type,int index,string desc="")			; Inizia lettura invalidando, se presente, la precedente
internal 0x02000121 RegisterValueReady(uint agv,int type,int index,bool soloNuovo=true) : bool	; Test lettura effettuata.
internal 0x02000122 RegisterIntValue(uint agv,int type,int index) : int						; Ritorna valore registro (se lettura non effettuata torna 0)
internal 0x02000123 RegisterRealValue(uint agv,int type,int index) : real					; Ritorna valore registro (se lettura non effettuata torna 0.0)
internal 0x02000124 RegisterStringValue(uint agv,int type,int index) : string				; Ritorna valore registro (se lettura non effettuata torna "")
internal 0x02000125 StartWriteRegister(uint agv,int type,int index,int val) : bool			; Mette in coda la scrittura senza invalidare eventuali precedenti valori
internal 0x02000126 StartWriteRegister(uint agv,int type,int index,real val)			; Mette in coda la scrittura senza invalidare eventuali precedenti valori
internal 0x02000127 RegisterWritten(uint agv,int type,int index) : bool					; Test scrittura effettuata
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Gestione testo su sinottico
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000200 NewText(int,int,string,bool=true,bool=false) : int	; Prende pos.testo, testo, se visibile, se mobile e restituisce id.testo
internal 0x02000201 SetTextPosition( int, int, int )					; ( id.testo, posX, posY ) Setta posizione testo nel sinottico
internal 0x02000202 SetText( int, string, uint=0 )						; Modifica testo (ultimo par. = colore)
internal 0x02000203 RemoveText( int )									; Rimuove stringa da sinottico
internal 0x02000204 ShowText(int,bool)
internal 0x02000205 SetTextPointSize(int,int)
internal 0x02000206 SetTextBackground(int,color bg,color bc,uchar alpha=255)	; Impostazione colore sfondo(bg), colore bordo(bc) e trasparenza(alpha): alpha = 0 invisibile, alpha = 255 opaco
internal 0x02000207 SetTextFont(int,string)								; Impostazione font.
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Funzioni miscellanee
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
internal 0x02000030 AmmazzaAgv(uint uagv)									; Spedisce comando [A]mmazza ad Agv
internal 0x02000031 AgvGetUserLineID(uint) : uint
internal 0x02000032 SetVersioneManager(uint ver,string desc="")
internal 0x02000033 SetAgvMessage(uint uagv, string txt)					; Impostazione messaggio su dispan agv
internal 0x02000034 AgvForceAbortMission(uint uagv,string desc="")	; Abortisce missione in corso (non disabilita il veicolo)
internal 0x02000035 AgvChangeMission(uint uagv,uint umis,string desc)				; Cambia al volo la missione in corso
;
; Pone domanda all'operatore. Primo parametro : titolo finestra. Secondo : testo domanda
$define XDIALOG_YES 16384
$define XDIALOG_NO 65536
internal 0x04000097 DialogoSiNo(string,string) : int 
internal 0x04000098 MultiMessageState( int, string )			; Messaggi con codici diversi vengono alternati sulla barra delle informazioni
internal 0x04000099 MessageBox(string)							; Messaggio
internal 0x0400009A MessageBox(string,string)					; Titolo,messaggio
internal 0x0400009B beep()										; Emissione di un bip sul PC
internal 0x04000100 MessageState( string )						; Messaggio classico sulla status bar
internal 0x04000101 OnNextMissionDebugMessage(int, string)			; Messaggio debug generazione missione agv
internal 0x04000101 MessaggioDebugMissione(int,string)			; Messaggio debug generazione missione agv
internal 0x04000102 AddCmdButton(int,string,int=LIV_QUAL_USER1)		; Aggiunta pulsante che genera comando specificato, disponibile per livello di accesso >= a quello specificato
; Bisogna implementare una funzione OnCmdButton(int) che reagisce ai vari comandi
internal 0x04000103 AddUserCustomCmd(uint user,int cmd,string txt,int level=0)			; Aggiunta voce di menu ad user specificato (user,comando,stringa,livello accesso minimo)
internal 0x04000104 SetUserCmdStatus(uint,int,bool,bool)				; Impostazione visibilita/abilitazione comando user
internal 0x04000105 SetUserCmdText(uint,int,string)					; Impostazione testo comando user
; Bisogna implementare una funzione OnSiteCustomCmd(uint user,int cmd) di risposta
internal 0x04000106 AddAgvCustomCmd(uint,int,string,int=0)			; Aggiunta voce di menu ad agv specificato (agv,comando,stringa,livello accesso minimo)
internal 0x04000107 SetAgvCmdStatus(uint uagv,int cmdid,bool,bool)	; Impostazione visibilita/abilitazione comando agv
internal 0x04000108 SetAgvCmdText(uint uagv,int cmdid,string txt)		; Impostazione testo comando agv
; Bisogna implementare una funzione OnAgvCustomCmd(uint uAgv,int cmd) di risposta
;
; Definizione posizione assoluta
;
;	Posizione assoluta su impianto
;
object XAbsPos
	int x		; Coordinata X [mm]
	int y		; Coordinata Y [mm]
	int alfa	; Angolo [gradi]
endobject
internal 0x04000110 GetAgvAbsPosition(uint uAgv,XAbsPos @) : bool		; Torna la posizione attuale dell'agv nelle coordinate della mappa
internal 0x04000111 GetUserAbsPosition(uint uUserId,XAbsPos @) : bool	; Torna la posizione dell'user nelle coordinate della mappa
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;    Gestione pulsanti di comando    ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;
;	Gestione pulsanti aggiuntivi interfaccia AgvManager
;
object XPulsanteComando
	uint pObj	; INTERNAL POINTER - DO NOT TOUCH
	internal 0x04000200 Constructor()
	internal 0x04000201 Destructor()
	; Parametri:
	; cmd -> Indice comando
	; txt -> Testo associato
	; liv -> Livello di accesso per selezione
	; pos -> Indica il nome della toolbar a cui aggiungere il pulsante
	internal 0x04000202 init(int cmd,string txt,int liv=LIV_QUAL_USER1,string pos="")
	; Parametri:
	; cmd -> Indice comando
	; img -> Immagine associata
	; liv -> Livello di accesso per selezione
	; pos -> Indica il nome della toolbar a cui aggiungere il 
	internal 0x04000203 initAction(int cmd,string img,int liv=LIV_QUAL_USER1,string pos="")
	; Metodi
	internal 0x04000210 setVisible(bool)
	internal 0x04000211 setEnabled(bool)
	internal 0x04000212 setText(string)
	internal 0x04000213 setPixmap(string)
endobject
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;    Gestione comandi diretti al veicolo    ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
internal 0x02000300 SetDirectCmd(uint,string) : bool			; Spedisce comando diretto ad agv
internal 0x02000301 GetDirectAsw(uint) : string					; Restituisce risposta agv
internal 0x02000302 IsDirectAswReady(uint) : bool				; Test risposta pronta
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;    Gestione calcolo percorsi    ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;
;	Gestione calcolo percorsi
;
object XCalcoloPercorsi
	uint pObj	; INTERNAL POINTER - DO NOT TOUCH
	internal 0x02000400 Constructor()
	internal 0x02000401 Destructor()
	; Modalità d'uso:
	; - Definire il punto base dei percorsi e calcolare i percorsi con CalcMinPathTree()
	; - Interrogare i risultati con getDistance()
	;
	; * * * Funzioni da usare * * *
	;
	; Calcola l'albero dei percorsi minimi centrato su un user
	internal 0x02000402 CalcMinPathTree(uint uAgv,uint uRootUser,uchar uRootDirV,bool bNoPreInUse) : bool
	; Calcola l'albero dei percorsi minimi centrato su una posizione generica
	internal 0x02000403 CalcMinPathTree(uint uAgv,XDefPosizioneAgv @,bool bNoPreInUse=false) : bool
	; Calcola l'albero dei percorsi minimi centrato sull'ultimo punto di movimento registrato per
	; l'agv specificato (NB: equivale alla posizione attuale dell'agv solo se l'agv è fermo!)
	internal 0x02000404 CalcMinPathTree(uint uAgv,bool bNoPreInUse) : bool
	internal 0x02000405 GetDistance(uint uAgv,uint uLine,int iPos,uchar uDirV) : real
	internal 0x02000406 GetDistance(uint uAgv,XDefPosizioneAgv @dest) : real
	internal 0x02000407 GetDistance(uint uAgv,uint uUser,uchar uDirV) : real
	; Impostazione della maschera degli agv che spezzano il percorso (non si passa dove c'è un agv)
	internal 0x02000408 SetAgvDaEvitare(uint uMask)
	; Il parametro dest della funzione UserSuPercorso() serve come input per definire la
	; destinazione dell'agv, e come output per definire come si passa sul punto stesso
	internal 0x02000410 UserSuPercorso(uint uAgv,uint uUserTest,XDefPosizioneAgv @dest) : bool
	; Determina se uUserTest si trova sul percorso per andare a uUserDest con verso uDirVDest
	; mettendo in dest le info di arrivo su uUserTest
	internal 0x02000411 UserSuPercorso(uint uAgv,uint uUserTest,uint uUserDest,uchar uDirVDest,XDefPosizioneAgv @dest) : bool
endobject
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;    Gestione seriale rs232    ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;
;	Gestione seriale rs232
;
object XRs232
	uint pObj	; INTERNAL POINTER - DO NOT TOUCH
	internal 0x02000500 Constructor()
	internal 0x02000501 Destructor()
	internal 0x02000502 Open(string) : bool				; Passare COM1|COM2|...
	internal 0x02000503 SetBaudRate(int)
	internal 0x02000504 SetParity(int)
	internal 0x02000505 SetDataAndStopBits(uint,uint)	; Bit di dati e bit di stop
	internal 0x02000506 IsOpen() : bool
	internal 0x02000507 Close()
	internal 0x02000510 SendString(string) : int		; Spedisce stringa
;	internal 0x02000511 ReadLine() : string					; Legge linea su stringa (deve terminare con 0x0A)
endobject
;~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;    Gestione lista siti    ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;
;	Gestione lista siti
;
object XListaSiti
	uint pObj	; INTERNAL POINTER - DO NOT TOUCH
	internal 0x02000600 Constructor()
	internal 0x02000601 Destructor()
	internal 0x02000602 IsEmpty() : bool		; Test se lista vuota
	internal 0x02000603 Count() : uint			; Ritorna numero siti in lista
	internal 0x02000604 Prepend(uint)			; Aggiunge sito in testa alla lista
	internal 0x02000604 AddHead(uint)			; DEPRECATED
	internal 0x02000605 Append(uint)			; Aggiunge sito in coda alla lista
	internal 0x02000605 AddTail(uint)			; DEPRECATED
	internal 0x02000606 Find(uint) : uint		; Torna posizione sito in lista (-1 se non trovato)
	internal 0x02000607 RemoveFirst() : uint	; Rimuove il primo sito dalla lista, e ne torna il valore
	internal 0x02000607 RemoveHead() : uint		; DEPRECATED
	internal 0x02000608 RemoveLast() : uint		; Rimuove l'ultimo sito dalla lista, e ne torna il valore
	internal 0x02000608 RemoveTail() : uint		; DEPRECATED
	internal 0x02000609 RemoveAt(uint) : uint	; Rimuove il sito alla posizione specificata (ritorna l'indice del sito rimosso)
	internal 0x0200060A RemoveAll()				; Svuota la lista
	internal 0x0200060B At(uint) : uint			; Torna l'indice del sito alla posizione specificata
	internal 0x0200060C SetFlag(uint)			; Impostazione flag da settare per tutti i siti in lista
	internal 0x0200060D AllFlags() : uint		; Torna l'or binario dei flags di tutti i siti in lista
	internal 0x0200060E contains(uint) : bool	; Test user presente in lista
endobject
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;    Funzioni chiamate dal plantmanager    ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
forward OnApplicationStart () : bool
forward OnApplicationStop  () : bool
forward OnNextMission      (uint) : uint
forward OnGetMissionText   (uint, uint) : string
forward OnAbortMission     (uint)
forward OnExpandMacro      (uint uAgv,uint uMission,uint uCode,int iPar1,int iPar2,int iPar3,int iPar4) : bool
forward OnExecuteMicro     (uint uAgv,bool bUltimaChiam,int iCodice, int iPar0,int iPar1,int iPar2,int iPar3,int iPar4,int iUserId,int iMission,int iCommand) : bool
forward OnCommandInterpreter(string cmdStr,int iLivQualAct) : bool
forward OnAgvModeChange(uint,uint,uint)	; uAgv, oldMode, newMode
forward OnUpdateIO         (int IO_DW,int IO_DW,uint uInAlarm)	; I primi due parametri contengono il numero massimo di DWORD di I/O scambiabili (2048, pari a 65536 byte)
;~~~~~~~~~~~~~~~~~~~~~~~~~~;
;    Funzioni opzionali    ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~;
; code VerificaCambioTipo(uint uSito,uint uNuovoTipo) : bool
;
; code onRichiestaModificaSito(uint) : bool
; Deve tornare true se lo script si occupa della modifica del sito, se torna false
; viene mostrata la finestra standard.
;
$define ID_PRIMO_START        48001
$define ID_PRIMO_CBAT         49001
;
; Identificativo del primo punto di start
$define ID_FIRST_START_P      48001
; Identificativo del primo carica batterie
$define ID_FIRST_CBT          49001
; Identificativo del primo punto generico senza codice assegnato in mappa
$define ID_FIRST_AUTO_ID_USER 49001