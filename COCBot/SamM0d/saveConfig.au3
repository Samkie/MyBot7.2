; #FUNCTION# ====================================================================================================================
; Name ..........: saveConfig.au3
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Multi Finger (LunaEclipse)
IniWriteS($g_sProfileConfigPath, "MultiFinger", "Select", _GUICtrlComboBox_GetCurSel($cmbDBMultiFinger))

; Unit Wave Factor
If GUICtrlRead($chkUnitFactor) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "SetSleep", "EnableUnitFactor", 1)
Else
	IniWriteS($g_sProfileConfigPath, "SetSleep", "EnableUnitFactor", 0)
EndIf
IniWriteS($g_sProfileConfigPath, "SetSleep", "UnitFactor", GUICtrlRead($txtUnitFactor))

If GUICtrlRead($chkWaveFactor) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "SetSleep", "EnableWaveFactor", 1)
Else
	IniWriteS($g_sProfileConfigPath, "SetSleep", "EnableWaveFactor", 0)
EndIf
IniWriteS($g_sProfileConfigPath, "SetSleep", "WaveFactor", GUICtrlRead($txtWaveFactor))


; SmartZap Settings from ChaCalGyn (LunaEclipse) - DEMEN

If GUICtrlRead($chkUseSamM0dZap) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "Zap", "SamM0dZap", 1)
Else
	IniWrite($g_sProfileConfigPath, "Zap", "SamM0dZap", 0)
EndIf


If GUICtrlRead($chkSmartZapDB) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "SmartZap", "ZapDBOnly", 1)
Else
	IniWrite($g_sProfileConfigPath, "SmartZap", "ZapDBOnly", 0)
EndIf

If GUICtrlRead($chkSmartZapSaveHeroes) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "SmartZap", "THSnipeSaveHeroes", 1)
Else
	IniWrite($g_sProfileConfigPath, "SmartZap", "THSnipeSaveHeroes", 0)
EndIf

IniWrite($g_sProfileConfigPath, "SmartZap", "MinDE", GUICtrlRead($txtMinDark))

; samm0d zap
If GUICtrlRead($chkSmartZapRnd) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "SamM0dZap", "UseSmartZapRnd", 1)
Else
	IniWrite($g_sProfileConfigPath, "SamM0dZap", "UseSmartZapRnd", 0)
EndIf
If GUICtrlRead($chkDrillExistBeforeZap) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "SamM0dZap", "CheckDrillBeforeZap", 1)
Else
	IniWrite($g_sProfileConfigPath, "SamM0dZap", "CheckDrillBeforeZap", 0)
EndIf

If GUICtrlRead($chkPreventTripleZap) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "SamM0dZap", "PreventTripleZap", 1)
Else
	IniWrite($g_sProfileConfigPath, "SamM0dZap", "PreventTripleZap", 0)
EndIf

IniWrite($g_sProfileConfigPath, "SamM0dZap", "MinDEGetFromDrill", GUICtrlRead($txtMinDEGetFromDrill))


; Check Collectors Outside
If GUICtrlRead($chkDBMeetCollOutside) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "search", "DBMeetCollOutside", 1)
Else
	IniWriteS($g_sProfileConfigPath, "search", "DBMeetCollOutside", 0)
EndIf

If GUICtrlRead($chkDBCollectorsNearRedline) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "search", "DBCollectorsNearRedline", 1)
Else
	IniWriteS($g_sProfileConfigPath, "search", "DBCollectorsNearRedline", 0)
EndIf

IniWriteS($g_sProfileConfigPath, "search", "RedlineTiles", _GUICtrlComboBox_GetCurSel($cmbRedlineTiles))

If GUICtrlRead($chkSkipCollectorCheckIF) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "search", "SkipCollectorCheckIF", 1)
Else
	IniWriteS($g_sProfileConfigPath, "search", "SkipCollectorCheckIF", 0)
