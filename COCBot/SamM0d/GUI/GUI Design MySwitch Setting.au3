
$y += 5
;$grpMySwitch = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d",25, "Switch Google Account And Profile"), $x-5, $y, 438, 340)
$grpMySwitch = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d",25, "Switch Google Account And Profile"), $x-5, $y, 438, 340)


$chkEnableMySwitch = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 26, "Enable switch account"), $x, $y+20, 180, -1)
	GUICtrlSetFont (-1,9, 800)
	GUICtrlSetOnEvent(-1, "chkEnableAcc")
	GUICtrlSetState(-1,$GUI_DISABLE)

$chkProfileImage = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 41, "Do Check village and profile after load."), $x+195, $y+20, -1, -1)
	_GUICtrlSetTip(-1, "Check the village name at game profile page there, confirm the village load correctly.")
	GUICtrlSetOnEvent(-1, "chkEnableAcc")

;$lblActiveAcc = GUICtrlCreateLabel("Current Active Acc:", $x+200, $y+15, 220, 50,$SS_CENTER)

$y += 50
For $i = 0 To 7
	$chkEnableAcc[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 27 + $i, "Google Account slot " & $i + 1 & " with profile: "), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkEnableAcc")
	$cmbWithProfile[$i] = GUICtrlCreateCombo("", $x + 195, $y + 1, 120, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetOnEvent(-1, "chkEnableAcc")
	$cmbAtkDon[$i] = GUICtrlCreateCombo("", $x + 320, $y + 1, 60, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "Attack|Donate","Attack")
		GUICtrlSetOnEvent(-1, "chkEnableAcc")
	$cmbStayTime[$i] = GUICtrlCreateCombo("", $x + 385, $y + 1, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0|5|10|15","0")
		_GUICtrlSetTip(-1, "Setting for Stay how long (minutes) with this account.")
		GUICtrlSetOnEvent(-1, "chkEnableAcc")
	$y += 28
Next

$y += 10
$chkEnableContinueStay = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "ContinueStay", "Avoid switch, if troops getting ready within [Minute(s)]: "), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkEnableAcc")

$txtTrainTimeLeft = GUICtrlCreateInput("300", $x + 290, $y+2, 35, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "ContinueStayValue", "Please enter how many minute(s)"))
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "chkEnableAcc")

$y += 25
$chkForcePreTrainB4Switch = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "ForcePreTrainWhenSwitch", "Force pre-train troops for attack type account before switch."), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkEnableAcc")


GUICtrlCreateGroup("", -99, -99, 1, 1)

ReadEnableAcc()
ApplyEnableAcc()
