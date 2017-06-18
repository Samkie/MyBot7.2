; #FUNCTION# ====================================================================================================================
; Name ..........: getMyOcr(BETA) 0.5
; Description ...: Reading characters using ImgLoc
; Syntax ........: getMyOcr($x,$y,$width,$height,$bReturnAsNumber,$OCRType,$bFlagDecode)
; Parameters ....: $x     					-
;                  $y    					-
;                  $width    				-
;                  $height    				-
;                  $OCRType    				- folder that store the character images.
;                  $bReturnAsNumber         - return as number
;                  $bFlagDecode             - is that need decode from config.ini
;				   $bFlagMulti	            - when use more than 1 image for determine one character.
; Return values .: String Or Number base on character images found.
; Author ........: Samkie (17 JUN 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getMyOcr($x,$y,$width,$height,$OCRType,$bReturnAsNumber = False,$bFlagDecode = False,$bFlagMulti = False)
	If $MyOcrDebug = 1 Then SetLog("========getMyOcr========", $COLOR_DEBUG)

	Local $aLastResult[1][4] ; col stored objectname, coorx, coory, level(width of the image)
	Local $sDirectory = ""
	Local $returnProps="objectname,objectpoints,objectlevel"
	Local $aCoor
	Local $aPropsValues
	Local $aCoorXY
	Local $result
	Local $sReturn = ""
	Local $iCount = 0
	Local $iMax = 0
	Local $jMax = 0
	Local $i, $j

	Local $tempOCRType = StringLower($OCRType)

	$sDirectory = @ScriptDir & "\COCBot\SamM0d\functions\OCR\" & $tempOCRType

	ForceCaptureRegion()
	_CaptureRegion2(Int($x),Int($y),int($x+$width),Int($y+$height))

	$result = findMultiple($sDirectory ,"FV" ,"FV", 0, 0, 0 , $returnProps, False)

	If IsArray($result) then
		$iMax = UBound($result) -1
		For $i = 0 To $iMax
			$aPropsValues = $result[$i] ; should be return objectname,objectpoints,objectlevel
			If UBound($aPropsValues) = 3 then
				If $MyOcrDebug = 1 Then SetLog("$aPropsValues[0]: " & $aPropsValues[0], $COLOR_DEBUG)
				If $MyOcrDebug = 1 Then SetLog("$aPropsValues[1]: " & $aPropsValues[1], $COLOR_DEBUG)
				If $MyOcrDebug = 1 Then SetLog("$aPropsValues[2]: " & $aPropsValues[2], $COLOR_DEBUG)
				$aCoor = StringSplit($aPropsValues[1],"|",$STR_NOCOUNT) ; objectpoints, split by "|" to get multi coor x,y ; same image maybe can detect at different location.
				$jMax = UBound($aCoor) - 1
				For $j = 0 To $jMax  ; process every different location of image if found
					ReDim $aLastResult[$iCount + 1][4]
					If $bFlagDecode Then
						$aLastResult[$iCount][0] = TansCode($sDirectory,$OCRType,$aPropsValues[0])
					Else
						$aLastResult[$iCount][0] = StringReplace($aPropsValues[0],$tempOCRType,"",$STR_NOCASESENSE)

						If $bFlagMulti Then
							Local $asResult = StringRegExp($aLastResult[$iCount][0], '[0-9]', 1)
							If @error == 0 Then
								$aLastResult[$iCount][0] = $asResult[0]
							EndIf
						EndIf
					EndIf
					If $MyOcrDebug = 1 Then SetLog("objectname: " & $aLastResult[$iCount][0], $COLOR_DEBUG)
					$aCoorXY = StringSplit($aCoor[$j],",",$STR_NOCOUNT) ; objectpoints, split by "," to get coor x,y
					If IsArray($aCoorXY) Then
						$aLastResult[$iCount][1] = Number($aCoorXY[0]) - (Number($aPropsValues[2] / 2))  ; get the imagelocation base on coor X
						$aLastResult[$iCount][2] = Number($aCoorXY[1]) ; get the imagelocation base on coor Y
					EndIf
					$aLastResult[$iCount][3] = Number($aPropsValues[2]) ; get image pixel width
					If $MyOcrDebug = 1 Then SetLog("$aLastResult: obj-" & $aLastResult[$iCount][0] & " width-" & $aLastResult[$iCount][3] & " coor-"& $aLastResult[$iCount][1] & "," & $aLastResult[$iCount][2], $COLOR_DEBUG)
					$iCount += 1
				Next
			EndIf
		Next
		_ArraySort($aLastResult, 0, 0, 0, 1) ; rearrange order by coor X
		If $MyOcrDebug = 1 Then
			For $i = 0 To UBound($aLastResult) - 1
				SetLog("Afrer _ArraySort - Obj:" & $aLastResult[$i][0] & " Coor:" & $aLastResult[$i][1] & "," & $aLastResult[$i][2] & " Width:" & $aLastResult[$i][3], $COLOR_DEBUG)
			Next
		EndIf
		$iMax = UBound($aLastResult) - 1
		For $i = 0 To $iMax
			For $j = $i + 1 To $iMax
				If $aLastResult[$i][0] <> "" Then
					If $MyOcrDebug = 1 Then SetLog("$i: " & $i & " - Check If CurX + Width: " & $aLastResult[$i][1] + $aLastResult[$i][3])
					If $MyOcrDebug = 1 Then SetLog("$j: " & $j & " - Larger than Next ImageX: " & $aLastResult[$j][1])
					If ($aLastResult[$i][1] + $aLastResult[$i][3]) > $aLastResult[$j][1] Then
						; compare with width who the boss
						If $aLastResult[$i][3] > $aLastResult[$j][3] Then
							If $MyOcrDebug = 1 Then SetLog("Remove $j: " & $j & " - " & $aLastResult[$j][0])
							$aLastResult[$j][0] = ""
						Else
							If $MyOcrDebug = 1 Then SetLog("Remove $i: " & $i & " - " & $aLastResult[$i][0])
							$aLastResult[$i][0] = ""
							ExitLoop
						EndIf
					EndIf
				EndIf
			Next
			$sReturn = $sReturn & $aLastResult[$i][0]
		Next
	EndIf
	If $MyOcrDebug = 1 Then SetLog("$sReturn: " & $sReturn, $COLOR_DEBUG)
	If $bReturnAsNumber Then
		If $sReturn = "" Then $sReturn = "0"
		Return Number($sReturn)
	Else
		Return $sReturn
	EndIf
EndFunc ;==>getMyOcr

Func TansCode($sDirectory,$OCRType,$Msg)
	Dim $result
	$result = IniRead($sDirectory & "\config.ini", StringLower($OCRType), $Msg, "")
	If $result = "" Then
		IniWrite($sDirectory & "\config.ini", StringLower($OCRType), $Msg, "")
	EndIf
	Return $result
EndFunc

Func getMyOcrArmyCap()
	; troops capacity from army overview page, top left
	Local $sResult = getMyOcr(109,136 + $g_iMidOffsetY,90,15,"armycap")
	Return $sResult
EndFunc

Func getMyOcrSpellCap()
	; spells capacity from army overview page, center left
	Local $sResult = getMyOcr(98,283 + $g_iMidOffsetY,90,15,"armycap")
	Return $sResult
EndFunc

Func getMyOcrCCCap()
	; clan castle capacity from army overview page, bottom left
	Local $sResult = getMyOcr(300,439 + $g_iMidOffsetY,70,15,"armycap")
	Return $sResult
EndFunc

Func getMyOcrCCSpellCap()
	; clan castle capacity from army overview page, bottom right
	Local $sResult = getMyOcr(528,438 + $g_iMidOffsetY,40,15,"armycap")
	Return $sResult
EndFunc

Func getMyOcrTrainArmyOrBrewSpellCap()
	; Troops/Spells capacity at army train page or brew spell page, top left
	Local $sResult = getMyOcr(45,131 + $g_iMidOffsetY,87,173,"armybuildinfo")
	Return $sResult
EndFunc

Func getMyOcrCurDEFromTrain()
	; current dark elixir from train troops page or brew spell page, bottom center
	Local $sResult = getMyOcr(400,566 + $g_iMidOffsetY,84,15,"spellqtybrew",True)
	Return $sResult
EndFunc

Func getMyOcrCurElixirFromTrain()
	; current gold from train troops page or brew spell page, bottom center
	If _ColorCheck(_GetPixelColor(217,600,True), Hex(0XE8E8E0, 6), 10) Then ; If True mean the current village don't had dark elixir yet
		Return getMyOcr(304,566 + $g_iMidOffsetY,102,15,"spellqtybrew",True)
	Else
		Return getMyOcr(230,566 + $g_iMidOffsetY,102,15,"spellqtybrew",True)
	EndIf
EndFunc