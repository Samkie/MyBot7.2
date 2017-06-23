
; #FUNCTION# ====================================================================================================================
; Name ..........: getCCCapacity
; Description ...: Obtains current and total capacity of troops from Training - Army Overview window
; Syntax ........: getCCCapacity([$bOpenArmyWindow = False[, $bCloseArmyWindow = False]])
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........:
; Modified ......: Samkie (19 JUN 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getMyArmyCCCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getCCCapacity:", $COLOR_DEBUG1)

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep(500) Then Return
	EndIf

	Local $aGetCCSize[3] = ["", "", ""]
	Local $sCCInfo = ""
	Local $iCount

	$iCount = 0 ; reset loop safety exit counter

	While 1
		$sCCInfo = getMyOcrCCCap()
		If $g_iDebugSetlogTrain = 1 Then Setlog("$sCCInfo = " & $sCCInfo, $COLOR_DEBUG)
		$aGetCCSize = StringSplit($sCCInfo, "#")
		If IsArray($aGetCCSize) Then
			If $aGetCCSize[0] > 1 Then
				If Number($aGetCCSize[2]) < 10 Or Mod(Number($aGetCCSize[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $g_iDebugSetlogTrain = 1 Then Setlog(" OCR value is not valid cc camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$CurTotalCCCamp = Number($aGetCCSize[2])
				$CurCCCamp = Number($aGetCCSize[1])
				$CCCapacity = Int($CurCCCamp / $CurTotalCCCamp * 100)
				SetLog("Clan Castle troops: " & $CurCCCamp & "/" & $CurTotalCCCamp & " (" & $CCCapacity & "%)")
				ExitLoop
			Else
				$CurCCCamp = 0
				$CurTotalCCCamp = 0
			EndIf
		Else
			$CurCCCamp = 0
			$CurTotalCCCamp = 0
		EndIf
		$iCount += 1
		If $iCount > 100 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
		If _Sleep(250) Then Return ; Wait 250ms
	WEnd

	If $CurCCCamp = 0 And $CurTotalCCCamp = 0 Then
		Setlog("CC size read error...", $COLOR_ERROR) ; log if there is read error
		$FullCCTroops = True
		If $ichkWait4CC = 1 Then $FullCCTroops = False
		If ($g_abAttackTypeEnable[$DB] And $g_abSearchCastleTroopsWaitEnable[$DB]) Or ($g_abAttackTypeEnable[$LB] And $g_abSearchCastleTroopsWaitEnable[$LB]) Then
			$FullCCTroops = False
		EndIf
		Return
	EndIf
	;If _Sleep(500) Then Return

	If $ichkWait4CC = 1 Then
		If ($CurCCCamp >= ($CurTotalCCCamp * $CCStrength / 100)) Then
			$FullCCTroops = True
		Else
			$FullCCTroops = False
		EndIf
		If $FullCCTroops = False Then
			SETLOG(" All mode - Waiting clan castle troops before start attack.", $COLOR_ACTION)
		EndIf
	Else
		$FullCCTroops = IsFullClanCastleTroops()
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep(500) Then Return
	EndIf

EndFunc   ;==>getMyArmyCCCapacity

