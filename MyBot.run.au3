﻿; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot
; Description ...: This file contains the initialization and main loop sequences f0r the MBR Bot
; Author ........:  (2014)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; AutoIt pragmas
#RequireAdmin
#AutoIt3Wrapper_UseX64=7n
;#AutoIt3Wrapper_Res_HiDpi=Y ; HiDpi will be set during run-time!
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/rsln /MI=3
;/SV=0

;#AutoIt3Wrapper_Change2CUI=y
;#pragma compile(Console, true)
#pragma compile(Icon, "Images\MyBot.ico")
#pragma compile(FileDescription, Clash of Clans Bot - A Free Clash of Clans bot - https://mybot.run)
#pragma compile(ProductName, My Bot)
#pragma compile(ProductVersion, 7.2)
#pragma compile(FileVersion, 7.2)
#pragma compile(LegalCopyright, © https://mybot.run)
#pragma compile(Out, MyBot.run.exe) ; Required

; Enforce variable declarations
Opt("MustDeclareVars", 1)

Global $g_sBotVersion = "v7.2" ;~ Don't add more here, but below. Version can't be longer than vX.y.z because it is also use on Checkversion()
Global $g_sBotTitle = "" ;~ Don't assign any title here, use Func UpdateBotTitle()
Global $g_hFrmBot = 0 ; The main GUI window

; MBR includes
#include "COCBot\MBR Global Variables.au3"
#include "COCBot\functions\Config\DelayTimes.au3"
#include "COCBot\GUI\MBR GUI Design Splash.au3"
#include "COCBot\functions\Config\ScreenCoordinates.au3"
#include "COCBot\functions\Other\ExtMsgBox.au3"
#include "COCBot\functions\Other\MBRFunc.au3"
#include "COCBot\functions\Android\Android.au3"
#include "COCBot\functions\Android\Distributors.au3"
#include "COCBot\MBR GUI Design.au3"
#include "COCBot\MBR GUI Control.au3"
#include "COCBot\MBR Functions.au3"
#include "COCBot\functions\Other\Multilanguage.au3"
; MBR References.au3 must be last include
#include "COCBot\MBR References.au3"

; Autoit Options
Opt("GUIResizeMode", $GUI_DOCKALL) ; Default resize mode for dock android support
Opt("GUIEventOptions", 1) ; Handle minimize and restore for dock android support
Opt("GUICloseOnESC", 0) ; Don't send the $GUI_EVENT_CLOSE message when ESC is pressed.
Opt("WinTitleMatchMode", 3) ; Window Title exact match mode
Opt("GUIOnEventMode", 1)
Opt("MouseClickDelay", 10)
Opt("MouseClickDownDelay", 10)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)

; All executable code is in a function block, to detect coding errors, such as variable declaration scope problems
InitializeBot()

; Hand over control to main loop
MainLoop()

Func UpdateBotTitle()
	Local $sTitle = "My Bot " & $g_sBotVersion & " @Samkie M0d v0.7.9 "
	If $g_sBotTitle = "" Then
		$g_sBotTitle = $sTitle
	Else
		$g_sBotTitle = $sTitle & "(" & ($g_sAndroidInstance <> "" ? $g_sAndroidInstance : $g_sAndroidEmulator) & ")" ;Do not change this. If you do, multiple instances will not work.
	EndIf
	If $g_hFrmBot <> 0 Then
		; Update Bot Window Title also
		WinSetTitle($g_hFrmBot, "", $g_sBotTitle)
		GUICtrlSetData($g_hLblBotTitle, $g_sBotTitle)
	EndIf
	; Update Console Window (if it exists)
	DllCall("kernel32.dll", "bool", "SetConsoleTitle", "str", "Console " & $g_sBotTitle)
	; Update try icon title
	TraySetToolTip($g_sBotTitle)

	SetDebugLog("Bot title updated to: " & $g_sBotTitle)
EndFunc   ;==>UpdateBotTitle

Func InitializeBot()

	TraySetIcon($g_sLibIconPath, $eIcnGUI)

	ProcessCommandLine()

	SetupProfileFolder() ; Setup profile folders

	SetLogCentered(" BOT LOG ") ; Initial text for log

	; Debug Output of launch parameter
	SetDebugLog("@AutoItExe: " & @AutoItExe)
	SetDebugLog("@ScriptFullPath: " & @ScriptFullPath)
	SetDebugLog("@WorkingDir: " & @WorkingDir)
	SetDebugLog("@AutoItPID: " & @AutoItPID)
	SetDebugLog("@OSArch: " & @OSArch)
	SetDebugLog("@OSVersion: " & @OSVersion)
	SetDebugLog("@OSBuild: " & @OSBuild)
	SetDebugLog("@OSServicePack: " & @OSServicePack)
	SetDebugLog("Primary Display: " & @DesktopWidth & " x " & @DesktopHeight & " - " & @DesktopDepth & "bit")

	Local $sAndroidInfo = ""
	; Disabled process priority tampering as not best practice
	;Local $iBotProcessPriority = _ProcessGetPriority(@AutoItPID)
	;ProcessSetPriority(@AutoItPID, $PROCESS_BELOWNORMAL) ;~ Boost launch time by increasing process priority (will be restored again when finished launching)

	_Crypt_Startup()
	__GDIPlus_Startup() ; Start GDI+ Engine (incl. a new thread)

	; initialize bot title
	UpdateBotTitle()

	InitAndroidConfig()

	If FileExists(@ScriptDir & "\EnableMBRDebug.txt") Then  ; Set developer mode
		$g_bDevMode = True
		Local $aText = FileReadToArray(@ScriptDir & "\EnableMBRDebug.txt") ; check if special debug flags set inside EnableMBRDebug.txt file
		If Not @error  Then
			For $l = 0 To UBound($aText) - 1
				If StringInStr($aText[$l], "DISABLEWATCHDOG", $STR_NOCASESENSEBASIC) <> 0 Then
					$g_bBotLaunchOption_NoWatchdog = True
					SetDebugLog("Watch Dog disabled by Developer Mode File Command", $COLOR_INFO)
				EndIf
			Next
		EndIf
	EndIf

	; early load of config
	If FileExists($g_sProfileConfigPath) Or FileExists($g_sProfileBuildingPath) Then
		readConfig()
	EndIf

	CreateMainGUI() ; Just create the main window
	CreateSplashScreen() ; Create splash window

	; Ensure watchdog is launched (requires Bot Window for messaging)
	If $g_bBotLaunchOption_NoWatchdog = False Then LaunchWatchdog()

	InitializeMBR($sAndroidInfo)

	; Create GUI
	CreateMainGUIControls() ; Create all GUI Controls
	InitializeMainGUI() ; setup GUI Controls

	; Files/folders
	SetupFilesAndFolders()

	; Show main GUI
	ShowMainGUI()

	If $g_iBotLaunchOption_Dock Then
		If AndroidEmbed(True) And $g_iBotLaunchOption_Dock = 2 And $g_bCustomTitleBarActive Then
			BotShrinkExpandToggle()
		EndIf
	EndIf

	; Some final setup steps and checks
	FinalInitialization($sAndroidInfo)

	; samm0d - MySwitch
	$g_sEmulatorInfo4MySwitch = $sAndroidInfo
	;ProcessSetPriority(@AutoItPID, $iBotProcessPriority) ;~ Restore process priority

