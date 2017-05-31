; #FUNCTION# ====================================================================================================================
; Name ..........: CustomTrain,DoCheckReVamp
; Description ...: Train custom troops base on gui setting, revamp donated troops.
; Syntax ........: CustomTrain(),DoCheckReVamp($bDoFullTrain = False)
; Parameters ....:
; Return values .: None
; Author ........: Samkie (27 Dec 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the term
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $IsFullArmywithHeroesAndSpells = False

Func CustomTrain()
	Local $tempCounter = 0
	Local $tempElixir = ""
	Local $tempDElixir = ""
	Local $tempElixirSpent = 0
	Local $tempDElixirSpent = 0
	Local $bNotStuckJustOnBoost = False

	If $g_iDebugSetlogTrain = 1 Then SetLog("Func Train ", $COLOR_DEBUG)
	If $g_bTrainEnabled = False Then Return

	StartGainCost()

	SetLog("Training Troops & Spells", $COLOR_INFO)
	If _Sleep(100) Then Return
	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
	If _Sleep(200) Then Return

	If _Sleep(50) Then Return
	checkAttackDisable($g_iTaBChkIdle)
	If $g_bRestart = True Then Return

	;OPEN ARMY OVERVIEW WITH NEW BUTTON
	; WaitforPixel($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10)
	If WaitforPixel(31, 515 + $g_iBottomOffsetY, 33, 517 + $g_iBottomOffsetY, Hex(0xFFFDED, 6), 10, 20) Then
		If $g_iDebugSetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
		If IsMainPage() Then
			If $g_bUseRandomClick = False Then
				Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#1293") ; Button Army Overview
			Else
				ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
			EndIf
		EndIf
	EndIf

	If _Sleep(250) Then Return

	getArmyHeroCount()
	If _Sleep(50) Then Return ; 10ms improve pause button response

	getArmyCCCapacity()
	If _Sleep(50) Then Return ; 10ms improve pause button response

	getMyArmyCapacity()
	If _Sleep(50) Then Return ; 10ms improve pause button response

;~ 	If $g_bQuickTrainEnable = 1 Then
;~ 		If Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100) >= 95 And $g_CurrentCampUtilization <> $g_iTotalCampSpace Then
;~ 			Setlog("Check troops queue in train, is that any troops stuck...")
;~ 			If gotoTrainTroops() Then
;~ 				If _Sleep(1000) Then Return
;~ 				If _ColorCheck(_GetPixelColor(808, 156 + $g_iMidOffsetY, True), Hex(0xD7AFA9, 6), 10) Then ; pink color
;~ 					RemoveAllTroopAlreadyTrain()
;~ 					If _Sleep(1000) Then Return
;~ 				Else
;~ 					Setlog("Troops train working fine.",$COLOR_SUCCESS)
;~ 				EndIf
;~ 			Else
;~ 				SetLog("Cannot open train troops tab page.",$COLOR_ERROR)
;~ 				Return
;~ 			EndIf
;~ 		EndIf
;~ 		QuickTrain($iCmbCurrentArmy, False)
;~ 	Else
		getArmyTroopTime()
		If _Sleep(50) Then Return

		; stick to train page until troop finish
		Local $iCount = 0
		While 1
			If $bRestartCustomTrain Then $iCount = 0
			$bRestartCustomTrain = False

			If _Sleep(50) Then Return
			checkAttackDisable($g_iTaBChkIdle)
			If $g_bRestart = True Then Return

			$iCount += 1
			If $iCount > (10 + $itxtStickToTrainWindow) Then ExitLoop
			If $g_aiTimeTrain[0] <= 0 Then
				;getMyArmyCapacity()
				;If _Sleep(50) Then Return
				If $iSamM0dDebug Then SetLog("$g_bFullArmy: " & $g_bFullArmy)
				If $g_bFullArmy = False Then
					;If _ColorCheck(_GetPixelColor(389, 99 + $g_iMidOffsetY, True), Hex(0X6AB31F, 6), 10) = False Then ;color green arrow > not appear. no troops on train, direct revamp troops
					If _ColorCheck(_GetPixelColor(389, 100 + $g_iMidOffsetY, True), Hex(0X5E5748, 6), 20) Or $bNotStuckJustOnBoost Then ;color green arrow > not appear. no troops on train, direct revamp troops
						; situation need revamp
						getMyArmyTroopCount()
						If $bRestartCustomTrain Then ContinueLoop

						If _Sleep(50) Then Return
						DoCheckReVamp()
						If _Sleep(50) Then Return
						If gotoArmy() Then ; get train troops time before exit loop
							getArmyTroopTime()
							If _Sleep(50) Then Return
						EndIf
						ExitLoop
					Else ; when train time = 0 and troops are not full and got some troops on train
						;If Int(($g_CurrentCampUtilization / (($g_iTotalCampSpace * $g_iTrainArmyFullTroopPct) / 100)) * 100) >= 95 And $g_CurrentCampUtilization <> (($g_iTotalCampSpace * $g_iTrainArmyFullTroopPct) / 100) Then
							Setlog("Check troops queue in train, is that any troops stuck...")
							If gotoTrainTroops() Then
								If _Sleep(1000) Then Return
								If _ColorCheck(_GetPixelColor(808, 156 + $g_iMidOffsetY, True), Hex(0xD7AFA9, 6), 10) Then ; pink color
									RemoveAllTroopAlreadyTrain()
									If _Sleep(1000) Then Return
								;Else
								;	Setlog("Troops train working fine.",$COLOR_SUCCESS)
								EndIf

								$bNotStuckJustOnBoost = True

								If gotoArmy() = False Then
									SetLog("Cannot open army overview tab page.",$COLOR_ERROR)
									Return
								EndIf
							Else
								SetLog("Cannot open train troops tab page.",$COLOR_ERROR)
								Return
							EndIf

						;EndIf
					EndIf
				Else
					If $ichkDisablePretrainTroops = 1 Then
						;If _ColorCheck(_GetPixelColor(389, 99 + $g_iMidOffsetY, True), Hex(0X6AB31F, 6), 10) Then
						If _ColorCheck(_GetPixelColor(389, 100 + $g_iMidOffsetY, True), Hex(0X5E5748, 6), 20) = False Then
							If gotoTrainTroops() Then
								If _Sleep(1000) Then Return
								If _ColorCheck(_GetPixelColor(808, 156 + $g_iMidOffsetY, True), Hex(0xD7AFA9, 6), 10) Then ; pink color
									RemoveAllTroopAlreadyTrain()
									If _Sleep(1000) Then Return
								EndIf
							Else
								SetLog("Cannot open train troops tab page.",$COLOR_ERROR)
							EndIf
						Else
							getMyArmyTroopCount()
							If $bRestartCustomTrain Then ContinueLoop
							If _Sleep(50) Then Return
						EndIf
					Else
						getMyArmyTroopCount()
						If $bRestartCustomTrain Then ContinueLoop
						If _Sleep(50) Then Return
						If $icmbMyQuickTrain = 0 Then
							DoCheckReVamp(True)
						Else
							DoMyQuickTrain($icmbMyQuickTrain)
						EndIf
					EndIf
					ExitLoop
				EndIf
			Else
				If $ichkEnableDeleteExcessTroops = 1 Then
					If _Sleep(50) Then Return
					getMyArmyTroopCount()
					If $bRestartCustomTrain Then ContinueLoop
				EndIf

				If $g_aiTimeTrain[0] > $itxtStickToTrainWindow Then
					If $g_bDropTrophyEnable = True Then
						If _Sleep(50) Then Return
						getMyArmyTroopCount()
					EndIf
					ExitLoop
				EndIf
			EndIf
			Local $iStickDelay
			If $g_aiTimeTrain[0] < 1 Then
				$iStickDelay = Int($g_aiTimeTrain[0] * 60000) + 250
			ElseIf $g_aiTimeTrain[0] >= 2 Then
				$iStickDelay = 60000
			Else
				$iStickDelay = 30000
			EndIf
			If _Sleep($iStickDelay) Then Return
			getMyArmyCapacity()
			If _Sleep(50) Then Return ; 10ms improve pause button response
			getArmyTroopTime()
			If _Sleep(50) Then Return
		WEnd
