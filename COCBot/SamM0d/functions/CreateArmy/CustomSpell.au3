; #FUNCTION# ====================================================================================================================
; Name ..........: CustomSpells
; Description ...: Create Normal Spells and Dark Spells with pre-brew if needed.
; Syntax ........: CustomSpells()
; Parameters ....:
; Return values .: None
; Author ........: Samkie (19 JUN 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CustomSpells()

	If $g_iTotalSpellValue = 0 Then Return




	If $iLightningSpellComp > 0 Or $iRageSpellComp > 0 Or $iHealSpellComp > 0 Or $iJumpSpellComp > 0 Or $iFreezeSpellComp > 0 Or $iCloneSpellComp > 0 Or $iPoisonSpellComp > 0 Or $iEarthSpellComp > 0 Or $iHasteSpellComp > 0 Or $iSkeletonSpellComp > 0 Then

	Local $aOnBrewSpell
	Local $aPreTrainSpell
	Local $aSpellCapacity
	Local $iRemainCapacity
	Local $iTotalSpellCapacity = 0
	Local $iTotalCurOnBrewSpellCapacity = 0
	Local $iTotalPreBrewSpellCapacity = 0

	Local $bFlagOutOfResource = False
	Local $bLoopFlag = True
	Local $iCount = 0
	Local $bRemFlag = False
	Local $bAddFlag = False
	Local $bPreBrewSpellEnable = False
	Local $bOrPrebrewspell
	Local $bWait4Spell = False
	Local $iBrewSpellTime = 0

	If $g_abAttackTypeEnable[$LB] = True And $g_abSearchSpellsWaitEnable[$LB] = True Then
		$bWait4Spell = True
	EndIf
	If $g_abAttackTypeEnable[$DB] = True And $g_abSearchSpellsWaitEnable[$DB] = True Then
		$bWait4Spell = True
	EndIf



	While $bLoopFlag

		$iCount += 1
		If $iCount > 5 Then ExitLoop

		;reset add/remove variable for each loop
		$bOrPrebrewspell = 0
		For $i = $enumLightning To $enumSkeleton
			Assign("Add" & $MySpells[$i][0] & "Spell", 0)
			Assign("Rem" & $MySpells[$i][0] & "Spell", 0)
			$bOrPrebrewspell = BitOR($bOrPrebrewspell, Eval("ichkPre" & $MySpells[$i][0]))
		Next
		If $bOrPrebrewspell = 0 Then $ichkForcePreBrewSpell = 0

		$bRemFlag = False
		$bAddFlag = False
		$iTotalSpellCapacity = 0
		$iTotalPreBrewSpellCapacity = 0
		$iTotalCurOnBrewSpellCapacity = 0
		$iRemainCapacity = 0
		$iBrewSpellTime = 0
		$bFlagOutOfResource = False

		If $ichkForcePreBrewSpell = 1 Then
			$bPreBrewSpellEnable = True
		Else
			$bPreBrewSpellEnable = False
		EndIf

		If _Sleep(250) Then Return

		If gotoArmy() = True Then
			getArmySpellTime()
			If _Sleep(10) Then Return ; 10ms improve pause button response
			$iBrewSpellTime = $g_aiTimeTrain[1]

			If $iBrewSpellTime <= 0 Then
				getMyArmySpellCount(False,False,True)
				If $g_bFullArmySpells Then
					If $bOrPrebrewspell = 0 Then
						If _ColorCheck(_GetPixelColor(586, 100 + $g_iMidOffsetY, True), Hex(0X5A5748, 6), 20) = False Then
							If gotoBrewSpells() Then
								If _Sleep(1000) Then Return
								If _ColorCheck(_GetPixelColor(808, 156 + $g_iMidOffsetY, True), Hex(0xD7AFA9, 6), 10) Then ; pink color
									RemoveAllTroopAlreadyTrain()
									If _Sleep(1000) Then Return
								EndIf
								If gotoArmy() = False Then
									SetLog("Cannot open army overview tab page.",$COLOR_ERROR)
								EndIf
							Else
								SetLog("Cannot open brew spell tab page.",$COLOR_ERROR)
							EndIf
						EndIf
						Return
					Else
						$bPreBrewSpellEnable = True
					EndIf
				Else
					If _ColorCheck(_GetPixelColor(586, 100 + $g_iMidOffsetY, True), Hex(0X5E5748, 6), 20) = False Then ;color green arrow > not appear
						If $g_iDebugSetlogTrain = 1 Then Setlog("Check on brew spells, is that stuck...")
						If gotoBrewSpells() Then
							If _Sleep(1000) Then Return
							If _ColorCheck(_GetPixelColor(808, 156 + $g_iMidOffsetY, True), Hex(0xD7AFA9, 6), 10) Then ; pink color = stuck, so we remove the spells
								RemoveAllTroopAlreadyTrain()
								If _Sleep(1000) Then Return
							EndIf
						Else
							SetLog("Cannot open brew spell tab page.",$COLOR_ERROR)
							Return
						EndIf
					EndIf
				EndIf
			Else
				If $iBrewSpellTime > $itxtStickToTrainWindow Then
					If $ichkForcePreBrewSpell = 0 And $bWait4Spell = False Then ExitLoop
				Else
					If $bWait4Spell Then
						Local $iStickDelay
						If $iBrewSpellTime < 1 Then
							$iStickDelay = Int($iBrewSpellTime * 60000)
						ElseIf $iBrewSpellTime >= 2 Then
							$iStickDelay = 60000
						Else
							$iStickDelay = 30000
						EndIf
						If _Sleep($iStickDelay) Then Return
						ContinueLoop
					EndIf
				EndIf
				getMyArmySpellCount(False,False,True)
			EndIf
		Else
			SetLog("Error: Cannot open Army Over View page",$COLOR_ERROR)
			Return
		EndIf

		If gotoBrewSpells() = True Then

			Local $iCount2 = 0
			;	check donate or other message block for detect spell count
			If _Sleep(250) Then Return
			While IsQueueBlockByMsg()
				If _Sleep(1000) Then Return
				$iCount2 += 1
				If $iCount2 >= 30 Then
					ExitLoop
				EndIf
			WEnd

			$aSpellCapacity = getBrewSpellCapacity()

			If $aSpellCapacity = "" Then Return

			$aOnBrewSpell = getOnBrewSpell()
			$aPreTrainSpell = getPreTrainSpell()

			; check total all avaible spell and brew spell
			For $i = $enumLightning To $enumSkeleton
				Local $tempComp = Eval("i" & $MySpells[$i][0] & "SpellComp")
				Local $tempCur = Eval("Cur" & $MySpells[$i][0] & "Spell")
				Local $tempOnBrew = Eval("OnBrew" & $MySpells[$i][0])
				Local $tempPre = Eval("pre" & $MySpells[$i][0])

				If $g_iDebugSetlogTrain = 1 Then SetLog("$tempComp: " & $tempComp)
				If $g_iDebugSetlogTrain = 1 Then SetLog("$tempCur: " & $tempCur)
				If $g_iDebugSetlogTrain = 1 Then SetLog("$tempOnBrew: " & $tempOnBrew)
				If $g_iDebugSetlogTrain = 1 Then SetLog("$tempPre: " & $tempPre)

				$iTotalSpellCapacity += ($MySpells[$i][2] * ($tempCur + $tempOnBrew + $tempPre))
				$iTotalCurOnBrewSpellCapacity += ($MySpells[$i][2] * ($tempCur + $tempOnBrew ))

				If $tempOnBrew > 0 Then
					SetLog(" - No. of On Brew " & MyNameOfTroop($i+23,$tempOnBrew) & ": " & $tempOnBrew, ($i > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				EndIf
				If $tempPre > 0 Then
					SetLog(" - No. of Pre-Brew " & MyNameOfTroop($i+23,$tempPre) & ": " & $tempPre, ($i > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				EndIf
			Next

			If $g_iDebugSetlogTrain = 1 Then setlog("$iTotalSpellCapacity: " & $iTotalSpellCapacity)
			If $g_iDebugSetlogTrain = 1 Then setlog("$iTotalPreBrewSpellCapacity: " & $iTotalPreBrewSpellCapacity)

			If $iTotalSpellCapacity <> $aSpellCapacity[0] Then
				SetLog("Total capacity of spell not same with what we already brew.",$COLOR_ERROR)
				SetLog("Maybe is donate messages block when detect spell.",$COLOR_ERROR)
				SetLog("Or OCR wrong detect quantity, please turn on debug train and message.",$COLOR_ERROR)
				SetLog("Retry: " & $iCount,$COLOR_ERROR)
				If _sleep(1000) Then Return
				ContinueLoop
			EndIf

			$iRemainCapacity = $aSpellCapacity[1] - $iTotalCurOnBrewSpellCapacity
			For $i = $enumLightning To $enumSkeleton
				Local $tempComp = Eval("i" & $MySpells[$i][0] & "SpellComp")
				Local $tempCur = Eval("Cur" & $MySpells[$i][0] & "Spell")
				Local $tempOnBrew = Eval("OnBrew" & $MySpells[$i][0])

				If $tempComp <> $tempCur + $tempOnBrew Then
					Local $DifFlag = $tempComp - ($tempCur + $tempOnBrew)
					If $DifFlag > 0 Then
						If $g_iDebugSetlogTrain = 1 Then SetLog("Some spell haven't brew: " & $MySpells[$i][0])
						If $g_iDebugSetlogTrain = 1 Then SetLog("Setting Qty Of " & $MySpells[$i][0] & " Spell: " & $tempComp)
						If ($DifFlag * $MySpells[$i][2]) > $iRemainCapacity Then
							$DifFlag = Int($iRemainCapacity / $MySpells[$i][2])
						EndIf
						If $DifFlag > 0 Then
							SetLog("Prepare for brew number Of " & MyNameOfTroop($i+23,$DifFlag) & " x" & $DifFlag,$COLOR_ACTION)
							Assign("Add" & $MySpells[$i][0] & "Spell", $DifFlag)
							$bAddFlag = True
						EndIf
					ElseIf $DifFlag < 0 Then
						If $g_iDebugSetlogTrain = 1 Then SetLog("Some spell over brew: " & $MySpells[$i][0])
						If $g_iDebugSetlogTrain = 1 Then SetLog("Setting Qty Of " & $MySpells[$i][0] & " Spell: " & $tempComp)
						If $g_iDebugSetlogTrain = 1 Then SetLog("Current Qty Of " & $MySpells[$i][0] & " Spell: " & $tempComp - $DifFlag)
						If $g_iDebugSetlogTrain = 1 Then setlog("OnBrew: " & $tempOnBrew,$COLOR_RED)
						If $g_iDebugSetlogTrain = 1 Then setlog("SpellComp: " & $tempComp,$COLOR_RED)
						If $tempOnBrew > 0 Then
							Assign("Rem" & $MySpells[$i][0] & "Spell", $tempOnBrew - ($tempComp - $tempCur))
							$bRemFlag = True
						EndIf
					EndIf
				EndIf
			Next

			If $g_iDebugSetlogTrain = 1 Then SetLog("$bAddFlag: " & $bAddFlag)
			If $g_iDebugSetlogTrain = 1 Then SetLog("$bRemFlag: " & $bRemFlag)

			; $bAddFlag = False And $bRemFlag = False , mean onbrew spell are correct, then we continue add pre-brew spell
			If $bAddFlag = False And $bRemFlag = False Then
				; checking pretrain spell
				$bLoopFlag = False

				Local $iTotalSpellCompCapacity
				For $i = $enumLightning To $enumSkeleton
					Local $tempComp = Eval("i" & $MySpells[$i][0] & "SpellComp")
					Local $tempPre = Eval("pre" & $MySpells[$i][0])
					If Eval("ichkPre" & $MySpells[$i][0]) = 1 Then
						$iTotalSpellCompCapacity += ($MySpells[$i][2] * $tempComp)
						If $tempComp <> $tempPre Then
							Local $DifFlag = $tempComp - $tempPre
							If $DifFlag > 0 Then
								If $bPreBrewSpellEnable Then
									SetLog("Prepare for Pre-Brew number Of " & MyNameOfTroop($i+23,$DifFlag) & " x" & $DifFlag,$COLOR_ACTION)
									Assign("Add" & $MySpells[$i][0] & "Spell", $DifFlag)
									$bAddFlag = True
								EndIf
							ElseIf $DifFlag < 0 Then
								If $tempPre > $tempComp Then
									Assign("Rem" & $MySpells[$i][0] & "Spell", $tempPre)
									$bRemFlag = True
								EndIf
							EndIf
						EndIf
					Else
						If $tempPre > 0 Then
							Assign("Rem" & $MySpells[$i][0] & "Spell", $tempPre)
							$bRemFlag = True
						EndIf
					EndIf
				Next

				If $bRemFlag Then
					; remove extra spell
					For $i = UBound($aPreTrainSpell) - 1 to 0 Step -1
						If Eval("Rem" & $aPreTrainSpell[$i][0] & "Spell") > 0 Then
							If Eval("Rem" & $aPreTrainSpell[$i][0] & "Spell") > $aPreTrainSpell[$i][2] Then
								RemoveSpell($aPreTrainSpell[$i][1],$aPreTrainSpell[$i][2])
								Assign("Rem" & $aPreTrainSpell[$i][0] & "Spell", Eval("Rem" & $aPreTrainSpell[$i][0] & "Spell") - $aPreTrainSpell[$i][2])
							Else
								RemoveSpell($aPreTrainSpell[$i][1],Eval("Rem" & $aPreTrainSpell[$i][0] & "Spell"))
								Assign("Rem" & $aPreTrainSpell[$i][0] & "Spell",0)
							EndIf
						EndIf
					Next
				EndIf
				;$tempDisableBrewSpell = True ;since all brew run fine, temparary disable brew until donate spell make
			Else
				; checking onbrew spell, check what need add and remove
				If IsArray($aPreTrainSpell) Then ;remove all pretrain spell for train onbrew first
					SetLog("Remove pre-train spell...",$COLOR_ACTION)
					For $i = UBound($aPreTrainSpell) - 1 To 0 Step - 1
						If $g_iDebugSetlogTrain = 1 Then SetLog("$aPreTrainSpell: " & $aPreTrainSpell[$i][0] & "," & $aPreTrainSpell[$i][1] & "," & $aPreTrainSpell[$i][2])
						RemoveSpell($aPreTrainSpell[$i][1],$aPreTrainSpell[$i][2])
						If _sleep(250) Then Return
					Next
				EndIf
				; remove extra spell
				For $i = UBound($aOnBrewSpell) - 1 to 0 Step -1
					If Eval("Rem" & $aOnBrewSpell[$i][0] & "Spell") > 0 Then
						If Eval("Rem" & $aOnBrewSpell[$i][0] & "Spell") > $aOnBrewSpell[$i][2] Then
							RemoveSpell($aOnBrewSpell[$i][1],$aOnBrewSpell[$i][2],True)
							Assign("Rem" & $aOnBrewSpell[$i][0] & "Spell", Eval("Rem" & $aOnBrewSpell[$i][0] & "Spell") - $aOnBrewSpell[$i][2])
						Else
							RemoveSpell($aOnBrewSpell[$i][1],Eval("Rem" & $aOnBrewSpell[$i][0] & "Spell"),True)
							Assign("Rem" & $aOnBrewSpell[$i][0] & "Spell",0)
						EndIf
					EndIf
				Next
			EndIf

			If $bAddFlag Then
				; start brew
				Local $tempSpells[10][5]
				$tempSpells	= $MySpells

				If $ichkMySpellsOrder Then
					_ArraySort($tempSpells,0,0,0,1)
				EndIf

				If $g_iDebugSetlogTrain = 1 Then SetLog("Start brew spell that assign with 'Add' ")
				Local $iCreatedSpellCapacity = 0
				For $i = 0 To UBound($tempSpells) - 1
					Local $tempSpell = Eval("Add" & $tempSpells[$i][0] & "Spell")
					If $tempSpell > 0 Then
						Local $tempButton = Eval("aButtonBrew" & $tempSpells[$i][0])

						Local $iCost
						; check train cost before click, incase use gem
						If $tempSpells[$i][4] = 0 Then
							$iCost = getSpellCost($tempSpells[$i][0])
							If $iCost = 0 Then
								; cannot read train cost, use max level train cost
								;$iCost = $MySpellsCost[$i][0]
								$iCost = $MySpellsCost[Eval("enum" & $tempSpells[$i][0])][0]
							EndIf
							$tempSpells[$i][4] = $iCost
							$MySpells[Eval("enum" & $tempSpells[$i][0])][4] = $iCost
						EndIf

						$iCost = $tempSpells[$i][4]
						If $g_iDebugSetlogTrain = 1 Then SetLog("$iCost: " & $iCost)

						Local $iBuildCost = ($i > 5 ? getMyOcrCurDEFromTrain() : getMyOcrCurElixirFromTrain())

						If $g_iDebugSetlogTrain = 1 Then SetLog("$BuildCost: " & $iBuildCost)
						If $g_iDebugSetlogTrain = 1 Then SetLog("Total need: " & ($tempSpell * $iCost))
						If ($tempSpell * $iCost) > $iBuildCost Then
							$bFlagOutOfResource = True
							Setlog("Not enough " & ( $i > 5 ? "Dark" : "") & " Elixir to brew " & MyNameOfTroop(Eval("enum" & $tempSpells[$i][0])+23,0), $COLOR_ERROR)
						EndIf

						If $bFlagOutOfResource Then
							$g_bOutOfElixir = 1
							Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_ERROR)
							$g_bChkBotStop = True ; set halt attack variable
							$g_icmbBotCond = 18; set stay online
							If Not ($g_bfullarmy = True) Then $g_bRestart = True ;If the army camp is full, If yes then use it to refill storages
							Return ; We are out of Elixir stop training.
						EndIf

						SetLog("Ready to brew " & MyNameOfTroop(Eval("enum" & $tempSpells[$i][0])+23,$tempSpell) & " x" & $tempSpell & " with total " & ( $i > 5 ? "Dark " : "") & "Elixir: " & ($tempSpell * $iCost),($i > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))

						MyTrainClick($tempButton,$tempSpell,$g_iTrainClickDelay,"#BS01")
						$iCreatedSpellCapacity += ($tempSpells[$i][2] * $tempSpell)
					EndIf
				Next
				If $bOrPrebrewspell = 0 Then $tempDisableBrewSpell = True
				If $bPreBrewSpellEnable = True And $bLoopFlag = False Then $tempDisableBrewSpell = True
			Else
				$tempDisableBrewSpell = True
			EndIf
		Else
			SetLog("Error: Cannot open Brew Spells page",$COLOR_ERROR)
			Return
		EndIf
		; reduce some speed
		If _Sleep(500) Then Return
	WEnd
	EndIf
EndFunc   ;==>CustomSpells

Func RemoveSpell($iSlot, $iTime=1, $bColorFlag = False)
	Local $icount = 0
	Local $iRanX, $iRanY

	For $i = 1 To $iTime
		If _ColorCheck(_GetPixelColor(118 + Int(($iSlot - 1) * 70.5) , 155 + $g_iMidOffsetY, True), Hex(0XCFCFC8, 6), 5) = $bColorFlag Then
			$iRanX = 118 + Int(($iSlot - 1) * 70.5)
			$iRanY = 169 + $g_iMidOffsetY
			HMLClick(Random($iRanX-2,$iRanX+2,1), Random($iRanY-2,$iRanY+2,1),1,0,"#0703")
			If _Sleep(Random(($g_iTrainClickDelay*90)/100, ($g_iTrainClickDelay*110)/100, 1), False) Then ExitLoop
		EndIf
	Next
EndFunc

Func getBrewSpellCapacity()
	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getBrewSpellCapacity:", $COLOR_DEBUG1)

	Local $aGetSFactorySize
	Local $iCount
	Local $sSpellsInfo = ""
	Local $CurBrewSFactory = 0
	Local $tempCurS = 0
	Local $tempCurT = 0

	; Verify spell current and total capacity
	If $g_iTotalSpellValue > 0 Then ; only use this code if the user had input spells to brew ... and assign the spells quantity
		$iCount = 0 ; reset OCR loop counter
		While $iCount < 20 ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid
			;$sSpellsInfo = getArmyCampCap($aArmySpellSize[0], $aArmySpellSize[1]) ; OCR read Spells and total capacity
			; samm0d
			$sSpellsInfo = getMyOcrTrainArmyOrBrewSpellCap() ; OCR read Spells and total capacity
			$aGetSFactorySize = StringSplit($sSpellsInfo, "#", $STR_NOCOUNT) ; split the existen Spells from the total Spell factory capacity
			If IsArray($aGetSFactorySize) Then
				If UBound($aGetSFactorySize) > 1 Then
					If $aGetSFactorySize[0] <> "" And $aGetSFactorySize[1] <> "" Then
						If $tempCurS = Number($aGetSFactorySize[0]) And $tempCurT = Number($aGetSFactorySize[1]) Then ExitLoop
						$tempCurS = Number($aGetSFactorySize[0])
						$tempCurT = Number($aGetSFactorySize[1])
					EndIf
				EndIf
			EndIf
			$iCount += 1
			If _Sleep(200) Then Return ""; Wait 200ms
		WEnd

		If $iCount >= 20 Then
			If $g_iDebugSetlogTrain = 1 Then Setlog("$sSpellsInfo = " & $sSpellsInfo, $COLOR_DEBUG)
			SetLog("Error reading ocr for brew spells capacity, please check your setting or contact author.", $COLOR_ERROR)
			Return ""
		Else
			If $g_iDebugSetlogTrain = 1 Then Setlog("$sSpellsInfo = " & $sSpellsInfo, $COLOR_DEBUG)
			;$TotalSFactory = $tempCurT
			$CurBrewSFactory = $tempCurS
			SetLog("Brew Spells: " & $CurBrewSFactory & "/" & $tempCurT)
		EndIf
	EndIf

	If ($tempCurT / 2) <> $g_iTotalSpellValue Then
		Setlog("Note: Spell Factory Size read not same User Input Value.", $COLOR_WARNING) ; log if there difference between user input and OCR
	EndIf

	Return $aGetSFactorySize
EndFunc   ;==>getBrewSpellCapacity
