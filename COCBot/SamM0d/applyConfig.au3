; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........:
; Parameters ....:
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ ; Multi Finger (LunaEclipse)
;~ _GUICtrlComboBox_SetCurSel($cmbDBMultiFinger,$iMultiFingerStyle)
;~ cmbDBMultiFinger()
;~ cmbDeployDB()
;~ cmbDeployAB()

; prevent over donate
If $ichkEnableLimitDonateUnit = 1 Then
	GUICtrlSetState($chkEnableLimitDonateUnit, $GUI_CHECKED)
Else
	GUICtrlSetState($chkEnableLimitDonateUnit, $GUI_UNCHECKED)
EndIf
GUICtrlSetData($txtLimitDonateUnit, $itxtLimitDonateUnit)


; Unit Wave Factor
If $ichkUnitFactor = 1 Then
	GUICtrlSetState($chkUnitFactor, $GUI_CHECKED)
Else
	GUICtrlSetState($chkUnitFactor, $GUI_UNCHECKED)
EndIf
GUICtrlSetData($txtUnitFactor, $itxtUnitFactor)

If $ichkWaveFactor = 1 Then
	GUICtrlSetState($chkWaveFactor, $GUI_CHECKED)
Else
	GUICtrlSetState($chkWaveFactor, $GUI_UNCHECKED)
EndIf
GUICtrlSetData($txtWaveFactor, $itxtWaveFactor)

chkUnitFactor()
chkWaveFactor()

; SmartZap from ChaCalGyn (LunaEclipse) - DEMEN
; ExtremeZap - Added by TheRevenor

If $ichkUseSamM0dZap = 1 Then
	GUICtrlSetState($chkUseSamM0dZap, $GUI_CHECKED)
Else
	GUICtrlSetState($chkUseSamM0dZap, $GUI_UNCHECKED)
EndIf

If $ichkSmartZapDB = 1 Then
	GUICtrlSetState($chkSmartZapDB, $GUI_CHECKED)
Else
	GUICtrlSetState($chkSmartZapDB, $GUI_UNCHECKED)
EndIf

If $ichkSmartZapSaveHeroes = 1 Then
	GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_CHECKED)
Else
	GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_UNCHECKED)
EndIf

If $itxtMinDE <= 0 Then
	$itxtMinDE = 400
EndIf
GUICtrlSetData($txtMinDark2, $itxtMinDE)

; samm0d zap
If $ichkSmartZapRnd = 1 Then
	GUICtrlSetState($chkSmartZapRnd, $GUI_CHECKED)
Else
	GUICtrlSetState($chkSmartZapRnd, $GUI_UNCHECKED)
EndIf

If $ichkDrillExistBeforeZap = 1 Then
	GUICtrlSetState($chkDrillExistBeforeZap, $GUI_CHECKED)
Else
	GUICtrlSetState($chkDrillExistBeforeZap, $GUI_UNCHECKED)
EndIf

If $ichkPreventTripleZap = 1 Then
	GUICtrlSetState($chkPreventTripleZap, $GUI_CHECKED)
Else
	GUICtrlSetState($chkPreventTripleZap, $GUI_UNCHECKED)
EndIf

GUICtrlSetData($txtMinDEGetFromDrill, $itxtMinDEGetFromDrill)

cmbZapMethod()

; Check Collectors Outside - Added by TheRevenor
If $ichkDBMeetCollOutside = 1 Then
	GUICtrlSetState($chkDBMeetCollOutside, $GUI_CHECKED)
Else
	GUICtrlSetState($chkDBMeetCollOutside, $GUI_UNCHECKED)
EndIf

If $ichkDBCollectorsNearRedline = 1 Then
	GUICtrlSetState($chkDBCollectorsNearRedline, $GUI_CHECKED)
Else
	GUICtrlSetState($chkDBCollectorsNearRedline, $GUI_UNCHECKED)
EndIf

_GUICtrlComboBox_SetCurSel($cmbRedlineTiles,$icmbRedlineTiles)

If $ichkSkipCollectorCheckIF = 1 Then
	GUICtrlSetState($chkSkipCollectorCheckIF, $GUI_CHECKED)
Else
	GUICtrlSetState($chkSkipCollectorCheckIF, $GUI_UNCHECKED)
EndIf