;~ 	EndIf

	If $g_iDebugSetlogTrain = 1 Then SetLog("$tempDisableBrewSpell: " & $tempDisableBrewSpell)

	If $tempDisableBrewSpell = False Then
		If _Sleep(50) Then Return
		CustomSpells()
	Else
		; continue check getMyArmySpellCount() until $g_bFullArmySpells = True
		If $g_bFullArmySpells = False Then
			If gotoArmy() Then
				If _Sleep(50) Then Return
				getMyArmySpellCount()
			EndIf
		EndIf
	EndIf

	If $ichkEnableMySwitch = 1 Then
		If gotoArmy() Then
			Local $iKTime[5] = [0,0,0,0,0]
			getArmyTroopTime(False,False)
			$iKTime[4] = $g_aiTimeTrain[0]
			If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing Then
				$iKTime[0] = getArmyHeroTime($eHeroKing)
			EndIf
			If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen Then
				$iKTime[1] = getArmyHeroTime($eHeroQueen)
			EndIf
			If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden Then
				$iKTime[2] = getArmyHeroTime($eHeroWarden)
			EndIf
			If $g_abSearchSpellsWaitEnable[$DB] Or $g_abSearchSpellsWaitEnable[$LB] Then
				getArmySpellTime()
				$iKTime[3] = $g_aiTimeTrain[1]
			EndIf
			_ArraySort($iKTime,1)
			If $iCurActiveAcc <> -1 Then
				For $i = 0 To UBound($aSwitchList) - 1
					If $aSwitchList[$i][4] = $iCurActiveAcc Then
						$aSwitchList[$i][0] = _DateAdd('n', $iKTime[0], _NowCalc())
						ExitLoop
					EndIf
				Next
			EndIf
		EndIf
	EndIf

	If gotoArmy() Then
		getArmyCCStatus()
		If _Sleep(50) Then Return ; 10ms improve pause button response
	Else
		SetLog("Cannot open army overview tab page.",$COLOR_ERROR)
	EndIf


	If $g_iDebugSetlogTrain = 1 Then Setlog("Fullarmy = " & $g_bFullArmy & " CurCamp = " & $g_CurrentCampUtilization & " TotalCamp = " & $g_iTotalCampSpace & " - result = " & ($g_bFullArmy = True And $g_CurrentCampUtilization = $g_iTotalCampSpace), $COLOR_DEBUG)
	If $g_bFullArmy = True Then
		SetLog("Your Army Camps are now Full", $COLOR_SUCCESS, "Times New Roman", 10)
		If (($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertCampFull = True) Then PushMsg("CampFull")
	EndIf

	If _Sleep(200) Then Return
	ClickP($aAway, 1, 250, "#0504")
	If _Sleep(250) Then Return
	;ClickP($aAway, 1, 250, "#0504")

	$g_bFirstStart = False

	;;;;;; Protect Army cost stats from being missed up by DC and other errors ;;;;;;;
	If _Sleep(200) Then Return

	EndGainCost("Train")
	UpdateStats()

	If $g_bFullArmySpells = False Then
		$g_bFullArmySpells = ($g_abAttackTypeEnable[$DB] = True And $g_abSearchSpellsWaitEnable[$DB] = False) Or ($g_abAttackTypeEnable[$LB] = True And $g_abSearchSpellsWaitEnable[$LB] = False)
	EndIf

	If $g_bFullArmy = True And $g_bFullArmyHero = True And $g_bFullArmySpells = True Then
		$g_bIsFullArmywithHeroesAndSpells = True
	Else
		$g_bIsFullArmywithHeroesAndSpells = False
	EndIf
EndFunc   ;==>CustomTrain

Func DoCheckReVamp($bDoFullTrain = False)

	If _Sleep(500) Then Return
	Local $bReVampFlag = False
	Local $tempTroops[19][5]
	$tempTroops	= $MyTroops

	If $ichkMyTroopsOrder Then
		_ArraySort($tempTroops,0,0,0,1)
	EndIf

	For $i = 0 To UBound($tempTroops) - 1
		If $g_iDebugSetlogTrain = 1 Then SetLog("$tempTroops[" & $i & "]: " & $tempTroops[$i][0] & " - " & $tempTroops[$i][1])
		; reset variable
		Assign("Dif" & $tempTroops[$i][0],0)
		Assign("Add" & $tempTroops[$i][0],0)
	Next

	If $bDoFullTrain = False Then
		For $i = 0 To UBound($tempTroops) - 1
			Local $tempCurComp = $tempTroops[$i][3]
			Local $tempCur = Eval("Cur" & $tempTroops[$i][0])
			If $g_iDebugSetlogTrain = 1 Then SetLog("$tempMyTroops: " & $tempCurComp)
			If $g_iDebugSetlogTrain = 1 Then SetLog("$tempCur: " & $tempCur)
			If $tempCurComp <> $tempCur Then
				Assign("Dif" & $tempTroops[$i][0], $tempCurComp - $tempCur)
			EndIf
		Next
	Else
		For $i = 0 To UBound($tempTroops) - 1
			If $tempTroops[$i][3] > 0 Then
				Assign("Dif" & $tempTroops[$i][0], $tempTroops[$i][3])
			EndIf
		Next
	EndIf

	For $i = 0 To UBound($tempTroops) - 1
		If Eval("Dif" & $tempTroops[$i][0]) > 0 Then
			If $g_iDebugSetlogTrain = 1 Then SetLog("Some troops haven't train: " & $tempTroops[$i][0])
			If $g_iDebugSetlogTrain = 1 Then SetLog("Setting Qty Of " & $tempTroops[$i][0] & " troops: " & $tempTroops[$i][3])
			;SetLog("Prepare for train number Of " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]), Eval("Dif" & $tempTroops[$i][0])) & " x" & Eval("Dif" & $tempTroops[$i][0]),$COLOR_ACTION)
			Assign("Add" & $tempTroops[$i][0], Eval("Dif" & $tempTroops[$i][0]))
			$bReVampFlag = True
		ElseIf Eval("Dif" & $tempTroops[$i][0]) < 0 Then
			If $g_iDebugSetlogTrain = 1 Then SetLog("Some troops over train: " & $tempTroops[$i][0])
			If $g_iDebugSetlogTrain = 1 Then SetLog("Setting Qty Of " & $tempTroops[$i][0] & " troops: " & $tempTroops[$i][3])
			If $g_iDebugSetlogTrain = 1 Then SetLog("Current Qty Of " & $tempTroops[$i][0] & " troops: " & $tempTroops[$i][3]- Eval("Dif" & $tempTroops[$i][0]))
		EndIf
	Next

	If $bReVampFlag Then
		If gotoTrainTroops() Then
			If _sleep(100) Then Return
			; starttrain
			Local $iRemainTroopsCapacity = 0
			Local $iCreatedTroopsCapacity = 0
			Local $bFlagOutOfResource = False
			If $bDoFullTrain Then
				; delete all exist pretrain troops before full train
				Local $aMaxCapacity = getTrainArmyCapacity()
				If $aMaxCapacity = "" then Return
				If $g_iDebugSetlogTrain = 1 Then SetLog("Train Troops Capacity: " & $aMaxCapacity[0] & "/" & $aMaxCapacity[1])

				If IsArray($aMaxCapacity) Then
					If ($aMaxCapacity[0] >= (Int(($aMaxCapacity[1] * $g_iTrainArmyFullTroopPct) / 100)) And $g_iTrainArmyFullTroopPct <> 100) Then
						SetLog("There are already full troops pre-train, skip train.",$COLOR_INFO)
						Return
					Else
						Local $bNeedRemoveAllTroops = False
						If $g_iTrainArmyFullTroopPct = 100 Then

						;If $aMaxCapacity[0] > (($aMaxCapacity[1] * $g_iTrainArmyFullTroopPct) / 100) Then
							Local $iCount = 0
							Local $iQueueCap = 0
							While $bNeedRemoveAllTroops = False
								$iQueueCap = 0
								Local $iCount2 = 0
								While (_ColorCheck(_GetPixelColor(228, 160 + $g_iMidOffsetY , True), Hex(0xFEFEFE, 6), 5) And _ColorCheck(_GetPixelColor(326, 160 + $g_iMidOffsetY , True), Hex(0xFEFEFE, 6), 5)) Or _ColorCheck(_GetPixelColor(498, 184 + $g_iMidOffsetY , True), Hex(0xFFFFFF, 6), 5) Or _ColorCheck(_GetPixelColor(357, 183 + $g_iMidOffsetY , True), Hex(0xFFFFFF, 6), 5)
									If $g_iDebugSetlogTrain = 1 Then SetLog("Donate or other message blocked screen, postpone action.",$COLOR_RED)
									If _Sleep(1000) Then Return
									$iCount2 += 1
									If $iCount2 >= 30 Then
										ExitLoop
									EndIf
								WEnd

								$iCount += 1
								If $iCount > 3 Then
									$bNeedRemoveAllTroops = True
									ExitLoop
								EndIf
								If _ColorCheck(_GetPixelColor(20,220,True), Hex(0XCFCFC8, 6), 10) = False Then $bNeedRemoveAllTroops = True
								If $bNeedRemoveAllTroops = False Then
									Local $aFindResult
									$aFindResult = getQueueArmyTypeAndSlot()
									If $g_iDebugSetlogTrain = 1 Then SetLog("============End getQueueArmyTypeAndSlot ============")
									If $aFindResult <> "" Then
										For $i = 0 To UBound($aFindResult,$UBOUND_ROWS) - 1
											If $aFindResult[$i][2] <> 0 Then
												Assign("OnQ" & $aFindResult[$i][0], Eval("OnQ" & $aFindResult[$i][0]) + $aFindResult[$i][2])
											Else
												SetLog("Error detect quantity no. On Troop: " & MyNameOfTroop(Eval("e" & $aFindResult[$i][0]), $aFindResult[$i][2]),$COLOR_RED)
												ContinueLoop 2
											EndIf
										Next
									EndIf
									For $i = 0 To UBound($tempTroops) - 1
										Local $iOnQQty = Eval("OnQ" & $tempTroops[$i][0])
										If $iOnQQty > 0 Then
											SetLog(" - No. of On Queue " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]), $iOnQQty) & ": " & $iOnQQty, (Eval("e" & $tempTroops[$i][0]) > 11 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
											$iQueueCap += $tempTroops[$i][2] * $iOnQQty
											If $iOnQQty > Eval("Add" & $tempTroops[$i][0]) Then
												$bNeedRemoveAllTroops = True
												ExitLoop
											EndIf
										EndIf
									Next
									If $iQueueCap <> ($aMaxCapacity[0] - $g_CurrentCampUtilization) Then ContinueLoop
									ExitLoop
								EndIf
								If _Sleep(1000) Then Return
							WEnd
						Else
							$bNeedRemoveAllTroops = True
						EndIf
							If $bNeedRemoveAllTroops = True Then
								;SetLog("There are some old troops remain pre-train, remove all before new train",$COLOR_ACTION)
								RemoveAllTroopAlreadyTrain()
								If $icmbMyQuickTrain <> 0 Then
									DoMyQuickTrain($icmbMyQuickTrain)
									Return
								EndIf
							Else
								; reset build army troops unit
								For $i = 0 To UBound($tempTroops) - 1
									Local $iOnQQty = Eval("OnQ" & $tempTroops[$i][0])
									If $iOnQQty > 0 Then
										If $iOnQQty <= Eval("Add" & $tempTroops[$i][0]) Then
											Assign("Add" & $tempTroops[$i][0], Eval("Dif" & $tempTroops[$i][0]) - $iOnQQty)
										EndIf
									EndIf
								Next
							EndIf
							If _Sleep(1000) Then Return
						;EndIf
					EndIf
				EndIf
				$iRemainTroopsCapacity = $g_iTotalCampSpace
			Else
				$iRemainTroopsCapacity = $g_iTotalCampSpace - $g_CurrentCampUtilization
			EndIf

			For $i = 0 To UBound($tempTroops) - 1
				Local $iOnQQty = Eval("Add" & $tempTroops[$i][0])
				If $iOnQQty > 0 Then
					SetLog("Prepare for train number Of " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]), $iOnQQty) & " x" & $iOnQQty,$COLOR_ACTION)
				EndIf
			Next

			For $i = 0 To UBound($tempTroops) - 1
				Local $Troop4Add = Eval("Add" & $tempTroops[$i][0])
				If $Troop4Add > 0 Then

					Local $tempButton = Eval("aButtonTrain" & $tempTroops[$i][0])
					Local $fixRemain = 0

					; check need swipe
					CheckNeedSwipe(Eval("e" & $tempTroops[$i][0]))

					Local $iCost
					; check train cost before click, incase use gem
					If $tempTroops[$i][4] = 0 Then
						$iCost = getTroopCost($tempTroops[$i][0])
						If $iCost = 0 Then
							; cannot read train cost, use max level train cost
							$iCost = $MyTroopsCost[Eval("e" & $tempTroops[$i][0])][0]
						EndIf
						$tempTroops[$i][4] = $iCost
						$MyTroops[Eval("e" & $tempTroops[$i][0])][4] = $iCost
					EndIf

					$iCost = $tempTroops[$i][4]
					If $g_iDebugSetlogTrain = 1 Then SetLog("$iCost: " & $iCost)

					Local $iBuildCost = (Eval("e" & $tempTroops[$i][0]) > 11 ? getMyOcrCurDEFromTrain() : getMyOcrCurGoldFromTrain())
					If $g_iDebugSetlogTrain = 1 Then SetLog("$iBuildCost: " & $iBuildCost)
					If $g_iDebugSetlogTrain = 1 Then SetLog("Total need: " & ($Troop4Add * $iCost))
					If ($Troop4Add * $iCost) > $iBuildCost Then
						$bFlagOutOfResource = True
						; use eval and not $i to compare because of maybe after array sort $tempTroops
						Setlog("Not enough " & (Eval("e" & $tempTroops[$i][0]) > 11 ? "Dark " : "") & "Elixir to train " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]),0) & " troops!", $COLOR_ERROR)
					EndIf

					If $bFlagOutOfResource Then
						$g_bOutOfElixir = 1
						Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_ERROR)
						$g_bChkBotStop = True ; set halt attack variable
						$g_iCmbBotCond = 18; set stay online
						If Not ($g_bFullArmy = True) Then $g_bRestart = True ;If the army camp is full, If yes then use it to refill storages
						Return ; We are out of Elixir stop training.
					EndIf
					; use eval and not $i to compare because of maybe after array sort $tempTroops
					SetLog("Ready to train " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]),$Troop4Add) & " x" & $Troop4Add & " with total " & (Eval("e" & $tempTroops[$i][0]) > 11 ? "Dark " : "") & "Elixir: " & ($Troop4Add * $iCost),(Eval("e" & $tempTroops[$i][0]) > 11 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))

					If ($tempTroops[$i][2] * $Troop4Add) <= $iRemainTroopsCapacity Then
						MyTrainClick(Eval("aButtonTrain" & $tempTroops[$i][0]),$Troop4Add,$g_iTrainClickDelay,"#TT01")
						$iRemainTroopsCapacity -= ($tempTroops[$i][2] * $Troop4Add)
					Else
						Local $iReduceCap = Int($iRemainTroopsCapacity / $tempTroops[$i][2])
						SetLog("troops above cannot fit to max capicity, reduce to train " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]),$iReduceCap) & " x" & $iReduceCap,$COLOR_ERROR)
						MyTrainClick(Eval("aButtonTrain" & $tempTroops[$i][0]),$iReduceCap ,$g_iTrainClickDelay,"#TT01")
						$fixRemain = $iRemainTroopsCapacity - ($iReduceCap * $tempTroops[$i][2])
						$iRemainTroopsCapacity -= ($iRemainTroopsCapacity - ($iReduceCap * $tempTroops[$i][2]))
					EndIf
					If $fixRemain > 0 Then
						CheckNeedSwipe($eArch)
						SetLog("still got remain capacity, so train " & MyNameOfTroop(Eval("eArch"),$fixRemain) & " x" & $fixRemain & " to fit it.",$COLOR_ERROR)
						MyTrainClick($aButtonTrainArch,$fixRemain,$g_iTrainClickDelay,"#TT01")
						$iRemainTroopsCapacity -= $fixRemain
					EndIf
					; reduce some speed
					If _Sleep(500) Then Return
				EndIf
			Next
		Else
			SetLog("Cannot open train troops tab page.",$COLOR_ERROR)
		EndIf
	EndIf
