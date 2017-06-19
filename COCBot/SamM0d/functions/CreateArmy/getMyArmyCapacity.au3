
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCapacity
; Description ...: Obtains current and total capacity of troops from Training - Army Overview window
; Syntax ........: getArmyCapacity([$bOpenArmyWindow = False[, $bCloseArmyWindow = False]])
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......: Samkie (19 JUN 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getMyArmyCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getMyArmyCapacity:", $COLOR_DEBUG1)

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep(250) Then Return
	EndIf

	Local $aGetArmySize[3] = ["", "", ""]
	Local $sArmyInfo = ""
	Local $sInputbox, $iCount, $tmpTotalCamp

	$iCount = 0 ; reset loop safety exit counter

	While 1
		$sArmyInfo = getMyOcrArmyCap()
		If $g_iDebugSetlogTrain = 1 Then Setlog("$sArmyInfo = " & $sArmyInfo, $COLOR_DEBUG)
		$aGetArmySize = StringSplit($sArmyInfo, "#")
		If IsArray($aGetArmySize) Then
			If $aGetArmySize[0] > 1 Then
				If Number($aGetArmySize[2]) < 20 Or Mod(Number($aGetArmySize[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $g_iDebugSetlogTrain = 1 Then Setlog(" OCR value is not valid camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$tmpTotalCamp = Number($aGetArmySize[2])
				$g_CurrentCampUtilization = Number($aGetArmySize[1])
				If $g_iTotalCampSpace = 0 Then $g_iTotalCampSpace = $tmpTotalCamp
				If $g_iDebugSetlogTrain = 1 Then Setlog("$g_CurrentCampUtilization = " & $g_CurrentCampUtilization & ", $g_iTotalCampSpace = " & $g_iTotalCampSpace, $COLOR_DEBUG)
				;$g_iArmyCapacity = Int($g_CurrentCampUtilization / $tmpTotalCamp * 100)
				;SetLog("Troops: " & $g_CurrentCampUtilization & "/" & $tmpTotalCamp & " (" & $g_iArmyCapacity & "%)")
				ExitLoop
			Else
				$g_CurrentCampUtilization = 0
				$tmpTotalCamp = 0
			EndIf
		Else
			$g_CurrentCampUtilization = 0
			$tmpTotalCamp = 0
		EndIf
		$iCount += 1
		If $iCount > 100 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
		If _Sleep(250) Then Return ; Wait 250ms
	WEnd

	If $g_CurrentCampUtilization = 0 And $tmpTotalCamp = 0 Then
		Setlog("Army size read error, Troop numbers may not train correctly", $COLOR_ERROR) ; log if there is read error
		CheckOverviewFullArmy()
	EndIf

	If $g_iTotalCampSpace = 0 Or ($g_iTotalCampSpace <> $tmpTotalCamp) Then  ; if Total camp size is still not set or value not same as read use forced value
		If $g_bTotalCampForced = False Then ; check if forced camp size set in expert tab
		    Local $proposedTotalCamp = $tmpTotalCamp
			If $g_iTotalCampSpace > $tmpTotalCamp Then $proposedTotalCamp = $g_iTotalCampSpace
			$sInputbox = InputBox("Question", _
								  "Enter your total Army Camp capacity." & @CRLF & @CRLF & _
								  "Please check it matches with total Army Camp capacity" & @CRLF & _
								  "you see in Army Overview right now in Android Window:" & @CRLF & _
								  $g_sAndroidTitle & @CRLF & @CRLF & _
								  "(This window closes in 2 Minutes with value of " & $proposedTotalCamp & ")", $proposedTotalCamp, "", 330, 220, Default, Default, 120, $g_hFrmBotEx)
			Local $error = @error
			If $error = 1 Then
			   Setlog("Army Camp User input cancelled, still using " & $g_iTotalCampSpace, $COLOR_ACTION)
			Else
			   If $error = 2 Then
				  ; Cancelled, using proposed value
				  $g_iTotalCampSpace = $proposedTotalCamp
			   Else
				  $g_iTotalCampSpace = Number($sInputbox)
			   EndIf
			   If $error = 0 Then
				  $g_iTotalCampForcedValue = $g_iTotalCampSpace
				  $g_bTotalCampForced = True
				  Setlog("Army Camp User input = " & $g_iTotalCampSpace, $COLOR_INFO)
			   Else
				  ; timeout
				  Setlog("Army Camp proposed value = " & $g_iTotalCampSpace, $COLOR_ACTION)
			   EndIf
			EndIF
		Else
			$g_iTotalCampSpace = Number($g_iTotalCampForcedValue)
		EndIf
	EndIf
	;If _Sleep(500) Then Return

	If $g_iTotalCampSpace > 0 Then
		$g_iArmyCapacity = Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100)
		SetLog("Troops: " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace & " (" & $g_iArmyCapacity & "%)")
	Else
		SetLog("Troops: " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace)
		$g_iArmyCapacity = 0
	EndIf

	If $g_CurrentCampUtilization >= Int(($g_iTotalCampSpace * $g_iTrainArmyFullTroopPct) / 100) Then
		$g_bfullArmy = True
	Else
		$g_bfullArmy = False
	EndIf

;~ 	If ($g_CurrentCampUtilization + 1) = $g_iTotalCampSpace Then
;~ 		$fullArmy = True
;~ 	Else
;~ 		$fullArmy = False
;~ 	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep(500) Then Return
	EndIf

EndFunc   ;==>getMyArmyCapacity