EndFunc   ;==>InitializeBot

; #FUNCTION# ====================================================================================================================
; Name ..........: ProcessCommandLine
; Description ...: Handle command line parameters
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ProcessCommandLine()

	; Handle Command Line Launch Options and fill $g_asCmdLine
	If $CmdLine[0] > 0 Then
		SetDebugLog("Full Command Line: " & _ArrayToString($CmdLine, " "))
		For $i = 1 To $CmdLine[0]
			Local $bOptionDetected = True
			Switch $CmdLine[$i]
				; terminate bot if it exists (by window title!)
				Case "/restart", "/r", "-restart", "-r"
					$g_bBotLaunchOption_Restart = True
				Case "/autostart", "/a", "-autostart", "-a"
					$g_bBotLaunchOption_Autostart = True
				Case "/nowatchdog", "/nwd", "-nowatchdog", "-nwd"
					$g_bBotLaunchOption_NoWatchdog = True
				Case "/dpiaware", "/da", "-dpiaware", "-da"
					$g_bBotLaunchOption_ForceDpiAware = True
				Case "/dock1", "/d1", "-dock1", "-d1", "/dock", "/d", "-dock", "-d"
					$g_iBotLaunchOption_Dock = 1
				Case "/dock2", "/d2", "-dock2", "-d2"
					$g_iBotLaunchOption_Dock = 2
				Case "/nobotslot", "/nbs", "-nobotslot", "-nbs"
					$g_bBotLaunchOption_NoBotSlot = True
				Case Else
					$bOptionDetected = False
					$g_asCmdLine[0] += 1
					ReDim $g_asCmdLine[$g_asCmdLine[0] + 1]
					$g_asCmdLine[$g_asCmdLine[0]] = $CmdLine[$i]
			EndSwitch
			If $bOptionDetected Then SetDebugLog("Command Line Option detected: " & $CmdLine[$i])
		Next
	EndIf

	; Handle Command Line Parameters
	If $g_asCmdLine[0] > 0 Then
		$g_sProfileCurrentName = StringRegExpReplace($g_asCmdLine[1], '[/:*?"<>|]', '_')
	ElseIf FileExists($g_sProfilePath & "\profile.ini") Then
		$g_sProfileCurrentName = StringRegExpReplace(IniRead($g_sProfilePath & "\profile.ini", "general", "defaultprofile", ""), '[/:*?"<>|]', '_')
		If $g_sProfileCurrentName = "" Or Not FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName) Then $g_sProfileCurrentName = "<No Profiles>"
	Else
		$g_sProfileCurrentName = "<No Profiles>"
	EndIf
EndFunc   ;==>ProcessCommandLine

; #FUNCTION# ====================================================================================================================
; Name ..........: InitializeAndroid
; Description ...: Initialize Android
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: cosote (Feb-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func InitializeAndroid()
	Local $s = GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_06", "Initializing Android...")
	SplashStep($s)

	If $g_bBotLaunchOption_Restart = False Then
		; initialize Android config
		InitAndroidConfig(True)

		; Change Android type and update variable
		If $g_asCmdLine[0] > 1 Then
			Local $i
			For $i = 0 To UBound($g_avAndroidAppConfig) - 1
				If StringCompare($g_avAndroidAppConfig[$i][0], $g_asCmdLine[2]) = 0 Then
					$g_iAndroidConfig = $i
					SplashStep($s & "(" & $g_avAndroidAppConfig[$i][0] & ")...", False)
					If $g_avAndroidAppConfig[$i][1] <> "" And $g_asCmdLine[0] > 2 Then
						; Use Instance Name
						UpdateAndroidConfig($g_asCmdLine[3])
					Else
						UpdateAndroidConfig()
					EndIf
					SplashStep($s & "(" & $g_avAndroidAppConfig[$i][0] & ")", False)
					ExitLoop
				EndIf
			Next
		EndIf

		SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_07", "Detecting Android..."))
		If $g_asCmdLine[0] < 2 Then
			DetectRunningAndroid()
			If Not $g_bFoundRunningAndroid Then DetectInstalledAndroid()
		EndIf

	Else

		; just increase step
		SplashStep($s)

	EndIf

	CleanSecureFiles()

	GetCOCDistributors() ; realy load of distributors to prevent rare bot freeze during boot

EndFunc   ;==>InitializeAndroid

; #FUNCTION# ====================================================================================================================
; Name ..........: SetupProfileFolder
; Description ...: Populate profile-related globals
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SetupProfileFolder()
	$g_sProfileConfigPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\config.ini"
	$g_sProfileBuildingStatsPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\stats_buildings.ini"
	$g_sProfileBuildingPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\building.ini"
	$g_sProfileLogsPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Logs\"
	$g_sProfileLootsPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Loots\"
	$g_sProfileTempPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Temp\"
	$g_sProfileTempDebugPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Temp\Debug\"
	$g_sProfileDonateCapturePath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\'
	$g_sProfileDonateCaptureWhitelistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\White List\'
	$g_sProfileDonateCaptureBlacklistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\Black List\'
EndFunc   ;==>SetupProfileFolder

; #FUNCTION# ====================================================================================================================
; Name ..........: InitializeMBR
; Description ...: MBR setup routine
; Syntax ........:
; Parameters ....: $sAI - populated with AndroidInfo string in this function
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func InitializeMBR(ByRef $sAI)

	; license
	If Not FileExists(@ScriptDir & "\License.txt") Then
		Local $hDownload = InetGet("http://www.gnu.org/licenses/gpl-3.0.txt", @ScriptDir & "\License.txt")

		; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
		Local $i = 0
		Do
			Sleep($DELAYDOWNLOADLICENSE)
			$i += 1
		Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE) Or $i > 25

		InetClose($hDownload)
	EndIf

	; multilanguage
	If Not FileExists(@ScriptDir & "\Languages") Then DirCreate(@ScriptDir & "\Languages")
	DetectLanguage()
	_ReadFullIni()
	; must be called after language is detected
	TranslateTroopNames()
	InitializeCOCDistributors()

	; check for compiled x64 version
	Local $sMsg = GetTranslatedFileIni("MBR GUI Design - Loading", "Compile_Script", "Don't Run/Compile the Script as (x64)! Try to Run/Compile the Script as (x86) to get the bot to work.\r\n" & _
			"If this message still appears, try to re-install AutoIt.")
	If @AutoItX64 = 1 Then
		DestroySplashScreen()
		MsgBox(0, "", $sMsg)
		__GDIPlus_Shutdown()
		Exit
	EndIf

	; Initialize Android emulator
	InitializeAndroid()

	; Update Bot title
	UpdateBotTitle()
	UpdateSplashTitle($g_sBotTitle & GetTranslatedFileIni("MBR GUI Design - Loading", "Loading_Profile", ", Profile: %s", $g_sProfileCurrentName))

	If $g_bBotLaunchOption_Restart = True Then
		If CloseRunningBot($g_sBotTitle, True) Then
			SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "Closing_previous", "Closing previous bot..."), False)
			If CloseRunningBot($g_sBotTitle) = True Then
				; wait for Mutexes to get disposed
				Sleep(3000)
				; check if Android is running
				WinGetAndroidHandle()
			EndIf
		EndIf
	EndIf

	Local $cmdLineHelp = GetTranslatedFileIni("MBR GUI Design - Loading", "Commandline_multiple_Bots", "By using the commandline (or a shortcut) you can start multiple Bots:\r\n" & _
			"     MyBot.run.exe [ProfileName] [EmulatorName] [InstanceName]\r\n\r\n" & _
			"With the first command line parameter, specify the Profilename (you can create profiles on the Bot/Profiles tab, if a " & _
			"profilename contains a {space}, then enclose the profilename in double quotes). " & _
			"With the second, specify the name of the Emulator and with the third, an Android Instance (not for BlueStacks). \r\n" & _
			"Supported Emulators are MEmu, Droid4X, Nox, BlueStacks2, BlueStacks, KOPlayer and LeapDroid.\r\n\r\n" & _
			"Examples:\r\n" & _
			"     MyBot.run.exe MyVillage BlueStacks2\r\n" & _
			"     MyBot.run.exe ""My Second Village"" MEmu MEmu_1")

	$g_hMutex_BotTitle = CreateMutex($g_sBotTitle)
	$sAI = GetTranslatedFileIni("MBR GUI Design - Loading", "Android_instance_01", "%s", $g_sAndroidEmulator)
	Local $sAndroidInfo2 = GetTranslatedFileIni("MBR GUI Design - Loading", "Android_instance_02", "%s (instance %s)", $g_sAndroidEmulator, $g_sAndroidInstance)
	If $g_sAndroidInstance <> "" Then
		$sAI = $sAndroidInfo2
	EndIf

	; Check if we are already running for this instance
	$sMsg = GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_01", "My Bot for %s is already running.\r\n\r\n", $sAI)
	If $g_hMutex_BotTitle = 0 Then
		DestroySplashScreen()
		MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION, $MB_TOPMOST), $g_sBotTitle, $sMsg & $cmdLineHelp)
		__GDIPlus_Shutdown()
		Exit
	EndIf

	; Check if we are already running for this profile
	$g_hMutex_Profile = CreateMutex(StringReplace($g_sProfilePath & "\" & $g_sProfileCurrentName, "\", "-"))
	$sMsg = GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_02", "My Bot with Profile %s is already running in %s.\r\n\r\n", $g_sProfileCurrentName, $g_sProfilePath & "\" & $g_sProfileCurrentName)
	If $g_hMutex_Profile = 0 Then
		ReleaseMutex($g_hMutex_BotTitle)
		DestroySplashScreen()
		MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION, $MB_TOPMOST), $g_sBotTitle, $sMsg & $cmdLineHelp)
		__GDIPlus_Shutdown()
		Exit
	EndIf

	; Get mutex
	$g_hMutex_MyBot = CreateMutex("MyBot.run")
	$g_bOnlyInstance = $g_hMutex_MyBot <> 0 ; And False
	SetDebugLog("My Bot is " & ($g_bOnlyInstance ? "" : "not ") & "the only running instance")