EndFunc

Func DoMyQuickTrain($MyTrainArmy)
	If gotoTrainTroops() Then
		; delete all exist pretrain troops before full train
		Local $aMaxCapacity = getTrainArmyCapacity()

		If $aMaxCapacity = "" then Return
		If $g_iDebugSetlogTrain = 1 Then SetLog("Train Troops Capacity: " & $aMaxCapacity[0] & "/" & $aMaxCapacity[1])
		If IsArray($aMaxCapacity) Then
			;If $aMaxCapacity[0] >= ((($aMaxCapacity[1] * $g_iTrainArmyFullTroopPct) / 100) * 2) Then
			;	SetLog("There are already full troops pre-train, skip train.",$COLOR_INFO)
			;	Return
			;Else
				If $aMaxCapacity[0] > Int((($aMaxCapacity[1] / 2) * $g_iTrainArmyFullTroopPct) / 100) And $g_iTrainArmyFullTroopPct = 100 Then
					;SetLog("There are some old troops remain pre-train, change to custom train for revamp queue troops.",$COLOR_ACTION)
					DoCheckReVamp(True)
					Return
				Else
					RemoveAllTroopAlreadyTrain()
				EndIf
			;EndIf
		EndIf

		If _Sleep(200) Then Return

		If gotoQuickTrain() = True Then
			Local $aButtonTemp[9]
			Switch $MyTrainArmy
				Case 1
					$aButtonTemp = $aButtonTrainArmy1
				Case 2
					$aButtonTemp = $aButtonTrainArmy2
				case 3
					$aButtonTemp = $aButtonTrainArmy3
			EndSwitch
			If _Sleep(200) Then Return
			If _ColorCheck(_GetPixelColor($aButtonTemp[4], $aButtonTemp[5], True), Hex($aButtonTemp[6], 6), $aButtonTemp[7]) Then
				Local $x, $y
				HMLClickPR($aButtonTemp, $x, $y)
				HMLClick($x, $y)
				SetLog("Train army using quick train army " & $MyTrainArmy & " button.", $COLOR_SUCCESS)
				If _Sleep(200) Then Return
			Else
				SetLog("Failed to locate quick train army " & $MyTrainArmy & " button.", $COLOR_ERROR)
				SetLog("Try using custom train for train troops.", $COLOR_ERROR)
				DoCheckReVamp(True)
			EndIf
		Else
			SetLog("Cannot open quick train tab page.",$COLOR_ERROR)
		EndIf
	Else
		SetLog("Cannot open train troops tab page.",$COLOR_ERROR)
	EndIf
