
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroopCount
; Description ...: Reads current quanitites/type of troops from Training - Army Overview window, updates $CurXXXX and $g_avDTtroopsToBeUsed values
; Syntax ........: getArmyTroopCount()
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: Samkie (27 Nov 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getMyArmyTroopCount($bOpenArmyWindow = False, $bCloseArmyWindow = False, $test = false)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getArmyTroopCount:", $COLOR_DEBUG1)

	If $test = false  Then
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
	Else
		Setlog("test")
	EndIf

	;====Reset the variable======
	For $i = 0 To UBound($g_avDTtroopsToBeUsed, 1) - 1
		$g_avDTtroopsToBeUsed[$i][1] = 0
	Next
	For $i = 0 To UBound($MyTroops) - 1
		Assign("cur" & $MyTroops[$i][0], 0)
	Next
	For $i = 0 To 10
		Assign("RemSlot" & $i + 1, 0)
	Next
	;============================

	Local $aFindResult
	Local $AvailableCamp = 0
	Local $iCount = 0
	Local $bDeletedExcess = False
	While $AvailableCamp = 0 And $g_CurrentCampUtilization > 0
		Local $iCount2 = 0
		While IsQueueBlockByMsg()
			If _Sleep(1000) Then Return
			$iCount2 += 1
			If $iCount2 >= 30 Then
				ExitLoop
			EndIf
		WEnd
		$aFindResult = getArmyTypeAndSlot()
		If $g_iDebugSetlogTrain = 1 Then SetLog("============End getArmyTypeAndSlot ============")
		If $aFindResult <> "" Then
			$AvailableCamp = 0
			For $i = 0 To UBound($aFindResult,$UBOUND_ROWS) - 1
				If $g_iDebugSetlogTrain = 1 Then Setlog(" Slot : " & $i + 1, $COLOR_DEBUG)
				If $aFindResult[$i][1] <> $i + 1 Then
					If $g_iDebugSetlogTrain = 1 Then Setlog(" Slot : " & $i + 1 & " - Troops detection error.", $COLOR_DEBUG)
				EndIf
				If $aFindResult[$i][2] <> 0 Then
					Assign("cur" & $aFindResult[$i][0], $aFindResult[$i][2])
					$AvailableCamp += ($aFindResult[$i][2] * $TroopsUnitSize[Eval("e" & $aFindResult[$i][0])])
					; assign variable for drop trophy troops type
					For $j = 0 To UBound($g_avDTtroopsToBeUsed) - 1
						If $g_avDTtroopsToBeUsed[$j][0] = $aFindResult[$i][0] Then
							$g_avDTtroopsToBeUsed[$j][1] = $aFindResult[$i][2]
							ExitLoop
						EndIf
					Next
				Else
					SetLog("Error detect quantity no. On Troop: " & MyNameOfTroop(Eval("e" & $aFindResult[$i][0]), $aFindResult[$i][2]),$COLOR_RED)
				EndIf
			Next
			If $AvailableCamp <> $g_CurrentCampUtilization Then
				If $g_iDebugSetlogTrain = 1 Then SetLog("Error: Troops size for all available Unit: " & $AvailableCamp & "  -  Camp: " & $g_CurrentCampUtilization, $COLOR_RED)
				If $g_iDebugSetlogTrain = 1 Then SetLog("Retry: " & $iCount + 1 , $COLOR_RED)
				$AvailableCamp = 0 ;reset
				If _Sleep(500) Then Return
			Else
				For $i = 0 To UBound($aFindResult,$UBOUND_ROWS) - 1
					;If Eval("cur" & $aFindResult[$i][0]) > 0 Then
					SetLog(" - Available no. of " & MyNameOfTroop(Eval("e" & $aFindResult[$i][0]), $aFindResult[$i][2]) & ": " & $aFindResult[$i][2], (Eval("e" & $aFindResult[$i][0]) > 11 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
					If $ichkEnableDeleteExcessTroops = 1 Then
						If $aFindResult[$i][2] > $MyTroops[Eval("e" & $aFindResult[$i][0])][3] Then
							$bRestartCustomTrain = True
							$bDeletedExcess = True
							SetLog(" >>> excess: " & $aFindResult[$i][2] - $MyTroops[Eval("e" & $aFindResult[$i][0])][3],$COLOR_RED)
							Assign("RemSlot" & $aFindResult[$i][1],$aFindResult[$i][2] - $MyTroops[Eval("e" & $aFindResult[$i][0])][3])
							If $g_iDebugSetlogTrain = 1 Then SetLog("Slot: " & $aFindResult[$i][1])
						EndIf
					EndIf
					;EndIf
				Next
				;SetLog("Troops size for all available Unit: " & $AvailableCamp,$COLOR_GREEN)

				If $bDeletedExcess Then
					$bDeletedExcess = False
					;If _ColorCheck(_GetPixelColor(389, 99 + $g_iMidOffsetY, True), Hex(0X6AB31F, 6), 10) Then ; check color if got train arrow
					If _ColorCheck(_GetPixelColor(389, 100 + $g_iMidOffsetY, True), Hex(0X5E5748, 6), 20) = False Then
						SetLog(" >>> stop train troops.", $COLOR_RED)
						If gotoTrainTroops() Then
							If _Sleep(1000) Then Return
							RemoveAllTroopAlreadyTrain()
							If _Sleep(1000) Then Return
							If gotoArmy() = False Then Return
							$iCount = 0
							$AvailableCamp = 0
							getMyArmyCapacity()
							ContinueLoop
						Else
							Return
						EndIf
					EndIf

					SetLog(" >>> remove excess troops.", $COLOR_RED)
					If WaitforPixel($aButtonEditArmy[4],$aButtonEditArmy[5],$aButtonEditArmy[4]+1,$aButtonEditArmy[5]+1,Hex($aButtonEditArmy[6], 6), $aButtonEditArmy[7],20) Then
						Click($aButtonEditArmy[0],$aButtonEditArmy[1],1,0,"#EditArmy")
					Else
						Return
					EndIf

					If WaitforPixel($aButtonEditCancel[4],$aButtonEditCancel[5],$aButtonEditCancel[4]+1,$aButtonEditCancel[5]+1,Hex($aButtonEditCancel[6], 6), $aButtonEditCancel[7],20) Then
						For $i = 10 To 0 Step -1
							Local $RemoveSlotQty = Eval("RemSlot" & $i + 1)
							If $g_iDebugSetlogTrain = 1 Then SetLog($i & " $RemoveSlotQty: " & $RemoveSlotQty)
							If $RemoveSlotQty > 0 Then
								Local $iRx = (80 + (73 * $i))
								Local $iRy = 240 + $g_iMidOffsetY
								For $j = 1 To $RemoveSlotQty
									Click(Random($iRx-2,$iRx+2,1),Random($iRy-2,$iRy+2,1))
									If _Sleep($g_iTrainClickDelay) Then Return
								Next
								Assign("RemSlot" & $i + 1, 0)
							EndIf
						Next
					Else
						Return
					EndIf

					If WaitforPixel($aButtonEditOkay[4],$aButtonEditOkay[5],$aButtonEditOkay[4]+1,$aButtonEditOkay[5]+1,Hex($aButtonEditOkay[6], 6), $aButtonEditOkay[7],20) Then
						Click($aButtonEditOkay[0],$aButtonEditOkay[1],1,0,"#EditArmyOkay")
					Else
						Return
					EndIf

					ClickOkay()

					If _Sleep(300) Then Return

					$iCount = 0
					$AvailableCamp = 0
					getMyArmyCapacity()
					ContinueLoop

				EndIf
				ExitLoop
			EndIf
		EndIf
		$iCount += 1
		If $iCount > 3 Then
			If $aFindResult <> "" Then
				If $AvailableCamp <> $g_CurrentCampUtilization Then
					SetLog("Error: Troops size for all available Unit: " & $AvailableCamp & "  -  Camp: " & $g_CurrentCampUtilization, $COLOR_RED)
				EndIf
			EndIf
			ExitLoop
		EndIf
		; reduce some speed
		If _Sleep(500) Then Return
		getMyArmyCapacity()
	WEnd

	If $bRestartCustomTrain Then
		;If _Sleep(50) Then Return
		;getMyArmyCapacity()
		If _Sleep(50) Then Return
		getArmyTroopTime()
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep(500) Then Return
	EndIf
EndFunc   ;==>getArmyTroopCount

Func getArmyTypeAndSlot()

	If $g_iDebugSetlogTrain = 1 Then SetLog("============Start getArmyTypeAndSlot ============")
	Local $aLastResult[1][3]
	Local $sDirectory = @ScriptDir & "\COCBot\SamM0d\images\Army\"
	Local $returnProps="objectname,objectpoints"
	Local $aCoor, $aPropsValues

	_CaptureRegion2(18, 184 + $g_iMidOffsetY, 840, 230 + $g_iMidOffsetY)

	Local $result = findMultiple($sDirectory ,"FV" ,"FV", 0, 1000, 1 , $returnProps, False )
	If IsArray($result) then
		ReDim $aLastResult[UBound($result)][3]
		For $i = 0 To UBound($result) -1
			If $g_iDebugSetlogTrain = 1 Then SetLog("--------------------------------------------------")
			$aPropsValues = $result[$i] ; should be return objectname,objectpoints
			If UBound($aPropsValues) = 2 then
				$aLastResult[$i][0] = $aPropsValues[0] ; objectname
				If $g_iDebugSetlogTrain = 1 Then SetLog("objectname: " & $aLastResult[$i][0], $COLOR_DEBUG)

				$aCoor = StringSplit($aPropsValues[1],",",$STR_NOCOUNT) ; objectpoints, split by "," tp get coor x
				$aLastResult[$i][1] = GetArmySlotPosition($aCoor[0]) ; get the army slot base on coor X
				If $g_iDebugSetlogTrain = 1 Then SetLog("objectpoints: " & $aPropsValues[1], $COLOR_DEBUG)
				If $g_iDebugSetlogTrain = 1 Then SetLog("slot: " & $aLastResult[$i][1], $COLOR_DEBUG)
				$aLastResult[$i][2] = getArmyQtyFromSlot($aLastResult[$i][1])
				If $g_iDebugSetlogTrain = 1 Then SetLog("Qty: " & $aLastResult[$i][2], $COLOR_DEBUG)
			EndIf
		Next
		_ArraySort($aLastResult, 0, 0, 0, 1) ; rearrange order, sort by spell slot col.
		Return $aLastResult
	EndIf
	Return ""
EndFunc	;==>getArmyTypeAndSlot

Func getQueueArmyTypeAndSlot()

	If $g_iDebugSetlogTrain = 1 Then SetLog("============Start getQueueArmyTypeAndSlot ============")
	Local $aLastResult[1][3]
	Local $sDirectory = @ScriptDir & "\COCBot\SamM0d\images\Army\Queue\"
	Local $returnProps="objectname,objectpoints"
	Local $aCoor, $aPropsValues
	Local $iMax, $jMax
	Local $iCount = 0
	Local $aCoorXY

	_CaptureRegion2(0, 175 + $g_iMidOffsetY, 836, 206 + $g_iMidOffsetY)

	Local $result = findMultiple($sDirectory ,"FV" ,"FV", 0, 1000, 0 , $returnProps, False )
	If IsArray($result) then
		$iMax = UBound($result) -1
		For $i = 0 To $iMax
			$aPropsValues = $result[$i]
			If UBound($aPropsValues) = 2 then
				$aCoor = StringSplit($aPropsValues[1],"|",$STR_NOCOUNT)
				$jMax = UBound($aCoor) - 1
				For $j = 0 To $jMax
					ReDim $aLastResult[$iCount + 1][3]
					$aLastResult[$iCount][0] = $aPropsValues[0]
					$aCoorXY = StringSplit($aCoor[$j],",",$STR_NOCOUNT)
					If IsArray($aCoorXY) Then
						$aLastResult[$iCount][1] = GetQueueArmySlotPosition(Number($aCoorXY[0]))
						$aLastResult[$iCount][2] = getMyOcr(67 + Number(70.5 * ($aLastResult[$iCount][1]-1)), 160 + $g_iMidOffsetY, 58 , 18,"spellqtypre",True)
					EndIf
					Assign("OnQCur" & $aLastResult[$iCount][0], Eval("OnQCur" & $aLastResult[$iCount][0]) + $aLastResult[$iCount][2])
					$iCount += 1
				Next
			EndIf
		Next
		_ArraySort($aLastResult, 1, 0, 0, 1)
		If $g_iDebugSetlogTrain = 1 Then
			For $i = 0 To UBound($aLastResult) - 1
				SetLog("Afrer _ArraySort - Obj:" & $aLastResult[$i][0] & " Slot:" & $aLastResult[$i][1] & " Qty: " & $aLastResult[$i][2], $COLOR_DEBUG)
				If Eval("OnQCur" & $aLastResult[$i][0]) > 0 Then
					Setlog(" Total On Queue Army " & $aLastResult[$i][0] & ": " & Eval("OnQCur" & $aLastResult[$i][0]))
				EndIf
			Next
		EndIf
		Return $aLastResult
	EndIf
	Return ""
EndFunc	;==>getQueueArmyTypeAndSlot

Func getArmyQtyFromSlot($iSlot)
	If $iSlot = 99 Then Return 0
	Local $result
	$result = getMyOcr(30 + (73 * ($iSlot-1)), 166 + $g_iMidOffsetY, 58 , 18,"ArmyQTY",True)
	Return $result
EndFunc

Func GetQueueArmySlotPosition($InputX)
	Switch $InputX
		Case $InputX >= 66 And $InputX <= 131
			Return 1
		Case $InputX >= 137 And $InputX <= 201
			Return 2
		Case $InputX >= 207 And $InputX <= 272
			Return 3
		Case $InputX >= 278 And $InputX <= 342
			Return 4
		Case $InputX >= 348 And $InputX <= 413
			Return 5
		Case $InputX >= 419 And $InputX <= 483
			Return 6
		Case $InputX >= 489 And $InputX <= 554
			Return 7
		Case $InputX >= 560 And $InputX <= 624
			Return 8
		Case $InputX >= 630 And $InputX <= 695
			Return 9
		Case $InputX >= 701 And $InputX <= 765
			Return 10
		Case $InputX >= 771 And $InputX <= 836
			Return 11
		Case Else
			Return 99
	EndSwitch
EndFunc

Func getArmySlotPosition($InputX)
	Switch $InputX
		Case $InputX >= 23 And $InputX <= 93
			Return 1
		Case $InputX >= 97 And $InputX <= 167
			Return 2
		Case $InputX >= 171 And $InputX <= 241
			Return 3
		Case $InputX >= 245 And $InputX <= 315
			Return 4
		Case $InputX >= 319 And $InputX <= 389
			Return 5
		Case $InputX >= 393 And $InputX <= 463
			Return 6
		Case $InputX >= 467 And $InputX <= 537
			Return 7
		Case $InputX >= 541 And $InputX <= 611
			Return 8
		Case $InputX >= 615 And $InputX <= 685
			Return 9
		Case $InputX >= 689 And $InputX <= 759
			Return 10
		Case $InputX >= 763 And $InputX <= 833
			Return 11
		Case Else
			Return 99
	EndSwitch
EndFunc