GUICtrlSetData($txtDBMinCollOutsidePercent, $iDBMinCollOutsidePercent)
GUICtrlSetData($txtSkipCollectorGold, $itxtSkipCollectorGold)
GUICtrlSetData($txtSkipCollectorElixir, $itxtSkipCollectorElixir)
GUICtrlSetData($txtSkipCollectorDark, $itxtSkipCollectorDark)

If $ichkSkipCollectorCheckIFTHLevel = 1 Then
	GUICtrlSetState($chkSkipCollectorCheckIFTHLevel, $GUI_CHECKED)
Else
	GUICtrlSetState($chkSkipCollectorCheckIFTHLevel, $GUI_UNCHECKED)
EndIf
GUICtrlSetData($txtIFTHLevel, $itxtIFTHLevel)

chkDBMeetCollOutside()

; drop cc first
If $ichkDropCCFirst = 1 Then
	GUICtrlSetState($chkDropCCFirst, $GUI_CHECKED)
Else
	GUICtrlSetState($chkDropCCFirst, $GUI_UNCHECKED)
EndIf


; Check League For DeadBase
If $iChkNoLeague[$DB] = 1 Then
	GUICtrlSetState($chkDBNoLeague, $GUI_CHECKED)
Else
	GUICtrlSetState($chkDBNoLeague, $GUI_UNCHECKED)
EndIf

If $iChkNoLeague[$LB] = 1 Then
	GUICtrlSetState($chkABNoLeague, $GUI_CHECKED)
Else
	GUICtrlSetState($chkABNoLeague, $GUI_UNCHECKED)
EndIf

; HLFClick By Samkie
If $ichkEnableHLFClick = 1 Then
	GUICtrlSetState($chkEnableHLFClick, $GUI_CHECKED)
Else
	GUICtrlSetState($chkEnableHLFClick, $GUI_UNCHECKED)
EndIf

GUICtrlSetData($sldHLFClickDelayTime, $isldHLFClickDelayTime)
chkEnableHLFClick()
sldHLFClickDelayTime()

If $EnableHMLSetLog = 1 Then
	GUICtrlSetState($chkEnableHLFClickSetlog, $GUI_CHECKED)
Else
	GUICtrlSetState($chkEnableHLFClickSetlog, $GUI_UNCHECKED)
EndIf

; advanced update for wall by Samkie
If $ichkSmartUpdateWall = 1 Then
	GUICtrlSetState($chkSmartUpdateWall, $GUI_CHECKED)
Else
	GUICtrlSetState($chkSmartUpdateWall, $GUI_UNCHECKED)
EndIf
GUICtrlSetData($txtClickWallDelay, $itxtClickWallDelay)
chkSmartUpdateWall()

; samm0d ocr
If $ichkEnableCustomOCR4CCRequest = 1 Then
	GUICtrlSetState($chkEnableCustomOCR4CCRequest, $GUI_CHECKED)
Else
	GUICtrlSetState($chkEnableCustomOCR4CCRequest, $GUI_UNCHECKED)
EndIf

; auto dock
If $ichkAutoDock = 1 Then
	GUICtrlSetState($chkAutoDock, $GUI_CHECKED)
Else
	GUICtrlSetState($chkAutoDock, $GUI_UNCHECKED)
EndIf

If $g_bChkAutoHideEmulator Then
	GUICtrlSetState($chkAutoHideEmulator, $GUI_CHECKED)
Else
	GUICtrlSetState($chkAutoHideEmulator, $GUI_UNCHECKED)
EndIf

If $g_bChkAutoMinimizeBot Then
	GUICtrlSetState($chkAutoMinimizeBot, $GUI_CHECKED)
Else
	GUICtrlSetState($chkAutoMinimizeBot, $GUI_UNCHECKED)
EndIf


; CSV Deployment Speed Mod
GUICtrlSetData($sldSelectedSpeedDB, $isldSelectedCSVSpeed[$DB])
GUICtrlSetData($sldSelectedSpeedAB, $isldSelectedCSVSpeed[$LB])
sldSelectedSpeedDB()
sldSelectedSpeedAB()

;_GUICtrlComboBox_SetCurSel($cmbCoCVersion,$icmbCoCVersion)
;cmbCoCVersion()

_GUICtrlComboBox_SetCurSel($cmbTroopSetting,$icmbTroopSetting)

_GUICtrlComboBox_SetCurSel($cmbMyQuickTrain,$icmbMyQuickTrain)

If $ichkDisablePretrainTroops = 1 Then
	GUICtrlSetState($chkDisablePretrainTroops, $GUI_CHECKED)