EndIf
IniWriteS($g_sProfileConfigPath, "search", "DBMinCollOutsidePercent", GUICtrlRead($txtDBMinCollOutsidePercent))
IniWriteS($g_sProfileConfigPath, "search", "SkipCollectorGold", GUICtrlRead($txtSkipCollectorGold))
IniWriteS($g_sProfileConfigPath, "search", "SkipCollectorElixir", GUICtrlRead($txtSkipCollectorElixir))
IniWriteS($g_sProfileConfigPath, "search", "SkipCollectorDark", GUICtrlRead($txtSkipCollectorDark))

If GUICtrlRead($chkSkipCollectorCheckIFTHLevel) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "search", "SkipCollectorCheckIFTHLevel", 1)
Else
	IniWriteS($g_sProfileConfigPath, "search", "SkipCollectorCheckIFTHLevel", 0)
EndIf
IniWriteS($g_sProfileConfigPath, "search", "IFTHLevel", GUICtrlRead($txtIFTHLevel))

; dropp cc first
If GUICtrlRead($chkDropCCFirst) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "CCFirst", "Enable", 1)
Else
	IniWrite($g_sProfileConfigPath, "CCFirst", "Enable", 0)
EndIf

; Check League For DeadBase
If GUICtrlRead($chkDBNoLeague) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "search", "DBNoLeague", 1)
Else
	IniWrite($g_sProfileConfigPath, "search", "DBNoLeague", 0)
EndIf

If GUICtrlRead($chkABNoLeague) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "search", "ABNoLeague", 1)
Else
	IniWrite($g_sProfileConfigPath, "search", "ABNoLeague", 0)
EndIf

; HLFClick By Samkie
If GUICtrlRead($chkEnableHLFClick) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "HLFClick", "EnableHLFClick", 1)
Else
	IniWrite($g_sProfileConfigPath, "HLFClick", "EnableHLFClick", 0)
EndIf
IniWrite($g_sProfileConfigPath, "HLFClick", "HLFClickDelayTime", GUICtrlRead($sldHLFClickDelayTime))

If GUICtrlRead($chkEnableHLFClickSetlog) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "HLFClick", "EnableHLFClickSetlog", 1)
Else
	IniWrite($g_sProfileConfigPath, "HLFClick", "EnableHLFClickSetlog", 0)
EndIf

; advanced update for wall by Samkie
If GUICtrlRead($chkSmartUpdateWall) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "AU4Wall", "EnableSmartUpdateWall", 1)
Else
	IniWrite($g_sProfileConfigPath, "AU4Wall", "EnableSmartUpdateWall", 0)
EndIf

; samm0d ocr
If GUICtrlRead($chkEnableCustomOCR4CCRequest) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "GetMyOcr", "EnableCustomOCR4CCRequest", 1)
Else
	IniWrite($g_sProfileConfigPath, "GetMyOcr", "EnableCustomOCR4CCRequest", 0)
EndIf

; auto dock
If GUICtrlRead($chkAutoDock) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "AutoDock", "Enable", 1)
Else
	IniWrite($g_sProfileConfigPath, "AutoDock", "Enable", 0)
EndIf


IniWriteS($g_sProfileConfigPath, "AU4Wall", "ClickWallDelay", GUICtrlRead($txtClickWallDelay))
IniWriteS($g_sProfileConfigPath, "AU4Wall", "BaseNodeX", $aBaseNode[0])
IniWriteS($g_sProfileConfigPath, "AU4Wall", "BaseNodeY", $aBaseNode[1])
IniWriteS($g_sProfileConfigPath, "AU4Wall", "LastWallX", $aLastWall[0])
IniWriteS($g_sProfileConfigPath, "AU4Wall", "LastWallY", $aLastWall[1])
IniWriteS($g_sProfileConfigPath, "AU4Wall", "FaceDirection", $iFaceDirection)

