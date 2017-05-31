
; #FUNCTION# ====================================================================================================================
; Name ..........: MyTrainClick
; Description ...: Clicks in troop training window
; Syntax ........: MyTrainClick($TroopButton, $iTimes, $iSpeed, $sdebugtxt="")
; Parameters ....: $TroopButton         - base on HLFClick button type
;                  $iTimes              - Number fo times to cliok
;                  $iSpeed              - Wait time after click
;				   $sdebugtxt		    - String with click debug text
; Return values .: None
; Author ........: Samkie (23 Feb 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MyTrainClick($TroopButton, $iTimes, $iSpeed, $sdebugtxt="")
	If IsTrainPage() Then
		If $g_iDebugClick = 1 Then
			Local $txt = _DecodeDebug($sdebugtxt)
			Local $x = $TroopButton[0]
			Local $y = $TroopButton[1]
			SetLog("MyTrainClick " & $x & "," & $y & "," & $iTimes & "," & $iSpeed & " " & $sdebugtxt & $txt, $COLOR_ORANGE, "Verdana", "7.5", 0)
		EndIf
		Local $aButtonClick[4]= [$TroopButton[0],$TroopButton[1],$TroopButton[2],$TroopButton[3]]
		Local $aColorCheck[4] = [$TroopButton[4],$TroopButton[5],$TroopButton[6],$TroopButton[7]]

		Local $iRandNum = Random($iHLFClickMin-1,$iHLFClickMax-1,1) ;Initialize value (delay awhile after $iRandNum times click)
		Local $iRandX = Random($TroopButton[0],$TroopButton[2],1)
		Local $iRandY = Random($TroopButton[1],$TroopButton[3],1)
		If isProblemAffect(True) Then Return
		If _CheckPixel($aColorCheck, True) = True Then ; Check to see if out of Elixir
			For $i = 0 To ($iTimes - 1)
				If $ichkEnableHLFClick = 1 Then
					HMLPureClick(Random($iRandX-2,$iRandX+2,1), Random($iRandY-2,$iRandY+2,1))
					If $i >= $iRandNum Then
						$iRandNum = $iRandNum + Random($iHLFClickMin,$iHLFClickMax,1)
						$iRandX = Random($TroopButton[0],$TroopButton[2],1)
						$iRandY = Random($TroopButton[1],$TroopButton[3],1)
						If _Sleep(Random(($isldHLFClickDelayTime*90)/100, ($isldHLFClickDelayTime*110)/100, 1), False) Then ExitLoop
					Else
						If _Sleep(Random(($iSpeed*90)/100, ($iSpeed*110)/100, 1), False) Then ExitLoop
					EndIf
				Else
					If $g_bUseRandomClick = False then
						PureClickP($aButtonClick)
					Else
						PureClick($iRandX, $iRandY)
					EndIf
					If _Sleep($iSpeed, False) Then ExitLoop
				EndIf
			Next
		Else
			SetLog("Cannot find button " & $TroopButton[8] ,$COLOR_ERROR)
		EndIf
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>MyTrainClick