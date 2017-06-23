; #FUNCTION# ====================================================================================================================
; Name ..........: readConfig.au3
; Description ...: Reads config file and sets variables
; Syntax ........: readConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $iMultiFingerStyle = 0

; Multi Finger (LunaEclipse)
IniReadS($iMultiFingerStyle, $g_sProfileConfigPath, "MultiFinger", "Select", "1")

; prevent over donate
IniReadS($ichkEnableLimitDonateUnit, $g_sProfileConfigPath, "PreventOverDonate", "Enable", "0", "Int")
IniReadS($itxtLimitDonateUnit, $g_sProfileConfigPath, "PreventOverDonate", "LimitValue", "8","Int")

; Unit Wave Factor

IniReadS($ichkUnitFactor, $g_sProfileConfigPath, "SetSleep", "EnableUnitFactor", "1", "Int")
IniReadS($itxtUnitFactor, $g_sProfileConfigPath, "SetSleep", "UnitFactor", "10","Int")

IniReadS($ichkWaveFactor, $g_sProfileConfigPath, "SetSleep", "EnableWaveFactor", "1", "Int")
IniReadS($itxtWaveFactor, $g_sProfileConfigPath, "SetSleep", "WaveFactor", "100","Int")


; SmartZap from ChaCalGyn (LunaEclipse) - DEMEN

$ichkUseSamM0dZap = IniRead($g_sProfileConfigPath, "Zap", "SamM0dZap", "1")

$ichkSmartZapDB = IniRead($g_sProfileConfigPath, "SmartZap", "ZapDBOnly", "1")
$ichkSmartZapSaveHeroes = IniRead($g_sProfileConfigPath, "SmartZap", "THSnipeSaveHeroes", "1")
$itxtMinDE = IniRead($g_sProfileConfigPath, "SmartZap", "MinDE", "400")

; samm0d zap
$ichkSmartZapRnd = IniRead($g_sProfileConfigPath, "SamM0dZap", "UseSmartZapRnd", "1")
$ichkDrillExistBeforeZap = IniRead($g_sProfileConfigPath, "SamM0dZap", "CheckDrillBeforeZap", "1")
$itxtMinDEGetFromDrill = IniRead($g_sProfileConfigPath, "SamM0dZap", "MinDEGetFromDrill", "100")
$ichkPreventTripleZap = IniRead($g_sProfileConfigPath, "SamM0dZap", "PreventTripleZap", "1")


; Check Collectors Outside - Added by TheRevenor
$ichkDBMeetCollOutside = IniRead($g_sProfileConfigPath, "search", "DBMeetCollOutside", "0")
$ichkDBCollectorsNearRedline = IniRead($g_sProfileConfigPath, "search", "DBCollectorsNearRedline", "0")

IniReadS($icmbRedlineTiles, $g_sProfileConfigPath, "search", "RedlineTiles", "1", "Int")

$iDBMinCollOutsidePercent = IniRead($g_sProfileConfigPath, "search", "DBMinCollOutsidePercent", "50")

$ichkSkipCollectorCheckIF = IniRead($g_sProfileConfigPath, "search", "SkipCollectorCheckIF", "0")
$itxtSkipCollectorGold = IniRead($g_sProfileConfigPath, "search", "SkipCollectorGold", "500000")
$itxtSkipCollectorElixir = IniRead($g_sProfileConfigPath, "search", "SkipCollectorElixir", "500000")
$itxtSkipCollectorDark = IniRead($g_sProfileConfigPath, "search", "SkipCollectorDark", "3000")
$ichkSkipCollectorCheckIFTHLevel = IniRead($g_sProfileConfigPath, "search", "SkipCollectorCheckIFTHLevel", "0")
$itxtIFTHLevel = IniRead($g_sProfileConfigPath, "search", "IFTHLevel", "7")

; drop cc first
$ichkDropCCFirst = IniRead($g_sProfileConfigPath, "CCFirst", "Enable", "0")

; Check League For DeadBase
$iChkNoLeague[$DB] = IniRead($g_sProfileConfigPath, "search", "DBNoLeague", "0")
$iChkNoLeague[$LB] = IniRead($g_sProfileConfigPath, "search", "ABNoLeague", "0")

; HLFClick By Samkie
$ichkEnableHLFClick = IniRead($g_sProfileConfigPath, "HLFClick", "EnableHLFClick", "0")
$isldHLFClickDelayTime = IniRead($g_sProfileConfigPath, "HLFClick", "HLFClickDelayTime", "500")
$EnableHMLSetLog = IniRead($g_sProfileConfigPath, "HLFClick", "EnableHLFClickSetlog", "0")


; advanced update for wall by Samkie
$ichkSmartUpdateWall  = IniRead($g_sProfileConfigPath, "AU4Wall", "EnableSmartUpdateWall", "0")
$itxtClickWallDelay  = IniRead($g_sProfileConfigPath, "AU4Wall", "ClickWallDelay", "500")
$aBaseNode[0] = IniRead($g_sProfileConfigPath, "AU4Wall", "BaseNodeX", "-1")
$aBaseNode[1] = IniRead($g_sProfileConfigPath, "AU4Wall", "BaseNodeY", "-1")
$aLastWall[0] = IniRead($g_sProfileConfigPath, "AU4Wall", "LastWallX", "-1")
$aLastWall[1] = IniRead($g_sProfileConfigPath, "AU4Wall", "LastWallY", "-1")
$iFaceDirection = IniRead($g_sProfileConfigPath, "AU4Wall", "FaceDirection", "1")