; CSV Deployment Speed Mod
IniWriteS($g_sProfileConfigPath, "attack", "CSVSpeedDB", $isldSelectedCSVSpeed[$DB])
IniWriteS($g_sProfileConfigPath, "attack", "CSVSpeedAB", $isldSelectedCSVSpeed[$LB])


; My Switch
;~ $ichkEnableMySwitch = IniRead($g_sProfileConfigPath, "MySwitch", "Enable", "0")
;~ If GUICtrlRead($chkEnableMySwitch) = $GUI_CHECKED Then
;~ 	IniWrite($g_sProfileConfigPath, "MySwitch", "Enable", 1)
;~ Else
;~ 	IniWrite($g_sProfileConfigPath, "MySwitch", "Enable", 0)
;~ EndIf

; Wait 4 CC
If GUICtrlRead($chkWait4CC) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "Wait4CC", "Enable", 1)
Else
	IniWriteS($g_sProfileConfigPath, "Wait4CC", "Enable", 0)
EndIf
IniWriteS($g_sProfileConfigPath, "Wait4CC", "CCStrength", GUICtrlRead($txtCCStrength))

; check 4 cc
If GUICtrlRead($chkCheck4CC) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "Check4CC", "Enable", 1)
Else
	IniWrite($g_sProfileConfigPath, "Check4CC", "Enable", 0)
EndIf
IniWrite($g_sProfileConfigPath, "Check4CC", "WaitTime", GUICtrlRead($txtCheck4CCWaitTime))

; global delay increse
If GUICtrlRead($chkIncreaseGlobalDelay) = $GUI_CHECKED Then
	IniWrite($g_sProfileConfigPath, "GlobalDelay", "Enable", 1)
Else
	IniWrite($g_sProfileConfigPath, "GlobalDelay", "Enable", 0)
EndIf
IniWrite($g_sProfileConfigPath, "GlobalDelay", "DelayPercentage", GUICtrlRead($txtIncreaseGlobalDelay))

; stick to train page
IniWrite($g_sProfileConfigPath, "StickToTrainPage", "Minutes", GUICtrlRead($txtStickToTrainWindow))

; My Troops
If GUICtrlRead($chkDisablePretrainTroops) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "MyTroops", "PreTrain", 1)
Else
	IniWriteS($g_sProfileConfigPath, "MyTroops", "PreTrain", 0)
EndIf

If GUICtrlRead($chkEnableDeleteExcessTroops) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "MyTroops", "DeleteExcess", 1)
Else
	IniWriteS($g_sProfileConfigPath, "MyTroops", "DeleteExcess", 0)
EndIf

If GUICtrlRead($chkCustomTrain) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "MyTroops", "EnableCustomTrain", 1)
Else
	IniWriteS($g_sProfileConfigPath, "MyTroops", "EnableCustomTrain", 0)
EndIf

;SetLog("$ichkMyTroopsOrder: " & $ichkMyTroopsOrder)

If GUICtrlRead($chkMyTroopsOrder) = $GUI_CHECKED Then
	IniWriteS($g_sProfileConfigPath, "MyTroops", "Order", 1)
	;SetLog("$chkMyTroopsOrder: " & 1)
Else
	IniWriteS($g_sProfileConfigPath, "MyTroops", "Order", 0)
	;SetLog("$chkMyTroopsOrder: " & 0)
EndIf

;IniWrite($g_sProfileConfigPath, "COCVer", "CoCVersion", _GUICtrlComboBox_GetCurSel($cmbCoCVersion))

IniWriteS($g_sProfileConfigPath, "MyTroops", "TrainCombo", _GUICtrlComboBox_GetCurSel($cmbMyQuickTrain))

Local $itempcmbTroopSetting = _GUICtrlComboBox_GetCurSel($cmbTroopSetting)

IniWriteS($g_sProfileConfigPath, "MyTroops", "Composition", $itempcmbTroopSetting)

