
; #FUNCTION# ====================================================================================================================
; Name ..........: getCCCapacity
; Description ...: Obtains current and total capacity of troops from Training - Army Overview window
; Syntax ........: getCCCapacity([$bOpenArmyWindow = False[, $bCloseArmyWindow = False]])
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getArmyCCCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False)

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

	Local $aGetArmySize[3] = ["", "", ""]
	Local $sCCInfo = ""
	Local $iTried, $iHoldCamp, $iHoldCur
	Local $tmpTotalCCCamp = 0
	Local $tmpCurCCCamp = 0

	; Verify troop current and full capacity
	$iTried = 0 ; reset loop safety exit counter
	;$sCCInfo = getArmyCampCap($aCCCampSize[0], $aCCCampSize[1]) ; OCR read army trained and total
	;If $g_iDebugSetlogTrain = 1 Then Setlog("OCR $sCCInfo = " & $sCCInfo, $COLOR_DEBUG)

	While $iTried < 100 ; 30 - 40 sec
		$iTried += 1
		If _Sleep(500) Then Return ; Wait 250ms before reading again
		$sCCInfo = getMyOcrCCCap() ; OCR read army trained and total
		If $g_iDebugSetlogTrain = 1 Then Setlog("OCR $sCCInfo = " & $sCCInfo, $COLOR_DEBUG)
		If StringInStr($sCCInfo, "#", 0, 1) < 2 Then ContinueLoop ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid

		$aGetArmySize = StringSplit($sCCInfo, "#") ; split the trained troop number from the total troop number
		If IsArray($aGetArmySize) Then
			If $aGetArmySize[0] > 1 Then ; check if the OCR was valid and returned both values
				If Number($aGetArmySize[2]) < 10 Or Mod(Number($aGetArmySize[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $g_iDebugSetlogTrain = 1 Then Setlog(" OCR value is not valid CC camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$tmpCurCCCamp = Number($aGetArmySize[1])
				If $g_iDebugSetlogTrain = 1 Then Setlog("$tmpCurCCCamp = " & $tmpCurCCCamp, $COLOR_DEBUG)
				$tmpTotalCCCamp = Number($aGetArmySize[2])
				If $iHoldCamp = $tmpTotalCCCamp And $iHoldCur = $tmpCurCCCamp Then ExitLoop ; check to make sure the OCR read value is same in 2 reads before exit
				$iHoldCur = $tmpCurCCCamp
				$iHoldCamp = $tmpTotalCCCamp ; Store last OCR read value
			EndIf
		EndIf
	WEnd

	If $iTried <= 99 Then
		$CurCCCamp = $tmpCurCCCamp
		$CurTotalCCCamp = $tmpTotalCCCamp
		If $g_iDebugSetlogTrain = 1 Then Setlog("$CurCCCamp = " & $CurCCCamp & ", $CurTotalCCCamp = " & $CurTotalCCCamp, $COLOR_DEBUG)
	Else
		Setlog("CC size read error...", $COLOR_ERROR) ; log if there is read error
		$CurCCCamp = 0
		$CurTotalCCCamp = 0
		Return
	EndIf

	If _Sleep(500) Then Return


	$CCCapacity = Int($CurCCCamp / $CurTotalCCCamp * 100)
	SetLog("Clan Castle troops: " & $CurCCCamp & "/" & $CurTotalCCCamp & " (" & $CCCapacity & "%)")


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

EndFunc   ;==>getArmyCCCapacity