Else
	GUICtrlSetState($chkDisablePretrainTroops, $GUI_UNCHECKED)
EndIf

; wait 4 cc
If $ichkWait4CC = 1 Then
	GUICtrlSetState($chkWait4CC, $GUI_CHECKED)
Else
	GUICtrlSetState($chkWait4CC, $GUI_UNCHECKED)
EndIf
GUICtrlSetData($txtCCStrength, $CCStrength)
chkWait4CC()

; check 4 cc
If $ichkCheck4CC = 1 Then
	GUICtrlSetState($chkCheck4CC, $GUI_CHECKED)
Else
	GUICtrlSetState($chkCheck4CC, $GUI_UNCHECKED)
EndIf
GUICtrlSetData($txtCheck4CCWaitTime, $itxtCheck4CCWaitTime)
chkCheck4CC()

; global delay increse
If $ichkIncreaseGlobalDelay = 1 Then
	GUICtrlSetState($chkIncreaseGlobalDelay, $GUI_CHECKED)
Else
	GUICtrlSetState($chkIncreaseGlobalDelay, $GUI_UNCHECKED)
EndIf
GUICtrlSetData($txtIncreaseGlobalDelay, $itxtIncreaseGlobalDelay)
chkIncreaseGlobalDelay()

; stick to train page
GUICtrlSetData($txtStickToTrainWindow, $itxtStickToTrainWindow)
txtStickToTrainWindow()


If $ichkCustomTrain = 1 Then
	GUICtrlSetState($chkCustomTrain, $GUI_CHECKED)
Else
	GUICtrlSetState($chkCustomTrain, $GUI_UNCHECKED)
EndIf


; My Troops
If $ichkMyTroopsOrder = 1 Then
	GUICtrlSetState($chkMyTroopsOrder, $GUI_CHECKED)
Else
	GUICtrlSetState($chkMyTroopsOrder, $GUI_UNCHECKED)
EndIf

If $ichkEnableDeleteExcessTroops = 1 Then
	GUICtrlSetState($chkEnableDeleteExcessTroops, $GUI_CHECKED)
Else
	GUICtrlSetState($chkEnableDeleteExcessTroops, $GUI_UNCHECKED)
EndIf

For $i = 0 To UBound($MyTroops)-1
	GUICtrlSetData(Eval("txtMy" & $MyTroops[$i][0]), $MyTroops[$i][3])
	_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MyTroops[$i][0] & "Order"), $MyTroops[$i][1]-1)
Next

chkMyTroopOrder()

If $ichkMySpellsOrder = 1 Then
	GUICtrlSetState($chkMySpellsOrder, $GUI_CHECKED)
Else
	GUICtrlSetState($chkMySpellsOrder, $GUI_UNCHECKED)
EndIf

If $ichkEnableDeleteExcessSpells = 1 Then
	GUICtrlSetState($chkEnableDeleteExcessSpells, $GUI_CHECKED)
Else
	GUICtrlSetState($chkEnableDeleteExcessSpells, $GUI_UNCHECKED)
EndIf

If $ichkForcePreBrewSpell = 1 Then
	GUICtrlSetState($chkForcePreBrewSpell, $GUI_CHECKED)
Else
	GUICtrlSetState($chkForcePreBrewSpell, $GUI_UNCHECKED)
EndIf

For $i = 0 To UBound($MySpells)-1
	If Eval("ichkPre" & $MySpells[$i][0]) = 1 Then
		GUICtrlSetState(Eval("chkPre" & $MySpells[$i][0]), $GUI_CHECKED)
	Else
		GUICtrlSetState(Eval("chkPre" & $MySpells[$i][0]), $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData(Eval("txtNum" & $MySpells[$i][0] & "Spell"), Eval("i" & $MySpells[$i][0] & "SpellComp"))
	_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MySpells[$i][0] & "Order"), $MySpells[$i][1]-1)
Next

chkMySpellOrder()

GUICtrlSetData($txtTotalCountSpell2, $g_iTotalSpellValue)

lblMyTotalCountSpell()

_GUI_Value_STATE("HIDE",$g_aGroupListTHLevels)
If $g_iTownHallLevel >= 4 And $g_iTownHallLevel <= 11 Then
	GUICtrlSetState($g_ahPicTHLevels[$g_iTownHallLevel], $GUI_SHOW)
EndIf

GUICtrlSetData($g_hLblTHLevels, $g_iTownHallLevel)