For $i = 0 To UBound($MyTroops) - 1
	IniWriteS($g_sProfileConfigPath, "MyTroops", $MyTroops[$i][0] & $itempcmbTroopSetting, GUICtrlRead(Eval("txtMy" & $MyTroops[$i][0])))
	IniWriteS($g_sProfileConfigPath, "MyTroops", $MyTroops[$i][0] & "Order" & $itempcmbTroopSetting, GUICtrlRead(Eval("cmbMy"& $MyTroops[$i][0] & "Order")))
Next

	For $i = 0 To UBound($MySpells) - 1
		If GUICtrlRead(Eval("chkPre" & $MySpells[$i][0])) = $GUI_CHECKED Then
			IniWriteS($g_sProfileConfigPath, "MySpells", $MySpells[$i][0] & $itempcmbTroopSetting, 1)
		Else
			IniWriteS($g_sProfileConfigPath, "MySpells", $MySpells[$i][0] & $itempcmbTroopSetting, 0)
		EndIf
	Next
	IniWriteS($g_sProfileConfigPath, "Spells", "LightningSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumLightningSpell))
	IniWriteS($g_sProfileConfigPath, "Spells", "RageSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumRageSpell))
	IniWriteS($g_sProfileConfigPath, "Spells", "HealSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumHealSpell))
	IniWriteS($g_sProfileConfigPath, "Spells", "JumpSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumJumpSpell))
	IniWriteS($g_sProfileConfigPath, "Spells", "FreezeSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumFreezeSpell))
	IniWriteS($g_sProfileConfigPath, "Spells", "CloneSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumCloneSpell))
	IniWriteS($g_sProfileConfigPath, "Spells", "PoisonSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumPoisonSpell))
	IniWriteS($g_sProfileConfigPath, "Spells", "EarthSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumEarthSpell))
	IniWriteS($g_sProfileConfigPath, "Spells", "HasteSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumHasteSpell))
	IniWriteS($g_sProfileConfigPath, "Spells", "SkeletonSpell" & $itempcmbTroopSetting, GUICtrlRead($txtNumSkeletonSpell))


;~ For $i = 0 To UBound($MySpells) - 1
;~ 	If GUICtrlRead(Eval("chkPre" & $MySpells[$i][0])) = $GUI_CHECKED Then
;~ 		IniWriteS($g_sProfileConfigPath, "MySpells", $MySpells[$i][0], 1)
;~ 	Else
;~ 		IniWriteS($g_sProfileConfigPath, "MySpells", $MySpells[$i][0], 0)
;~ 	EndIf
;~ Next

;~ IniWriteS($g_sProfileConfigPath, "Spells", "LightningSpell", GUICtrlRead($txtNumLightningSpell))
;~ IniWriteS($g_sProfileConfigPath, "Spells", "RageSpell", GUICtrlRead($txtNumRageSpell))
;~ IniWriteS($g_sProfileConfigPath, "Spells", "HealSpell", GUICtrlRead($txtNumHealSpell))
;~ IniWriteS($g_sProfileConfigPath, "Spells", "JumpSpell", GUICtrlRead($txtNumJumpSpell))
;~ IniWriteS($g_sProfileConfigPath, "Spells", "FreezeSpell", GUICtrlRead($txtNumFreezeSpell))
;~ IniWriteS($g_sProfileConfigPath, "Spells", "CloneSpell", GUICtrlRead($txtNumCloneSpell))
;~ IniWriteS($g_sProfileConfigPath, "Spells", "PoisonSpell", GUICtrlRead($txtNumPoisonSpell))
;~ IniWriteS($g_sProfileConfigPath, "Spells", "EarthSpell", GUICtrlRead($txtNumEarthSpell))
;~ IniWriteS($g_sProfileConfigPath, "Spells", "HasteSpell", GUICtrlRead($txtNumHasteSpell))
;~ IniWriteS($g_sProfileConfigPath, "Spells", "SkeletonSpell", GUICtrlRead($txtNumSkeletonSpell))