EndFunc   ;==>InitializeMBR

; #FUNCTION# ====================================================================================================================
; Name ..........: SetupFilesAndFolders
; Description ...: Checks for presence of needed files and folders, cleans up and creates as required
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SetupFilesAndFolders()

	CheckPrerequisites(False)
	;DirCreate($sTemplates)
	DirCreate($g_sProfilePresetPath)
	DirCreate($g_sProfilePath & "\" & $g_sProfileCurrentName)
	DirCreate($g_sProfileLogsPath)
	DirCreate($g_sProfileLootsPath)
	DirCreate($g_sProfileTempPath)
	DirCreate($g_sProfileTempDebugPath)

	$g_sProfileDonateCapturePath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\'
	$g_sProfileDonateCaptureWhitelistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\White List\'
	$g_sProfileDonateCaptureBlacklistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\Black List\'
	DirCreate($g_sProfileDonateCapturePath)
	DirCreate($g_sProfileDonateCaptureWhitelistPath)
	DirCreate($g_sProfileDonateCaptureBlacklistPath)

	;Migrate old bot without profile support to current one
	FileMove(@ScriptDir & "\*.ini", $g_sProfilePath & "\" & $g_sProfileCurrentName, $FC_OVERWRITE + $FC_CREATEPATH)
	DirCopy(@ScriptDir & "\Logs", $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Logs", $FC_OVERWRITE + $FC_CREATEPATH)
	DirCopy(@ScriptDir & "\Loots", $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Loots", $FC_OVERWRITE + $FC_CREATEPATH)
	DirCopy(@ScriptDir & "\Temp", $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Temp", $FC_OVERWRITE + $FC_CREATEPATH)
	DirRemove(@ScriptDir & "\Logs", 1)
	DirRemove(@ScriptDir & "\Loots", 1)
	DirRemove(@ScriptDir & "\Temp", 1)

	;Setup profile if doesn't exist yet
	If FileExists($g_sProfileConfigPath) = 0 Then
		createProfile(True)
		applyConfig()
	EndIf

	If $g_bDeleteLogs Then DeleteFiles($g_sProfileLogsPath, "*.*", $g_iDeleteLogsDays, 0)
	If $g_bDeleteLoots Then DeleteFiles($g_sProfileLootsPath, "*.*", $g_iDeleteLootsDays, 0)
	If $g_bDeleteTemp Then
		DeleteFiles($g_sProfileTempPath, "*.*", $g_iDeleteTempDays, 0)
		DeleteFiles($g_sProfileTempDebugPath, "*.*", $g_iDeleteTempDays, 0, $FLTAR_RECUR)
	EndIf

	SetDebugLog("$g_sProfilePath = " & $g_sProfilePath)
	SetDebugLog("$g_sProfileCurrentName = " & $g_sProfileCurrentName)
	SetDebugLog("$g_sProfileLogsPath = " & $g_sProfileLogsPath)
EndFunc   ;==>SetupFilesAndFolders

; #FUNCTION# ====================================================================================================================
; Name ..........: FinalInitialization
; Description ...: Finalize various setup requirements
; Syntax ........:
; Parameters ....: $sAI: AndroidInfo for displaying in the log
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func FinalInitialization(Const $sAI)
	; check for VC2010, .NET software and MyBot Files and Folders
	If CheckPrerequisites(True) Then
		MBRFunc(True) ; start MyBot.run.dll, after this point .net is initialized and threads popup all the time
		setAndroidPID() ; set Android PID
	EndIf

	If $g_bFoundRunningAndroid Then
		SetLog(GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_03", "Found running %s %s", $g_sAndroidEmulator, $g_sAndroidVersion), $COLOR_SUCCESS)
	EndIf
	If $g_bFoundInstalledAndroid Then
		SetLog("Found installed " & $g_sAndroidEmulator & " " & $g_sAndroidVersion, $COLOR_SUCCESS)
	EndIf
	SetLog(GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_04", "Android Emulator Configuration: %s", $sAI), $COLOR_SUCCESS)

	; destroy splash screen here (so we witness the 100% ;)
	DestroySplashScreen()

	;AdlibRegister("PushBulletRemoteControl", $g_iPBRemoteControlInterval)
	;AdlibRegister("PushBulletDeleteOldPushes", $g_iPBDeleteOldPushesInterval)

	;CheckDisplay() ; verify display size and DPI (Dots Per Inch) setting (disabled now as scaled desktop is now supported)

	LoadAmountOfResourcesImages()

	; InitializeVariables();initialize variables used in extrawindows
	CheckVersion() ; check latest version on mybot.run site

	; Remember time in Milliseconds bot launched
	$g_iBotLaunchTime = __TimerDiff($g_hBotLaunchTime)
	SetDebugLog("Maximum of " & $g_iGlobalActiveBotsAllowed & " bots running at same time configured")
	SetDebugLog("MyBot.run launch time " & Round($g_iBotLaunchTime) & " ms.")

	If $g_bAndroidShieldEnabled = False Then
		SetLog(GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_05", "Android Shield not available for %s", @OSVersion), $COLOR_ACTION)
	EndIf

	DisableProcessWindowsGhosting()

	UpdateMainGUI()

EndFunc   ;==>FinalInitialization

; #FUNCTION# ====================================================================================================================
; Name ..........: MainLoop
; Description ...: Main application loop
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MainLoop()
	Local $iStartDelay = 0
	If $g_bAutoStart Or $g_bRestarted = True Then
		Local $iDelay = $g_iAutoStartDelay
		If $g_bRestarted = True Then $iDelay = 0
		$iStartDelay = $iDelay * 1000
		$g_iBotAction = $eBotStart
	EndIf

	; samm0d - auto minimize bot
	If $g_bChkAutoMinimizeBot Then
		If $g_bFlagMinimizeBot = False Then
			$g_bFlagMinimizeBot = True
			WinSetState($g_hFrmBot, "", @SW_MINIMIZE)
		EndIf
	EndIf

	While 1
		_Sleep($DELAYSLEEP, True, False)

		Switch $g_iBotAction
			Case $eBotStart
				BotStart($iStartDelay)
				$iStartDelay = 0 ; don't autostart delay in future
				If $g_iBotAction = $eBotStart Then $g_iBotAction = $eBotNoAction

				; test error handling when bot started and then stopped
				; force app crash for debugging/testing purposes
				;DllCallAddress("NONE", 0)
				; force au3 script error for debugging/testing purposes
				;Local $iTmp = $iStartDelay[0]

			Case $eBotStop
				BotStop()
				If $g_iBotAction = $eBotStop Then $g_iBotAction = $eBotNoAction
			Case $eBotSearchMode
				BotSearchMode()
				If $g_iBotAction = $eBotSearchMode Then $g_iBotAction = $eBotNoAction
			Case $eBotClose
				BotClose()
		EndSwitch

	WEnd
EndFunc   ;==>MainLoop

Func runBot() ;Bot that runs everything in order
	Local $iWaitTime

	; samm0d switch
	$iDoPerformAfterSwitch = False

	While 1
		; samm0d
		If $iSamM0dDebug And $g_bRestart Then SetLog("Continue loop with restart", $COLOR_DEBUG)
		If $ichkAutoDock = 1 Then
			If $g_bAndroidEmbedded = False Then
				btnEmbed()
			EndIf
		Else
			; samm0d - auto hide emulator
			If $g_bChkAutoHideEmulator Then
				If $g_bFlagHideEmulator = False Then
					If $g_bIsHidden = False Then
						btnHide()
						$g_bFlagHideEmulator = True
					EndIf
				EndIf
			EndIf
		EndIf

		;Check for debug wait command
		If FileExists(@ScriptDir & "\EnableMBRDebug.txt") Then
			While (FileReadLine(@ScriptDir & "\EnableMBRDebug.txt") = "wait")
				If _SleepStatus(15000) = True Then Return
			WEnd
		EndIf

		;Restart bot after these seconds
		If $b_iAutoRestartDelay > 0 And __TimerDiff($g_hBotLaunchTime) > $b_iAutoRestartDelay * 1000 Then
			If RestartBot(False) = True Then Return
		EndIf

		$g_bRestart = False
		$g_bfullArmy = False
		$bJustMakeDonate = False
		$FullCCTroops = False
		$bDonateAwayFlag = False
		$tempDisableBrewSpell = False
		$tempDisableTrain = False
		$bAvoidSwitch = False

		$g_iCommandStop = -1
		If _Sleep($DELAYRUNBOT1) Then Return
		checkMainScreen()
		If $g_bRestart = True Then ContinueLoop


		; samm0d switch
		If $ichkEnableMySwitch Then
			If $iSamM0dDebug Then SetLog("$bAvoidSwitch: " & $bAvoidSwitch)
;~ 			If $bAvoidSwitch = False Then
				$bUpdateStats = True
				If $g_bIsClientSyncError = False And $g_bIsSearchLimit = False And ($g_bQuickAttack = False) Then
					DoSwitchAcc()
					If $g_bRestart = True Then ContinueLoop
				EndIf
				$iDoPerformAfterSwitch = True
				If $g_iTownHallLevel = 0 Then BotDetectFirstTime()
;~ 			Else
;~ 				SetLog("Avoid switch, troops getting ready or soon.", $COLOR_INFO)
;~ 			EndIf
			; reset variable
;~ 			$bAvoidSwitch = False
		EndIf

		PrepareDonateCC()

		chkShieldStatus()
		If $g_bRestart = True Then ContinueLoop

		If $g_bQuicklyFirstStart = True Then
			$g_bQuicklyFirstStart = False
		Else
			$g_bQuickAttack = QuickAttack()
		EndIf

		If checkAndroidReboot() = True Then ContinueLoop
		If $g_bIsClientSyncError = False And $g_bIsSearchLimit = False And ($g_bQuickAttack = False) Then
			If BotCommand() Then btnStop()
			If _Sleep($DELAYRUNBOT2) Then Return
			checkMainScreen(False)
			If $g_bRestart = True Then ContinueLoop
			If _Sleep($DELAYRUNBOT3) Then Return
			VillageReport()
			If $g_bOutOfGold = True And (Number($g_aiCurrentLoot[$eLootGold]) >= Number($g_iTxtRestartGold)) Then ; check if enough gold to begin searching again
				$g_bOutOfGold = False ; reset out of gold flag
				Setlog("Switching back to normal after no gold to search ...", $COLOR_SUCCESS)
				ContinueLoop ; Restart bot loop to reset $g_iCommandStop & $g_bTrainEnabled + $g_bDonationEnabled via BotCommand()
			EndIf
			If $g_bOutOfElixir = True And (Number($g_aiCurrentLoot[$eLootElixir]) >= Number($g_iTxtRestartElixir)) And (Number($g_aiCurrentLoot[$eLootDarkElixir]) >= Number($g_iTxtRestartDark)) Then ; check if enough elixir to begin searching again
				$g_bOutOfElixir = False ; reset out of gold flag
				Setlog("Switching back to normal setting after no elixir to train ...", $COLOR_SUCCESS)
				ContinueLoop ; Restart bot loop to reset $g_iCommandStop & $g_bTrainEnabled + $g_bDonationEnabled via BotCommand()
			EndIf
			If _Sleep($DELAYRUNBOT5) Then Return
			checkMainScreen(False)
			If $g_bRestart = True Then ContinueLoop
			Local $aRndFuncList = ['Collect', 'CheckTombs', 'ReArm', 'CleanYard']
			While 1
				If $g_bRunState = False Then Return
				If $g_bRestart = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
				If UBound($aRndFuncList) > 1 Then
					Local $Index = Random(0, UBound($aRndFuncList), 1)
					If $Index > UBound($aRndFuncList) - 1 Then $Index = UBound($aRndFuncList) - 1
					_RunFunction($aRndFuncList[$Index])
					_ArrayDelete($aRndFuncList, $Index)
				Else
					_RunFunction($aRndFuncList[0])
					ExitLoop
				EndIf
				If $g_bRestart = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
			WEnd
			AddIdleTime()
			If $g_bRunState = False Then Return
			If $g_bRestart = True Then ContinueLoop
			If IsSearchAttackEnabled() Then ; if attack is disabled skip reporting, requesting, donating, training, and boosting
				;Local $aRndFuncList = ['ReplayShare', 'NotifyReport', 'DonateCC,Train', 'BoostBarracks', 'BoostSpellFactory', 'BoostKing', 'BoostQueen', 'BoostWarden', 'RequestCC']
				; samm0d - ignore request cc, since later when train army will be apply request cc.
				Local $aRndFuncList = ['ReplayShare', 'NotifyReport', 'DonateCC,Train', 'BoostBarracks', 'BoostSpellFactory', 'BoostKing', 'BoostQueen', 'BoostWarden']
				While 1
					If $g_bRunState = False Then Return
					If $g_bRestart = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
					If UBound($aRndFuncList) > 1 Then
						Local $Index = Random(0, UBound($aRndFuncList), 1)
						If $Index > UBound($aRndFuncList) - 1 Then $Index = UBound($aRndFuncList) - 1
						_RunFunction($aRndFuncList[$Index])
						_ArrayDelete($aRndFuncList, $Index)
					Else
						_RunFunction($aRndFuncList[0])
						ExitLoop
					EndIf
					If checkAndroidReboot() = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
				WEnd
				If $g_bRunState = False Then Return
				If $g_bRestart = True Then ContinueLoop
				If $g_iUnbrkMode >= 1 Then
					If Unbreakable() = True Then ContinueLoop
				EndIf
			EndIf
			Local $aRndFuncList = ['Laboratory', 'UpgradeHeroes', 'UpgradeBuilding']
			While 1
				If $g_bRunState = False Then Return
				If $g_bRestart = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
				If UBound($aRndFuncList) > 1 Then
					$Index = Random(0, UBound($aRndFuncList), 1)
					If $Index > UBound($aRndFuncList) - 1 Then $Index = UBound($aRndFuncList) - 1
					_RunFunction($aRndFuncList[$Index])
					_ArrayDelete($aRndFuncList, $Index)
				Else
					_RunFunction($aRndFuncList[0])
					ExitLoop
				EndIf
				If checkAndroidReboot() = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
			WEnd
			If $g_bRunState = False Then Return
			If $g_bRestart = True Then ContinueLoop
			If IsSearchAttackEnabled() Then ; If attack scheduled has attack disabled now, stop wall upgrades, and attack.
				$g_iNbrOfWallsUpped = 0
				UpgradeWall()
				If _Sleep($DELAYRUNBOT3) Then Return
				If $g_bRestart = True Then ContinueLoop
				Idle()
				;$g_bFullArmy1 = $g_bFullArmy
				If _Sleep($DELAYRUNBOT3) Then Return
				If $g_bRestart = True Then ContinueLoop

				If $g_iCommandStop <> 0 And $g_iCommandStop <> 3 Then
					AttackMain()
					$g_bSkipFirstZoomout = False
					If $g_bOutOfGold = True Then
						Setlog("Switching to Halt Attack, Stay Online/Collect mode ...", $COLOR_ERROR)
						$g_bFirstStart = True ; reset First time flag to ensure army balancing when returns to training
						ContinueLoop
					EndIf
					If _Sleep($DELAYRUNBOT1) Then Return
					If $g_bRestart = True Then ContinueLoop
				EndIf
			Else
				$iWaitTime = Random($DELAYWAITATTACK1, $DELAYWAITATTACK2)
				SetLog("Attacking Not Planned and Skipped, Waiting random " & StringFormat("%0.1f", $iWaitTime / 1000) & " Seconds", $COLOR_WARNING)
				If _SleepStatus($iWaitTime) Then Return False
			EndIf
		Else ;When error occours directly goes to attack
			If $g_bQuickAttack Then
				Setlog("Quick Restart... ", $COLOR_INFO)
			Else
				If $g_bIsSearchLimit = True Then
					SetLog("Restarted due search limit", $COLOR_INFO)
				Else
					SetLog("Restarted after Out of Sync Error: Attack Now", $COLOR_INFO)
				EndIf
			EndIf
			If _Sleep($DELAYRUNBOT3) Then Return
			;  OCR read current Village Trophies when OOS restart maybe due PB or else DropTrophy skips one attack cycle after OOS
			$g_aiCurrentLoot[$eLootTrophy] = Number(getTrophyMainScreen($aTrophies[0], $aTrophies[1]))
			If $g_iDebugSetlog = 1 Then SetLog("Runbot Trophy Count: " & $g_aiCurrentLoot[$eLootTrophy], $COLOR_DEBUG)
			AttackMain()
			$g_bSkipFirstZoomout = False
			If $g_bOutOfGold = True Then
				Setlog("Switching to Halt Attack, Stay Online/Collect mode ...", $COLOR_ERROR)
				$g_bFirstStart = True ; reset First time flag to ensure army balancing when returns to training
				$g_bIsClientSyncError = False ; reset fast restart flag to stop OOS mode and start collecting resources
				ContinueLoop
			EndIf
			If _Sleep($DELAYRUNBOT5) Then Return
			If $g_bRestart = True Then ContinueLoop
		EndIf
	WEnd
EndFunc   ;==>runBot

Func Idle() ;Sequence that runs until Full Army
	Static $iCollectCounter = 0 ; Collect counter, when reaches $g_iCollectAtCount, it will collect

	Local $TimeIdle = 0 ;In Seconds
	If $g_iDebugSetlog = 1 Then SetLog("Func Idle ", $COLOR_DEBUG)


	; samm0d - check make donate type account enter idle loop
	If $ichkEnableMySwitch Then
		If $iCurActiveAcc <> -1 Then
			For $i = 0 To UBound($aSwitchList) - 1
				If $aSwitchList[$i][4] = $iCurActiveAcc Then
					If $aSwitchList[$i][2] = 1 Then
						$g_bIsFullArmywithHeroesAndSpells = False
					EndIf
				EndIf
			Next
		EndIf
	EndIf

	While $g_bIsFullArmywithHeroesAndSpells = False

		checkAndroidReboot()

		;Execute Notify Pending Actions
		NotifyPendingActions()
		If _Sleep($DELAYIDLE1) Then Return
		If $g_iCommandStop = -1 Then SetLog("====== Waiting for full army ======", $COLOR_SUCCESS)
		Local $hTimer = __TimerInit()

		;PrepareDonateCC()

		;If $g_bDonateSkipNearFullEnable = True Then getArmyCapacity(true,true)

		If $g_iActiveDonate And $g_bChkDonate Then
			Local $iReHere = 0
			; samm0d
			Local $iReHereMax = 7
			If $ichkCheck4CC = 1 Then $iReHereMax = $itxtCheck4CCWaitTime

			Local $aHeroResult
			If $g_bDonateSkipNearFullEnable Then
				$aHeroResult = CheckArmyCamp(True, True, True, False)
			EndIf

			While $iReHere < $iReHereMax
				$iReHere += 1
				If $iReHere = 1 And SkipDonateNearFullTroops(True, $aHeroResult) = False And BalanceDonRec(True) Then
					DonateCC(True)
				ElseIf SkipDonateNearFullTroops(False, $aHeroResult) = False And BalanceDonRec(False) Then
					DonateCC(True)
				EndIf
				If _Sleep($DELAYIDLE2) Then ExitLoop
				If $g_bRestart = True Then ExitLoop
				If checkAndroidReboot() Then ContinueLoop 2
			WEnd
		EndIf

		If _Sleep($DELAYIDLE1) Then ExitLoop
		checkObstacles() ; trap common error messages also check for reconnecting animation
		checkMainScreen(False) ; required here due to many possible exits

		; samm0d
		If $ichkCustomTrain = 0 Then
			If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And $g_bTrainEnabled = True Then
				CheckArmyCamp(True, True)
				If _Sleep($DELAYIDLE1) Then Return
				If ($g_bFullArmy = False Or $g_bFullArmySpells = False) Then
					SetLog("Army Camp and Barracks are not full, Training Continues...", $COLOR_ACTION)
					$g_iCommandStop = 0
				EndIf
			EndIf
		EndIf

;~ 		If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And $g_bTrainEnabled = True Then
;~ 			CheckArmyCamp(True, True)
;~ 			If _Sleep($DELAYIDLE1) Then Return
;~ 			If ($g_bFullArmy = False Or $g_bFullArmySpells = False) Then
;~ 				SetLog("Army Camp and Barracks are not full, Training Continues...", $COLOR_ACTION)
;~ 				$g_iCommandStop = 0
;~ 			EndIf
;~ 		EndIf

		ReplayShare($g_bShareAttackEnableNow)
		If _Sleep($DELAYIDLE1) Then Return
		If $g_bRestart = True Then ExitLoop
		If $iCollectCounter > $g_iCollectAtCount Then ; This is prevent from collecting all the time which isn't needed anyway
			Local $aRndFuncList = ['Collect', 'CheckTombs', 'DonateCC', 'CleanYard']
			While 1
				If $g_bRunState = False Then Return
				If $g_bRestart = True Then ExitLoop
				If checkAndroidReboot() Then ContinueLoop 2
				If UBound($aRndFuncList) > 1 Then
					Local $Index = Random(0, UBound($aRndFuncList), 1)
					If $Index > UBound($aRndFuncList) - 1 Then $Index = UBound($aRndFuncList) - 1
					_RunFunction($aRndFuncList[$Index])
					_ArrayDelete($aRndFuncList, $Index)
				Else
					_RunFunction($aRndFuncList[0])
					ExitLoop
				EndIf
			WEnd
			If $g_bRunState = False Then Return
			If $g_bRestart = True Then ExitLoop
			If _Sleep($DELAYIDLE1) Or $g_bRunState = False Then ExitLoop
			$iCollectCounter = 0
		EndIf
		$iCollectCounter = $iCollectCounter + 1
		AddIdleTime()
		checkMainScreen(False) ; required here due to many possible exits

		If $ichkCustomTrain = 0 Then
			If $g_iCommandStop = -1 Then
				If $g_iActualTrainSkip < $g_iMaxTrainSkip Then
					If CheckNeedOpenTrain($g_sTimeBeforeTrain) Then TrainRevamp()
					If $g_bRestart = True Then ExitLoop
					If _Sleep($DELAYIDLE1) Then ExitLoop
					checkMainScreen(False)
				Else
					Setlog("Humanize bot, prevent to delete and recreate troops " & $g_iActualTrainSkip + 1 & "/" & $g_iMaxTrainSkip, $color_blue)
					$g_iActualTrainSkip = $g_iActualTrainSkip + 1
					If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
						$g_iActualTrainSkip = 0
					EndIf
					CheckArmyCamp(True, True)
				EndIf
			EndIf
			If _Sleep($DELAYIDLE1) Then Return
			If $g_iCommandStop = 0 And $g_bTrainEnabled = True Then
				If Not ($g_bFullArmy) Then
					If $g_iActualTrainSkip < $g_iMaxTrainSkip Then
						If CheckNeedOpenTrain($g_sTimeBeforeTrain) Then TrainRevamp()
						If $g_bRestart = True Then ExitLoop
						If _Sleep($DELAYIDLE1) Then ExitLoop
						checkMainScreen(False)
					Else
						$g_iActualTrainSkip = $g_iActualTrainSkip + 1
						If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
							$g_iActualTrainSkip = 0
						EndIf
						CheckArmyCamp(True, True)
					EndIf
				EndIf
				If $g_bFullArmy And $g_bTrainEnabled = True Then
					SetLog("Army Camp and Barracks are full, stop Training...", $COLOR_ACTION)
					$g_iCommandStop = 3
				EndIf
			EndIf
		Else
			CustomTrain()
			If $g_bRestart = True Then ExitLoop
			If _Sleep(200) Then ExitLoop
			checkMainScreen(False)
		EndIf

		If _Sleep($DELAYIDLE1) Then Return
		If $g_iCommandStop = -1 Then
			DropTrophy()
			If $g_bRestart = True Then ExitLoop
			;If $g_bFullArmy Then ExitLoop		; Never will reach to SmartWait4Train() to close coc while Heroes/Spells not ready 'if' Army is full, so better to be commented
			If _Sleep($DELAYIDLE1) Then ExitLoop
			checkMainScreen(False)
		EndIf
		If _Sleep($DELAYIDLE1) Then Return
		If $g_bRestart = True Then ExitLoop
		$TimeIdle += Round(__TimerDiff($hTimer) / 1000, 2) ;In Seconds

		If $g_bCanRequestCC = True Then RequestCC()

		SetLog("Time Idle: " & StringFormat("%02i", Floor(Floor($TimeIdle / 60) / 60)) & ":" & StringFormat("%02i", Floor(Mod(Floor($TimeIdle / 60), 60))) & ":" & StringFormat("%02i", Floor(Mod($TimeIdle, 60))))

		If $g_bOutOfGold = True Or $g_bOutOfElixir = True Then Return ; Halt mode due low resources, only 1 idle loop
		If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And $g_bTrainEnabled = False Then ExitLoop ; If training is not enabled, run only 1 idle loop

		If $g_iCommandStop = -1 Then ; Check if closing bot/emulator while training and not in halt mode
			SmartWait4Train()
			If $g_bRestart = True Then ExitLoop ; if smart wait activated, exit to runbot in case user adjusted GUI or left emulator/bot in bad state
		EndIf
		; samm0d
		If $ichkEnableMySwitch Then
			; perform switch acc since army still need waiting
			If $g_bIsFullArmywithHeroesAndSpells = False Then
				If $ichkEnableContinueStay = 1 Then
					If $bAvoidSwitch = False Then
						$g_bRestart = True
						ExitLoop
					Else
						SetLog("Avoid switch, troops getting ready or soon.", $COLOR_INFO)
					EndIf
				Else
					$g_bRestart = True
					ExitLoop
				EndIf
			Else
				; if donate type acc, perform switch account too
				If $iCurActiveAcc <> -1 Then
					For $i = 0 To UBound($aSwitchList) - 1
						If $aSwitchList[$i][4] = $iCurActiveAcc Then
							If $aSwitchList[$i][2] = 1 Then
								If $ichkEnableContinueStay = 1 Then
									$bAvoidSwitch = False
								EndIf
								$g_bRestart = True
							EndIf
							ExitLoop
						EndIf
					Next
				EndIf
			EndIf
		EndIf
	WEnd
EndFunc   ;==>Idle

Func AttackMain() ;Main control for attack functions
	;LoadAmountOfResourcesImages() ; for debug
	; samm0d
	;getArmyCapacity(True, True)

	If IsSearchAttackEnabled() Then
		If (IsSearchModeActive($DB) And checkCollectors(True, False)) Or IsSearchModeActive($LB) Or IsSearchModeActive($TS) Then
			If $g_bUseCCBalanced = True Then ;launch profilereport() only if option balance D/R it's activated
				ProfileReport()
				If _Sleep($DELAYATTACKMAIN1) Then Return
				checkMainScreen(False)
				If $g_bRestart = True Then Return
			EndIf
			If $g_bDropTrophyEnable And Number($g_aiCurrentLoot[$eLootTrophy]) > Number($g_iDropTrophyMax) Then ;If current trophy above max trophy, try drop first
				DropTrophy()
				$g_bIsClientSyncError = False ; reset OOS flag to prevent looping.
				If _Sleep($DELAYATTACKMAIN1) Then Return
				Return ; return to runbot, refill armycamps
			EndIf
			If $g_iDebugSetlog = 1 Then
				SetLog(_PadStringCenter(" Hero status check" & BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $g_iHeroAvailable) & "|" & $g_aiSearchHeroWaitEnable[$DB] & "|" & $g_iHeroAvailable, 54, "="), $COLOR_DEBUG)
				SetLog(_PadStringCenter(" Hero status check" & BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $g_iHeroAvailable) & "|" & $g_aiSearchHeroWaitEnable[$LB] & "|" & $g_iHeroAvailable, 54, "="), $COLOR_DEBUG)
				;Setlog("BullyMode: " & $g_abAttackTypeEnable[$TB] & ", Bully Hero: " & BitAND($g_aiAttackUseHeroes[$g_iAtkTBMode], $g_aiSearchHeroWaitEnable[$g_iAtkTBMode], $g_iHeroAvailable) & "|" & $g_aiSearchHeroWaitEnable[$g_iAtkTBMode] & "|" & $g_iHeroAvailable, $COLOR_DEBUG)
			EndIf
			PrepareSearch()
			If $g_bOutOfGold = True Then Return ; Check flag for enough gold to search
			If $g_bRestart = True Then Return
			VillageSearch()
			If $g_bOutOfGold = True Then Return ; Check flag for enough gold to search
			If $g_bRestart = True Then Return
			PrepareAttack($g_iMatchMode)
			If $g_bRestart = True Then Return
			Attack()
			If $g_bRestart = True Then Return
			ReturnHome($g_bTakeLootSnapShot)
			If _Sleep($DELAYATTACKMAIN2) Then Return
			Return True
		Else
			Setlog("No one of search condition match:", $COLOR_WARNING)
			Setlog("Waiting on troops, heroes and/or spells according to search settings", $COLOR_WARNING)
			$g_bIsSearchLimit = False
			$g_bIsClientSyncError = False
			$g_bQuickAttack = False
		EndIf
	Else
		SetLog("Attacking Not Planned, Skipped..", $COLOR_WARNING)
	EndIf
EndFunc   ;==>AttackMain

Func Attack() ;Selects which algorithm
	$g_bAttackActive = True
	SetLog(" ====== Start Attack ====== ", $COLOR_SUCCESS)
	If ($g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 1) Or ($g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 1) Then
		If $g_iDebugSetlog = 1 Then Setlog("start scripted attack", $COLOR_ERROR)
		Algorithm_AttackCSV()
	ElseIf $g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 2 Then
		If $g_iDebugSetlog = 1 Then Setlog("start milking attack", $COLOR_ERROR)
		Alogrithm_MilkingAttack()
	Else
		If $g_iDebugSetlog = 1 Then Setlog("start standard attack", $COLOR_ERROR)
		algorithm_AllTroops()
	EndIf
	$g_bAttackActive = False
EndFunc   ;==>Attack


Func QuickAttack()

	Local $quicklymilking = 0
	Local $quicklythsnipe = 0

	; samm0d - for prevent keep open army overview window when i not using below setting
	Local $bFlag4IfNeedQuickAttack = ($g_bDropTrophyEnable = True Or $g_aiAttackAlgorithm[$DB] = 2 Or $g_abAttackTypeEnable[$TS] = True) ; only following enable then i open army window for check getArmyCapacity()
	If $bFlag4IfNeedQuickAttack Then

	getArmyCapacity(True, True)

	If ($g_aiAttackAlgorithm[$DB] = 2 And IsSearchModeActive($DB)) Or (IsSearchModeActive($TS)) Then
		VillageReport()
	EndIf

	$g_aiCurrentLoot[$eLootTrophy] = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
	If ($g_bDropTrophyEnable And Number($g_aiCurrentLoot[$eLootTrophy]) > Number($g_iDropTrophyMax)) Then
		If $g_iDebugSetlog = 1 Then Setlog("No quickly re-attack, need to drop tropies", $COLOR_DEBUG)
		Return False ;need to drop tropies
	EndIf

	If $g_aiAttackAlgorithm[$DB] = 2 And IsSearchModeActive($DB) Then
		If Int($g_CurrentCampUtilization) >= $g_iTotalCampSpace * $g_aiSearchCampsPct[$DB] / 100 And $g_abSearchCampsEnable[$DB] Then
			If $g_iDebugSetlog = 1 Then Setlog("Milking: Quickly re-attack " & Int($g_CurrentCampUtilization) & " >= " & $g_iTotalCampSpace & " * " & $g_aiSearchCampsPct[$DB] & "/100 " & "= " & $g_iTotalCampSpace * $g_aiSearchCampsPct[$DB] / 100, $COLOR_DEBUG)
			Return True ;milking attack OK!
		Else
			If $g_iDebugSetlog = 1 Then Setlog("Milking: No Quickly re-attack:  cur. " & Int($g_CurrentCampUtilization) & "  need " & $g_iTotalCampSpace * $g_aiSearchCampsPct[$DB] / 100 & " firststart = " & ($g_bQuicklyFirstStart), $COLOR_DEBUG)
			Return False ;milking attack no restart.. no enough army
		EndIf
	EndIf

	If IsSearchModeActive($TS) Then
		If Int($g_CurrentCampUtilization) >= $g_iTotalCampSpace * $g_aiSearchCampsPct[$TS] / 100 And $g_abSearchCampsEnable[$TS] Then
			If $g_iDebugSetlog = 1 Then Setlog("THSnipe: Quickly re-attack " & Int($g_CurrentCampUtilization) & " >= " & $g_iTotalCampSpace & " * " & $g_aiSearchCampsPct[$TS] & "/100 " & "= " & $g_iTotalCampSpace * $g_aiSearchCampsPct[$TS] / 100, $COLOR_DEBUG)
			Return True ;ts snipe attack OK!
		Else
			If $g_iDebugSetlog = 1 Then Setlog("THSnipe: No Quickly re-attack:  cur. " & Int($g_CurrentCampUtilization) & "  need " & $g_iTotalCampSpace * $g_aiSearchCampsPct[$TS] / 100 & " firststart = " & ($g_bQuicklyFirstStart), $COLOR_DEBUG)
			Return False ;ts snipe no restart... no enough army
		EndIf
	EndIf
	EndIf
EndFunc   ;==>QuickAttack

Func _RunFunction($action)
	SetDebugLog("_RunFunction: " & $action & " BEGIN", $COLOR_DEBUG2)
	Switch $action
		Case "Collect"
			Collect()
			_Sleep($DELAYRUNBOT1)
		Case "CheckTombs"
			CheckTombs()
			_Sleep($DELAYRUNBOT3)
		Case "CleanYard"
			CleanYard()
		Case "ReArm"
			ReArm()
			_Sleep($DELAYRUNBOT3)
		Case "ReplayShare"
			ReplayShare($g_bShareAttackEnableNow)
			_Sleep($DELAYRUNBOT3)
		Case "NotifyReport"
			NotifyReport()
			_Sleep($DELAYRUNBOT3)
		Case "DonateCC"
			If $g_iActiveDonate And $g_bChkDonate Then
				;If $g_bDonateSkipNearFullEnable = True and $g_bFirstStart = False Then getArmyCapacity(True, True)
				If SkipDonateNearFullTroops(True) = False And BalanceDonRec(True) Then DonateCC()
				If _Sleep($DELAYRUNBOT1) = False Then checkMainScreen(False)
			EndIf
		Case "DonateCC,Train"
			; samm0d
			If $ichkCustomTrain = 1 Then
				CustomTrain()
			Else
				TrainRevamp()
			EndIf

			If $g_iActiveDonate And $g_bChkDonate Then
				If $g_bFirstStart Then
					getArmyCapacity(True, False)
					getArmySpellCapacity(False, True)
				EndIf
				If SkipDonateNearFullTroops(True) = False And BalanceDonRec(True) Then DonateCC()
			EndIf
			If _Sleep($DELAYRUNBOT1) = False Then checkMainScreen(False)

			If $ichkCustomTrain = 1 Then
				If $bJustMakeDonate Then
					$bJustMakeDonate = False
					CustomTrain()
				EndIf
			Else
				If $g_bTrainEnabled Then ; check for training enabled in halt mode
					If $g_iActualTrainSkip < $g_iMaxTrainSkip Then
						;Train()
						TrainRevamp()
						_Sleep($DELAYRUNBOT1)
					Else
						Setlog("Humanize bot, prevent to delete and recreate troops " & $g_iActualTrainSkip + 1 & "/" & $g_iMaxTrainSkip, $color_blue)
						$g_iActualTrainSkip = $g_iActualTrainSkip + 1
						If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
							$g_iActualTrainSkip = 0
						EndIf
						CheckOverviewFullArmy(True, False) ; use true parameter to open train overview window
						If ISArmyWindow(False, $ArmyTAB) Then CheckExistentArmy("Spells") ; Imgloc Method
						getArmyHeroCount(False, True)
					EndIf
				Else
					If $g_iDebugSetlogTrain = 1 Then Setlog("Halt mode - training disabled", $COLOR_DEBUG)
				EndIf
			EndIf

		Case "BoostBarracks"
			BoostBarracks()
		Case "BoostSpellFactory"
			BoostSpellFactory()
		Case "BoostKing"
			BoostKing()
		Case "BoostQueen"
			BoostQueen()
		Case "BoostWarden"
			BoostWarden()
		Case "RequestCC"
			RequestCC()
			If _Sleep($DELAYRUNBOT1) = False Then checkMainScreen(False)
		Case "Laboratory"
			Laboratory()
			If _Sleep($DELAYRUNBOT3) = False Then checkMainScreen(False)
		Case "UpgradeHeroes"
			UpgradeHeroes()
			_Sleep($DELAYRUNBOT3)
		Case "UpgradeBuilding"
			UpgradeBuilding()
			_Sleep($DELAYRUNBOT3)
		Case ""
			SetDebugLog("Function call doesn't support empty string, please review array size", $COLOR_ERROR)
		Case Else
			SetLog("Unknown function call: " & $action, $COLOR_ERROR)
	EndSwitch
	SetDebugLog("_RunFunction: " & $action & " END", $COLOR_DEBUG2)
EndFunc   ;==>_RunFunction