; samm0d ocr
$ichkEnableCustomOCR4CCRequest = IniRead($g_sProfileConfigPath, "GetMyOcr", "EnableCustomOCR4CCRequest", "0")

; auto dock
$ichkAutoDock = IniRead($g_sProfileConfigPath, "AutoDock", "Enable", "0")

IniReadS($g_bChkAutoHideEmulator, $g_sProfileConfigPath, "AutoHideEmulator", "Enable", False, "Bool")
IniReadS($g_bChkAutoMinimizeBot, $g_sProfileConfigPath, "AutoMinimizeBot", "Enable", False, "Bool")

; CSV Deployment Speed Mod
IniReadS($isldSelectedCSVSpeed[$DB], $g_sProfileConfigPath, "attack", "CSVSpeedDB", 3)
IniReadS($isldSelectedCSVSpeed[$LB], $g_sProfileConfigPath, "attack", "CSVSpeedAB", 3)

; Wait 4 CC
IniReadS($ichkWait4CC, $g_sProfileConfigPath, "Wait4CC", "Enable", "0")
IniReadS($CCStrength, $g_sProfileConfigPath, "Wait4CC", "CCStrength", "100")

; check 4 cc
$ichkCheck4CC = IniRead($g_sProfileConfigPath, "Check4CC", "Enable", "0")
$itxtCheck4CCWaitTime = IniRead($g_sProfileConfigPath, "Check4CC", "WaitTime", "7")


; global delay increse
$ichkIncreaseGlobalDelay = IniRead($g_sProfileConfigPath, "GlobalDelay", "Enable", "0")
$itxtIncreaseGlobalDelay = IniRead($g_sProfileConfigPath, "GlobalDelay", "DelayPercentage", "10")

;stick to train page
$itxtStickToTrainWindow = IniRead($g_sProfileConfigPath, "StickToTrainPage", "Minutes", 2)

; My Troops
IniReadS($ichkCustomTrain, $g_sProfileConfigPath, "MyTroops", "EnableCustomTrain", "0")
IniReadS($ichkMyTroopsOrder, $g_sProfileConfigPath, "MyTroops", "Order", "0")
IniReadS($ichkEnableDeleteExcessTroops, $g_sProfileConfigPath, "MyTroops", "DeleteExcess", "0")



IniReadS($icmbMyQuickTrain, $g_sProfileConfigPath, "MyTroops", "TrainCombo", "0", "Int")
IniReadS($icmbTroopSetting, $g_sProfileConfigPath, "MyTroops", "Composition", "0", "Int")
;$icmbCoCVersion = IniRead($g_sProfileConfigPath, "COCVer", "CoCVersion", "0")

IniReadS($ichkDisablePretrainTroops, $g_sProfileConfigPath, "MyTroops", "NoPreTrain", "0", "Int")

For $j = 0 To 2
	For $i = 0 To UBound($MyTroops) - 1
		IniReadS($MyTroopsSetting[$j][$i][0],$g_sProfileConfigPath, "MyTroops", $MyTroops[$i][0] & $j, "0","Int")
		IniReadS($MyTroopsSetting[$j][$i][1],$g_sProfileConfigPath, "MyTroops", $MyTroops[$i][0] & "Order" & $j, $i + 1,"Int")
	Next
Next
For $i = 0 To UBound($MyTroops) - 1
	$MyTroops[$i][3] =  $MyTroopsSetting[$icmbTroopSetting][$i][0]
	$MyTroops[$i][1] =  $MyTroopsSetting[$icmbTroopSetting][$i][1]
Next

IniReadS($ichkMySpellsOrder, $g_sProfileConfigPath, "MySpells", "Order", "0")

IniReadS($ichkEnableDeleteExcessSpells, $g_sProfileConfigPath, "MySpells", "DeleteExcess", "0")
IniReadS($ichkForcePreBrewSpell, $g_sProfileConfigPath, "MySpells", "ForcePreBrewSpell", "0")

For $j = 0 To 2
	For $i = 0 To UBound($MySpells) - 1
		IniReadS($MySpellSetting[$j][$i][0], $g_sProfileConfigPath, "MySpells", $MySpells[$i][0] & $j, "0", "Int")
		IniReadS($MySpellSetting[$j][$i][1],$g_sProfileConfigPath, "MySpells", $MySpells[$i][0] & "Order" & $j, $i + 1,"Int")
		IniReadS($MySpellSetting[$j][$i][2], $g_sProfileConfigPath, "MySpells", $MySpells[$i][0] & "Pre" & $j, "0", "Int")
	Next
Next
For $i = 0 To UBound($MySpells) - 1
	Assign("i" & $MySpells[$i][0] & "SpellComp",  $MySpellSetting[$icmbTroopSetting][$i][0])
	Assign("ichkPre" & $MySpells[$i][0],  $MySpellSetting[$icmbTroopSetting][$i][2])
	$MySpells[$i][1] =  $MySpellSetting[$icmbTroopSetting][$i][1]
Next

;$iTotalTrainSpaceSpell = 0
;For $i = 0 To 9
;	$iTotalTrainSpaceSpell += Number(Eval("i" & $MySpells[$i][0] & "SpellComp") * $MySpells[$i][2])
;	if $iSamM0dDebug = 1 Then SetLog("$iTotalTrainSpaceSpell: " & $iTotalTrainSpaceSpell)
;Next


