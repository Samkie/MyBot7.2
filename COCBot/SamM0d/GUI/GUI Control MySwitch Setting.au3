Func BuildProfileForSwitch()
	Local $sDataFromProfile
	$sDataFromProfile = _GUICtrlComboBox_GetList($g_hCmbProfile)
	For $i = 0 To 7
		GUICtrlSetData($cmbWithProfile[$i],"","")
		GUICtrlSetData($cmbWithProfile[$i], $sDataFromProfile, "")
	Next
	ApplyEnableAcc()
EndFunc

Func chkEnableAcc()
	SaveEnableAcc()
	ReadEnableAcc()
	ApplyEnableAcc()
EndFunc

Func SaveEnableAcc()
	For $i = 0 To 7
		If GUICtrlRead($chkEnableAcc[$i]) = $GUI_CHECKED Then
			IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableAcc" & $i + 1, 1)
		Else
			IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableAcc" & $i + 1, 0)
		EndIf
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "WithProfile" & $i + 1, GUICtrlRead($cmbWithProfile[$i]))
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "AtkDon" & $i + 1, _GUICtrlComboBox_GetCurSel($cmbAtkDon[$i]))
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "Stay" & $i + 1, GUICtrlRead($cmbStayTime[$i]))
	Next

	If GUICtrlRead($chkUseADBLoadVillage) = $GUI_CHECKED Then
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnablesPrefSwitch", 1)
	Else
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnablesPrefSwitch", 0)
	EndIf

	If GUICtrlRead($chkProfileImage) = $GUI_CHECKED Then
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "CheckVillage", 1)
	Else
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "CheckVillage", 0)
	EndIf

	If GUICtrlRead($chkEnableContinueStay) = $GUI_CHECKED Then
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableContinueStay", 1)
	Else
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableContinueStay", 0)
	EndIf

	IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "TrainTimeLeft", GUICtrlRead($txtTrainTimeLeft))

	If GUICtrlRead($chkForcePreTrainB4Switch) = $GUI_CHECKED Then
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "ForcePreTrainB4Switch", 1)
	Else
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "ForcePreTrainB4Switch", 0)
	EndIf

EndFunc

Func ReadEnableAcc()
	For $i = 0 To 7
		$ichkEnableAcc[$i] = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableAcc" & $i + 1, "0")
		$icmbWithProfile[$i] = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "WithProfile" & $i + 1, "0")
		$icmbAtkDon[$i] = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "AtkDon" & $i + 1, "0")
		$icmbStayTime[$i] = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "Stay" & $i + 1, "0")
	Next
	$ichkUseADBLoadVillage = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnablesPrefSwitch", "0")
	$ichkProfileImage = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "CheckVillage", "0")

	$ichkEnableContinueStay = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableContinueStay", "0")
	$itxtTrainTimeLeft = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "TrainTimeLeft", "5")
	$ichkForcePreTrainB4Switch = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "ForcePreTrainB4Switch", "0")
EndFunc

Func ApplyEnableAcc()
	For $i = 0 To 7
		If $ichkEnableAcc[$i] = 1 Then
			GUICtrlSetState($chkEnableAcc[$i], $GUI_CHECKED)
		Else
			GUICtrlSetState($chkEnableAcc[$i], $GUI_UNCHECKED)
		EndIf
		setCombolistByText($cmbWithProfile[$i],$icmbWithProfile[$i])
		setCombolistByText($cmbStayTime[$i],$icmbStayTime[$i])
		_GUICtrlComboBox_SetCurSel($cmbAtkDon[$i],$icmbAtkDon[$i])
	Next

	If $ichkUseADBLoadVillage = 1 Then
		GUICtrlSetState($chkUseADBLoadVillage, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkUseADBLoadVillage, $GUI_UNCHECKED)
	EndIf

	If $ichkProfileImage = 1 Then
		GUICtrlSetState($chkProfileImage, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkProfileImage, $GUI_UNCHECKED)
	EndIf

	If $ichkEnableContinueStay = 1 Then
		GUICtrlSetState($chkEnableContinueStay, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkEnableContinueStay, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($txtTrainTimeLeft, $itxtTrainTimeLeft)

	If $ichkForcePreTrainB4Switch = 1 Then
		GUICtrlSetState($chkForcePreTrainB4Switch, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkForcePreTrainB4Switch, $GUI_UNCHECKED)
	EndIf

	If $iSamM0dDebug Then SetLog("$ichkEnableMySwitch: " & $ichkEnableMySwitch)
	buildSwitchList()
	DoCheckSwitchEnable()
EndFunc

Func setCombolistByText(ByRef $iHandle, $sText)
	Local $aList = _GUICtrlComboBox_GetListArray($iHandle)
	For $i = 1 To $aList[0]
		If $aList[$i] = $sText Then
			_GUICtrlComboBox_SetCurSel($iHandle, $i - 1)
			ExitLoop
		EndIf
	Next
EndFunc


