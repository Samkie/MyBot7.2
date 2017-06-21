; #FUNCTION# ====================================================================================================================
; Name ..........: getMyArmySpellCount
; Description ...: Obtains count of spells available from Training - Army Overview window
; Syntax ........: getMyArmySpellCount()
; Parameters ....:
; Return values .: None
; Author ........: Samkie (22 JUN 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getMyArmySpellCount($bOpenArmyWindow = False, $bCloseArmyWindow = False, $test = False)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getArmySpellCount:", $COLOR_DEBUG1)

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

	Local $iTotalSpellSpace = 0, $iCount = 0
	Local $SpellQ, $Result, $aFindResult
	Local $bDeletedExcess = False

	getMyArmySpellCapacity()
	If _Sleep(10) Then Return ; 10ms improve pause button response

	; reset Global variables
	For $i = $enumLightning To $enumSkeleton
		Assign("Cur" & $MySpells[$i][0] & "Spell", 0)
		Assign("Cur" & $g_asSpellShortNames[$i], 0)
	Next
	For $i = 0 To 6
		Assign("RemSpellSlot" & $i + 1, 0)
	Next

	If $g_iTotalSpellValue > 0 Or $test = True Then ; only use this code if the user had input spells to brew ... and assign the spells quantity
		While $iTotalSpellSpace = 0 And $g_iSpellFactorySize > 0
			Local $sRegion = 23 & "," & 354 + $g_iMidOffsetY & "," & 536 & "," & 368 + $g_iMidOffsetY ; total 7 slots for detect what spell inside the region
			$aFindResult = getSpellTypeAndSlot($sRegion)
			If $aFindResult <> "" Then
				For $i = 0 To UBound($aFindResult,$UBOUND_ROWS) - 1
					If $g_iDebugSetlogTrain = 1 Then Setlog(" Slot : " & $i + 1, $COLOR_DEBUG)
					If $aFindResult[$i][1] <> $i + 1 Then
						If $g_iDebugSetlogTrain = 1 Then Setlog(" Slot : " & $i + 1 & " - spell detection error.", $COLOR_DEBUG)
					EndIf

					$Result = getMyOcr(50 + (74 * $i), 311 + $g_iMidOffsetY, 40, 18, "SpellQTY", True)
					If $Result <> "" Then
						$SpellQ = $Result
					Else
						$SpellQ = 0
					EndIf

					If $g_iDebugSetlogTrain = 1 Then SETLOG("$aFindResult[$i][0]: " & $aFindResult[$i][0] & "     $SpellQ: " & $SpellQ)
					If _Sleep(5) Then Return

					Assign("Cur" & $aFindResult[$i][0] & "Spell", $SpellQ)
					Assign("Cur" & $g_asSpellShortNames[Eval("enum" & $aFindResult[$i][0])], Eval("Cur" & $aFindResult[$i][0] & "Spell"))

					Setlog(" - Available no. of " & MyNameOfTroop(Eval("enum" & $aFindResult[$i][0])+23, $SpellQ) & ": " & $SpellQ, (Eval("enum" & $aFindResult[$i][0]) > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))

					$iTotalSpellSpace += $MySpells[Eval("enum" & $aFindResult[$i][0])][2] * $SpellQ

					If $ichkEnableDeleteExcessSpells = 1 Then
						If $SpellQ > Eval("i" & $MySpells[Eval("enum" & $aFindResult[$i][0])][0] & "SpellComp") Then
							$bDeletedExcess = True
							SetLog(" >>> excess: " & $SpellQ - Eval("i" & $MySpells[Eval("enum" & $aFindResult[$i][0])][0] & "SpellComp"),$COLOR_RED)
							Assign("RemSpellSlot" & $aFindResult[$i][1], $SpellQ - Eval("i" & $MySpells[Eval("enum" & $aFindResult[$i][0])][0] & "SpellComp"))
							If $g_iDebugSetlogTrain = 1 Then SetLog("Slot: " & $aFindResult[$i][1])
						EndIf
					EndIf
				Next

				If $bDeletedExcess Then
					$bDeletedExcess = False
					; check any spell on brew, if yes then remove first to prevent on brew spell queue into current spell slot
					If _ColorCheck(_GetPixelColor(586, 100 + $g_iMidOffsetY, True), Hex(0X5E5748, 6), 20) = False Then
						SetLog(" >>> stop brew spell.", $COLOR_RED)
						If gotoBrewSpells() Then
							If _Sleep(1000) Then Return
							RemoveAllTroopAlreadyTrain()
							If _Sleep(1000) Then Return
							If gotoArmy() = False Then Return

							$iCount = 0
							$iTotalSpellSpace = 0
							getMyArmySpellCapacity()

							; reset Global variables
							For $i = $enumLightning To $enumSkeleton
								Assign("Cur" & $MySpells[$i][0] & "Spell", 0)
								Assign("Cur" & $g_asSpellShortNames[$i], 0)
							Next
							For $i = 0 To 6
								Assign("RemSpellSlot" & $i + 1, 0)
							Next
							ContinueLoop
						Else
							Return
						EndIf
					EndIf

					SetLog(" >>> remove excess spells.", $COLOR_RED)
					If WaitforPixel($aButtonEditArmy[4],$aButtonEditArmy[5],$aButtonEditArmy[4]+1,$aButtonEditArmy[5]+1,Hex($aButtonEditArmy[6], 6), $aButtonEditArmy[7],20) Then
						Click($aButtonEditArmy[0],$aButtonEditArmy[1],1,0,"#EditArmy")
					Else
						Return
					EndIf

					If WaitforPixel($aButtonEditCancel[4],$aButtonEditCancel[5],$aButtonEditCancel[4]+1,$aButtonEditCancel[5]+1,Hex($aButtonEditCancel[6], 6), $aButtonEditCancel[7],20) Then
						For $i = 6 To 0 Step -1
							Local $RemoveSlotQty = Eval("RemSpellSlot" & $i + 1)
							If $g_iDebugSetlogTrain = 1 Then SetLog($i & " $RemoveSlotQty: " & $RemoveSlotQty)
							If $RemoveSlotQty > 0 Then
								Local $iRx = (80 + (73 * $i))
								Local $iRy = 386 + $g_iMidOffsetY
								For $j = 1 To $RemoveSlotQty
									Click(Random($iRx-2,$iRx+2,1),Random($iRy-2,$iRy+2,1))
									If _Sleep($g_iTrainClickDelay) Then Return
								Next
								Assign("RemSpellSlot" & $i + 1, 0)
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
					$iTotalSpellSpace = 0
					getMyArmySpellCapacity()

					; reset Global variables
					; - important for if all spells remove will cause $g_iSpellFactorySize = 0 then exit loop
					; - If not reset variable CurSpell will cause custom spell cannot brew spell

					For $i = $enumLightning To $enumSkeleton
						Assign("Cur" & $MySpells[$i][0] & "Spell", 0)
						Assign("Cur" & $g_asSpellShortNames[$i], 0)
					Next
					For $i = 0 To 6
						Assign("RemSpellSlot" & $i + 1, 0)
					Next
					ContinueLoop
				EndIf

				If $iTotalSpellSpace <> $g_iSpellFactorySize Then
					SetLog("Error: Total Capacity Spell Available: " & $iTotalSpellSpace & "  -  Factory: " & $g_iSpellFactorySize, $COLOR_RED)
					SetLog("Retry: " & $iCount + 1 , $COLOR_RED)
					$iTotalSpellSpace = 0 ;reset
					If _Sleep(500) Then Return
				Else
					ExitLoop
				EndIf
			EndIf

			$iCount += 1
			If $iCount > 3 Then
				SetLog("Error: Cannot fully getting spell information.",$COLOR_ERROR)
				Return
			EndIf
			; reduce some speed
			If _Sleep(500) Then Return
			getMyArmySpellCapacity()

			; reset Global variables
			For $i = $enumLightning To $enumSkeleton
				Assign("Cur" & $MySpells[$i][0] & "Spell", 0)
				Assign("Cur" & $g_asSpellShortNames[$i], 0)
			Next
			For $i = 0 To 6
				Assign("RemSpellSlot" & $i + 1, 0)
			Next
		WEnd
	EndIf

	$g_bFullArmySpells = $iTotalSpellSpace >= $iMyTotalTrainSpaceSpell

	If $g_abAttackTypeEnable[$DB] = True And $g_abSearchSpellsWaitEnable[$DB] = True Then
		For $i = $enumLightning To $enumSkeleton
			If Eval("Cur" & $MySpells[$i][0] & "Spell") < Eval("i" & $MySpells[$i][0] & "SpellComp") Then
				SETLOG(" Dead Base - Waiting " & MyNameOfTroop($i+23,Eval("i" & $MySpells[$i][0] & "SpellComp") - Eval("Cur" & $MySpells[$i][0] & "Spell")) & _
				" to brew finish before start next attack.", $COLOR_ACTION)
			EndIf
		Next
	EndIf

	If $g_abAttackTypeEnable[$LB] = True And $g_abSearchSpellsWaitEnable[$LB] = True Then
		For $i = $enumLightning To $enumSkeleton
			If Eval("Cur" & $MySpells[$i][0] & "Spell") < Eval("i" & $MySpells[$i][0] & "SpellComp") Then
				SETLOG(" Live Base - Waiting " & MyNameOfTroop($i+23,Eval("i" & $MySpells[$i][0] & "SpellComp") - Eval("Cur" & $MySpells[$i][0] & "Spell")) & _
				" to brew finish before start next attack.", $COLOR_ACTION)
			EndIf
		Next
	EndIf

	If $g_iDebugSetlogTrain = 1 Then SETLOG("$bFullArmySpells: " & $g_bFullArmySpells & ", $iTotalSpellSpace:$iMyTotalTrainSpaceSpell " & $iTotalSpellSpace & "|" & $iMyTotalTrainSpaceSpell, $COLOR_DEBUG)

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep(500) Then Return
	EndIf

EndFunc   ;==>getArmySpellCount

Func getSpellTypeAndSlot($place)
	Local $aLastResult[1][2]
	Local $sDirectory = @ScriptDir & "\COCBot\SamM0d\images\Spell\"
	Local $returnProps="objectname,objectpoints"
	Local $aCoor, $aPropsValues

	If _Sleep(100) Then Return

	Local $aPlaces = StringSplit($place,",",$STR_NOCOUNT)
	_CaptureRegion2(Number($aPlaces[0]),Number($aPlaces[1]),Number($aPlaces[2]),Number($aPlaces[3]))

	Local $result = findMultiple($sDirectory ,"FV" ,"FV", 0, 0, 1 , $returnProps, False )
	If IsArray($result) then
		ReDim $aLastResult[UBound($result)][2]
		For $i = 0 To UBound($result) -1
			$aPropsValues = $result[$i] ; should be return objectname,objectpoints
			If UBound($aPropsValues) = 2 then
				$aLastResult[$i][0] = $aPropsValues[0] ; objectname
				$aCoor = StringSplit($aPropsValues[1],",",$STR_NOCOUNT) ; objectpoints, split by "," tp get coor x
				$aLastResult[$i][1] = getSpellSlotPosition($aCoor[0]) ; get the spell slot base on coor X
			EndIf
		Next
		_ArraySort($aLastResult, 0, 0, 0, 1) ; rearrange order, sort by spell slot col.
		Return $aLastResult
	EndIf
	Return ""
EndFunc   ;==>GetSpellTypeAndSlot

Func getSpellSlotPosition($InputX)
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
		Case Else
			Return 99
	EndSwitch
EndFunc   ;==>GetSpellSlotPosition

Func getOnBrewSpell()
	If $g_iDebugSetlogTrain = 1 Then SetLog("============Start getOnBrewSpell ============")
	Local $aLastResult[1][3]
	Local $sDirectory = @ScriptDir & "\COCBot\SamM0d\images\Spell\OnBrewSpell\"
	Local $returnProps="objectname,objectpoints"
	Local $aCoor, $aPropsValues
	Local $iMax, $jMax
	Local $iCount = 0
	Local $aCoorXY
	Local $StartAtSlot = -1

	$OnBrewLightning = 0
	$OnBrewRage = 0
	$OnBrewJump = 0
	$OnBrewHeal = 0
	$OnBrewFreeze = 0
	$OnBrewClone = 0
	$OnBrewPoison = 0
	$OnBrewHaste = 0
	$OnBrewSkeleton = 0
	$OnBrewEarth = 0

	If _ColorCheck(_GetPixelColor(818,202,True), Hex(0XCFCFC8, 6), 10) Then Return ""

	$StartAtSlot = getQueueSpellStartSlot()
	If $StartAtSlot < 0 Then Return setlog("No Spell On Brew",$COLOR_ERROR)
	If _Sleep(100) Then Return
	_CaptureRegion2((((11-$StartAtSlot)*70.5)+65), 188 + $g_iMidOffsetY, 836 , 202 + $g_iMidOffsetY)

	Local $result = findMultiple($sDirectory ,"FV" ,"FV", 0, 0, 0 , $returnProps, False )
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
						$aLastResult[$iCount][1] = getQueueSpellSlotPosition(Number($aCoorXY[0]+(((11-$StartAtSlot)*70.5)+65)))
						$aLastResult[$iCount][2] = getMyOcr(Number($aLastResult[$iCount][1]*70.5 ) , 162 + $g_iMidOffsetY, 30,12,"spellqtybrew",True)
					EndIf
					Assign("OnBrew" & $aLastResult[$iCount][0], Eval("OnBrew" & $aLastResult[$iCount][0]) + $aLastResult[$iCount][2])
					$iCount += 1
				Next
			EndIf
		Next
		_ArraySort($aLastResult, 1, 0, 0, 1)
		If $g_iDebugSetlogTrain = 1 Then
			For $i = 0 To UBound($aLastResult) - 1
				SetLog("Afrer _ArraySort - Obj:" & $aLastResult[$i][0] & " Slot:" & $aLastResult[$i][1] & " Qty: " & $aLastResult[$i][2], $COLOR_DEBUG)
				If Eval("OnBrew" & $aLastResult[$i][0]) > 0 Then
					Setlog(" Total OnBrewTrain " & $aLastResult[$i][0] & ": " & Eval("OnBrew" & $aLastResult[$i][0]))
				EndIf
			Next
		EndIf
		Return $aLastResult
	EndIf
	Return ""
EndFunc	;==>getOnBrewSpell

Func getPreTrainSpell()
	If $g_iDebugSetlogTrain = 1 Then SetLog("============Start getPreTrainSpell ============")
	Local $aLastResult[1][3]
	Local $sDirectory = @ScriptDir & "\COCBot\SamM0d\images\Spell\QueueSpell\"
	Local $returnProps="objectname,objectpoints"
	Local $aCoor, $aPropsValues
	Local $iMax, $jMax
	Local $iCount = 0
	Local $aCoorXY
	Local $StartAtSlot = -1

	$preLightning = 0
	$preRage = 0
	$preJump = 0
	$preHeal = 0
	$preFreeze = 0
	$preClone = 0
	$prePoison = 0
	$preHaste = 0
	$preSkeleton = 0
	$preEarth = 0

	If _ColorCheck(_GetPixelColor(818,202,True), Hex(0XCFCFC8, 6), 10) Then Return ""

	$StartAtSlot = getQueueSpellStartSlot()
	If $StartAtSlot < 0 Then Return Setlog("No pre-train spell on queue.", $COLOR_RED)
	If _Sleep(100) Then Return
	_CaptureRegion2(65, 188 + $g_iMidOffsetY, (836 - Int($StartAtSlot * 70.5)) , 202 + $g_iMidOffsetY)

	Local $result = findMultiple($sDirectory ,"FV" ,"FV", 0, 0, 0 , $returnProps, False )
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
						$aLastResult[$iCount][1] = getQueueSpellSlotPosition(Number(65 + $aCoorXY[0]))
						$aLastResult[$iCount][2] = getMyOcr(Number(70 + (($aLastResult[$iCount][1]-1) * 70.5)) , 162 + $g_iMidOffsetY, 30,12,"spellqtypre",True)
					EndIf
					Assign("pre" & $aLastResult[$iCount][0], Eval("pre" & $aLastResult[$iCount][0]) + $aLastResult[$iCount][2])
					$iCount += 1
				Next
			EndIf
		Next
		_ArraySort($aLastResult, 1, 0, 0, 1)
		If $g_iDebugSetlogTrain = 1 Then
			For $i = 0 To UBound($aLastResult) - 1
				SetLog("Afrer _ArraySort - Obj:" & $aLastResult[$i][0] & " Slot:" & $aLastResult[$i][1] & " Qty: " & $aLastResult[$i][2], $COLOR_DEBUG)
				If Eval("pre" & $aLastResult[$i][0]) > 0 Then
					Setlog(" Total Pre-Train " & $aLastResult[$i][0] & ": " & Eval("pre" & $aLastResult[$i][0]))
				EndIf
			Next
		EndIf
		Return $aLastResult
	EndIf
	Return ""
EndFunc	;==>getPreTrainSpell

Func getQueueSpellStartSlot()
	For $i = 0 To 10
		If _Sleep(100) Then Return
		If Not _ColorCheck(_GetPixelColor(805 - Int($i * 70.5) , 156 + $g_iMidOffsetY, True), Hex(0XCFCFC8, 6), 10) Then
			Return $i
		Else
			If	$i = 10 Then
				Return $i
			EndIf
		EndIf
	Next
EndFunc

Func getQueueSpellSlotPosition($InputX)
	Switch $InputX
		Case $InputX >= 62 And $InputX <= 133
			Return 1
		Case $InputX >= 136 And $InputX <= 203
			Return 2
		Case $InputX >= 206 And $InputX <= 274
			Return 3
		Case $InputX >= 277 And $InputX <= 344
			Return 4
		Case $InputX >= 347 And $InputX <= 415
			Return 5
		Case $InputX >= 418 And $InputX <= 485
			Return 6
		Case $InputX >= 488 And $InputX <= 556
			Return 7
		Case $InputX >= 559 And $InputX <= 626
			Return 8
		Case $InputX >= 629 And $InputX <= 696
			Return 9
		Case $InputX >= 696 And $InputX <= 767
			Return 10
		Case $InputX >= 780 And $InputX <= 837
			Return 11
		Case Else
			Return 99
	EndSwitch
EndFunc   ;==>GetSpellSlotPosition