EndFunc

Func CheckNeedSwipe($TrainTroop)
	; check need swipe
	Local $iSwipeNum = 15
;~ 	If $isIceWizardAvailable = 1 Then $iSwipeNum = 13
	If $TrainTroop > $iSwipeNum Then
		If _ColorCheck(_GetPixelColor(22, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10) Then
;~ 			If $isIceWizardAvailable = 1 Then
;~ 				ClickDrag(712,476,218,476,250)
;~ 				If _sleep(500) Then Return
;~ 			Else
				ClickDrag(617,476,418,476,250)
				If _sleep(500) Then Return
;~ 			EndIf
		EndIf
	Else
		If _ColorCheck(_GetPixelColor(22, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10) = False Then
;~ 			If $isIceWizardAvailable = 1 Then
;~ 				ClickDrag(136,476,636,476,250)
;~ 				If _sleep(500) Then Return
;~ 			Else
				ClickDrag(436,476,636,476,250)
				If _sleep(500) Then Return
;~ 			EndIf
		EndIf
	EndIf
EndFunc

Func getTroopCost($trooptype)
;~ 	If $isIceWizardAvailable <> 1 Then ; Check if santa spell variable is not set YET
;~ 		ForceCaptureRegion()
;~ 		Local $_IsIceWizardPixel[4] = [357, 513, 0xD0AF98, 20]
;~ 		Local $rPixelCheck = _CheckPixel($_IsIceWizardPixel, True)

;~ 		If $rPixelCheck = True Then
;~ 			$isIceWizardAvailable = 1
;~ 		Else
;~ 			$isIceWizardAvailable = 0
;~ 		EndIf
;~ 	EndIf
	Local $iResult = 0
;~ 	If $isIceWizardAvailable = 1 Then
;~ 	Switch $trooptype
;~ 		Case "Heal"
;~ 			$iResult = getMyOcr(424,450,60,16,"troopcost",True)
;~ 		Case "Drag"
;~ 			$iResult = getMyOcr(424,552,60,16,"troopcost",True)
;~ 		Case "Pekk"
;~ 			$iResult = getMyOcr(522,450,60,16,"troopcost",True)
;~ 		Case "BabyD"
;~ 			$iResult = getMyOcr(522,552,60,16,"troopcost",True)
;~ 		Case "Mine"
;~ 			$iResult = getMyOcr(620,450,60,16,"troopcost",True)

;~ 		Case "Mini"
;~ 			$iResult = getMyOcr(725,450,60,16,"troopcost",True)
;~ 		Case "Hogs"
;~ 			$iResult = getMyOcr(725,552,60,16,"troopcost",True)

;~ 		Case "Valk"
;~ 			$iResult = getMyOcr(548,450,60,16,"troopcost",True)
;~ 		Case "Gole"
;~ 			$iResult = getMyOcr(548,552,60,16,"troopcost",True)


;~ 		Case "Barb"
;~ 			$iResult = getMyOcr(30,450,60,16,"troopcost",True)
;~ 		Case "Arch"
;~ 			$iResult = getMyOcr(30,552,60,16,"troopcost",True)
;~ 		Case "Giant"
;~ 			$iResult = getMyOcr(128,450,60,16,"troopcost",True)
;~ 		Case "Gobl"
;~ 			$iResult = getMyOcr(128,552,60,16,"troopcost",True)
;~ 		Case "Wall"
;~ 			$iResult = getMyOcr(226,450,60,16,"troopcost",True)
;~ 		Case "Ball"
;~ 			$iResult = getMyOcr(226,552,60,16,"troopcost",True)

;~ 		Case "Wiza"
;~ 			$iResult = getMyOcr(325,450,60,16,"troopcost",True)

;~ 		Case "Witc"
;~ 			$iResult = getMyOcr(648,450,60,16,"troopcost",True)
;~ 		Case "Lava"
;~ 			$iResult = getMyOcr(648,552,60,16,"troopcost",True)
;~ 		Case "Bowl"
;~ 			$iResult = getMyOcr(747,450,60,16,"troopcost",True)

;~ 	EndSwitch

;~ 	Else
	Switch $trooptype
		Case "Barb"
			$iResult = getMyOcr(35,450,60,16,"troopcost",True)
		Case "Arch"
			$iResult = getMyOcr(35,552,60,16,"troopcost",True)
		Case "Giant"
			$iResult = getMyOcr(134,450,60,16,"troopcost",True)
		Case "Gobl"
			$iResult = getMyOcr(134,552,60,16,"troopcost",True)
		Case "Wall"
			$iResult = getMyOcr(233,450,60,16,"troopcost",True)
		Case "Ball"
			$iResult = getMyOcr(233,552,60,16,"troopcost",True)
		Case "Wiza"
			$iResult = getMyOcr(332,450,60,16,"troopcost",True)
		Case "Heal"
			$iResult = getMyOcr(332,552,60,16,"troopcost",True)
		Case "Drag"
			$iResult = getMyOcr(431,450,60,16,"troopcost",True)
		Case "Pekk"
			$iResult = getMyOcr(431,552,60,16,"troopcost",True)
		Case "BabyD"
			$iResult = getMyOcr(530,450,60,16,"troopcost",True)
		Case "Mine"
			$iResult = getMyOcr(530,552,60,16,"troopcost",True)

		Case "Mini"
			$iResult = getMyOcr(632,450,60,16,"troopcost",True)
		Case "Hogs"
			$iResult = getMyOcr(632,552,60,16,"troopcost",True)
		Case "Valk"
			$iResult = getMyOcr(731,450,60,16,"troopcost",True)
		Case "Gole"
			$iResult = getMyOcr(731,552,60,16,"troopcost",True)
		Case "Witc"
			$iResult = getMyOcr(648,450,60,16,"troopcost",True)
		Case "Lava"
			$iResult = getMyOcr(648,552,60,16,"troopcost",True)
		Case "Bowl"
			$iResult = getMyOcr(747,450,60,16,"troopcost",True)

	EndSwitch
;~ 	EndIf
	If $g_iDebugSetlogTrain = 1 Then SetLog("$iResult: " & $iResult)
	If $iResult = "" Then $iResult = 0
	Return $iResult
EndFunc

Func getSpellCost($trooptype)
;~ 	If $isSantaSpellAvailable <> 1 Then ; Check if santa spell variable is not set YET
;~ 		ForceCaptureRegion()
;~ 		Local $_IsSantaSpellPixel[4] = [65, 540, 0x7C0427, 20]

;~ 		Local $rPixelCheck = _CheckPixel($_IsSantaSpellPixel, True)

;~ 		If $rPixelCheck = True Then
;~ 			$isSantaSpellAvailable = 1
;~ 		Else
;~ 			$isSantaSpellAvailable = 0
;~ 		EndIf
;~ 	EndIf

	Local $iResult = 0
;~ 	If $isSantaSpellAvailable = 1 Then
;~ 		Switch $trooptype
;~ 			Case "Lightning"
;~ 				$iResult = getMyOcr(35,450,60,16,"troopcost",True)
;~ 			Case "Heal"
;~ 				$iResult = getMyOcr(132,450,60,16,"troopcost",True)
;~ 			Case "Jump"
;~ 				$iResult = getMyOcr(230,450,60,16,"troopcost",True)

;~ 			Case "Clone"
;~ 				$iResult = getMyOcr(328,450,60,16,"troopcost",True)

;~ 			Case "Rage"
;~ 				$iResult = getMyOcr(132,550,60,16,"troopcost",True)
;~ 			Case "Freeze"
;~ 				$iResult = getMyOcr(230,550,60,16,"troopcost",True)

;~ 			Case "Poison"
;~ 				$iResult = getMyOcr(336+98,450,60,16,"troopcost",True)
;~ 			Case "Earth"
;~ 				$iResult = getMyOcr(336+98,550,60,16,"troopcost",True)
;~ 			Case "Haste"
;~ 				$iResult = getMyOcr(434+98,450,60,16,"troopcost",True)
;~ 			Case "Skeleton"
;~ 				$iResult = getMyOcr(434+98,550,60,16,"troopcost",True)
;~ 		EndSwitch
;~ 	Else
		Switch $trooptype
			Case "Lightning"
				$iResult = getMyOcr(35,450,60,16,"troopcost",True)
			Case "Rage"
				$iResult = getMyOcr(132,450,60,16,"troopcost",True)
			Case "Freeze"
				$iResult = getMyOcr(230,450,60,16,"troopcost",True)

			Case "Heal"
				$iResult = getMyOcr(35,550,60,16,"troopcost",True)
			Case "Jump"
				$iResult = getMyOcr(132,550,60,16,"troopcost",True)
			Case "Clone"
				$iResult = getMyOcr(230,550,60,16,"troopcost",True)

			Case "Poison"
				$iResult = getMyOcr(336,450,60,16,"troopcost",True)
			Case "Earth"
				$iResult = getMyOcr(336,550,60,16,"troopcost",True)
			Case "Haste"
				$iResult = getMyOcr(434,450,60,16,"troopcost",True)
			Case "Skeleton"
				$iResult = getMyOcr(434,550,60,16,"troopcost",True)
		EndSwitch
;~ 	EndIf
	If $g_iDebugSetlogTrain = 1 Then SetLog("$iResult: " & $iResult)
	If $iResult = "" Then $iResult = 0
	Return $iResult
EndFunc

Func getTrainArmyCapacity()
	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getTrainArmyCapacity:", $COLOR_DEBUG1)

	Local $aGetFactorySize
	Local $iCount
	Local $sArmyInfo = ""
	Local $CurBrewSFactory = 0
	Local $tempCurS = 0
	Local $tempCurT = 0

	; Verify spell current and total capacity
	If $g_iTotalSpellValue > 0 Then ; only use this code if the user had input spells to brew ... and assign the spells quantity
		$iCount = 0 ; reset OCR loop counter
		While $iCount < 20 ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid
			;$sArmyInfo = getArmyCampCap($aArmySpellSize[0], $aArmySpellSize[1]) ; OCR read Spells and total capacity
			; samm0d
			$sArmyInfo = getMyOcrTrainArmyOrBrewSpellCap() ; OCR read Spells and total capacity
			$aGetFactorySize = StringSplit($sArmyInfo, "#", $STR_NOCOUNT) ; split the existen Spells from the total Spell factory capacity
			If IsArray($aGetFactorySize) Then
				If UBound($aGetFactorySize) > 1 Then
					If $aGetFactorySize[0] <> "" And $aGetFactorySize[1] <> "" Then
						If $tempCurS = Number($aGetFactorySize[0]) And $tempCurT = Number($aGetFactorySize[1]) Then ExitLoop
						$tempCurS = Number($aGetFactorySize[0])
						$tempCurT = Number($aGetFactorySize[1])
					EndIf
				EndIf
			EndIf
			$iCount += 1
			If _Sleep(200) Then Return ""; Wait 200ms
		WEnd

		If $iCount >= 20 Then
			If $g_iDebugSetlogTrain = 1 Then Setlog("$sArmyInfo = " & $sArmyInfo, $COLOR_DEBUG)
			SetLog("Error reading ocr for train troops capacity, please check your setting or contact author.", $COLOR_ERROR)
			Return ""
		Else
			If $g_iDebugSetlogTrain = 1 Then Setlog("$sArmyInfo = " & $sArmyInfo, $COLOR_DEBUG)
			SetLog("Train Troops: " & $tempCurS & "/" & $tempCurT)
		EndIf
	EndIf

	If $g_iTotalCampSpace <> ($tempCurT / 2) Then ; if Total camp size is still not set or value not same as read use forced value
		If $g_bTotalCampForced = False Then ; check if forced camp size set in expert tab
		    Local $proposedTotalCamp = $tempCurT
			If $g_iTotalCampSpace > $tempCurT Then $proposedTotalCamp = $g_iTotalCampSpace
			Local $sInputbox = InputBox("Question", _
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


	Return $aGetFactorySize
EndFunc   ;==>getTrainArmyCapacity