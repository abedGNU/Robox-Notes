" Vim syntax file
" Language:    xscript
" Maintainer:  Abed <abed@robox.com.cn>
" Last Change: 2018 March 28
" Filenames:	*.xs


" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

"
"
"
syn keyword xscriptKeyword and or return true false continue break not

syn keyword xscriptConstant VST_CARICO_PRESENTE MIC_MOVE MIC_CURVE MIC_ROTATION MIC_OPERATION MIC_SYSTEM MIC_PASSANTE MIC_WAIT O_UNLOAD O_LOAD O_CHARGE S_END S_CHARGE_STOP S_CHARGE_START O_CHARGE_START VST_EXEC_COMANDO S_CHARGE_WAIT O_CHARGE_STOP EsitoMov_MovimentoCompletato EsitoMov_RaggiuntoWaypoint



syn keyword xscriptConditional if elsif else select case default break
syn keyword xscriptBoolean true false TRUE FALSE

syn keyword xscriptPreProc $include

syn keyword xscriptStdFunc qt_warning

syn keyword xscriptFunc OnApplicationStart OnApplicationStop OnNextMission OnAbortMission OnExpandMacro OnExecuteMicro OnAgvStatusChange OnAgvModeChange OnAgvDroppedToPoint OnUpdateIO OnCommandInterpreter OnGetMissionText 

syn keyword xscriptFunc OnNextMissionDebugMessage SiteExists AgvGetVehicleInfo AgvGetSiteInfo SetAccessLevelForOperation AddIntProperty AgvGetSemaphoreRequestMask AgvGetInput AgvSetOutput AgvSetGreenSemaphore IntProperty SetIntProperty qt_debug MessageBox SetAgvStatusDescription SetVersioneManager AgvGetMapParams AgvSetMapParams AgvSetLunghezzaMove StrFormat qt_warning MultiMessageState GetSiteName AgvGetUserFlags AgvRegisterOperation AgvRegisterSystemBloccante SetAgvMessage AgvComputeNextMacro AgvStopMission AgvAddMacro MessageState AgvExecLoad EMUAGV_SetFlags AgvRegisterMoveTo AssignedPathLength AgvMoveToWayPoint

syn keyword xscriptType int bool real $define $undef $include XListaSiti XSiteInfo XVehicleInfo XMapParams uint XForm XSettings timeout 

syn keyword xscriptStorage code forward
syn keyword xscriptStructure object

"
"
"
syn match xscriptComment ";.*$"

syntax match xscriptOperator "\v\*"
syntax match xscriptOperator "\v/"
syntax match xscriptOperator "\v\+"
syntax match xscriptOperator "\v-"
syntax match xscriptOperator "\v\="
syntax match xscriptOperator "\v\?"

syntax match xscriptOperator "\v\*\="
syntax match xscriptOperator "\v/\="
syntax match xscriptOperator "\v\+\="
syntax match xscriptOperator "\v-\="
syntax match xscriptOperator "\v\>\="
syntax match xscriptOperator "\v\<\="
syntax match xscriptOperator "\v\<\>"
syntax match xscriptOperator "\v\!\="

"
"
"
syntax region xscriptString start=/\v"/ skip=/\v\\./ end=/\v"/

"
"
"
hi def link xscriptType Type
hi def link xscriptConstant Constant
hi def link xscriptStdFunc Function
hi def link xscriptFunc Function
hi def link xscriptMethod Function
hi def link xscriptModule Identifier
hi def link xscriptStorage StorageClass
hi def link xscriptStructure		Structure

hi def link xscriptBoolean		Boolean

hi def link xscriptConditional	Conditional
hi def link xscriptOperator		Operator
hi def link xscriptPreProc		PreProc

hi def link xscriptComment			Comment
highlight link xscriptKeyword Keyword
highlight link xscriptString String

