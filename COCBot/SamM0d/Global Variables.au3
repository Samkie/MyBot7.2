; #FUNCTION# ====================================================================================================================
; Name ..........: Global Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........: Samkie (30, May 2017)
; Modified ......: Everyone all the time  :)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_hTabMod

;===============SamM0d Global Variables====================
;============================================================
Global $iSamM0dDebug = 0
Global $MyOcrDebug = 0
Global $chkDebugMyOcr, $chkDebugSamM0d
Global $g_sLeague, $g_iLeagueNo
Global $bIDoScanMineAndElixir = False
Global $bUpdateStats = False
Global $ichkAutoDock = 1
Global $bJustMakeDonate = False
Global $ichkDropCCFirst = 0

;Global $TopLeftOri[5][2] = [[75, 306], [154, 246], [233, 186], [312, 126], [391, 66]]
;Global $TopRightOri[5][2] = [[460, 70], [538, 129], [617, 189], [695, 248], [774, 308]]
;Global $BottomLeftOri[5][2] = [[80, 394], [148, 446], [217, 497], [286, 549], [354, 600]]
;Global $BottomRightOri[5][2] = [[515, 610], [589, 554], [663, 497], [737, 443], [811, 384]]


; auto hide emulator, minimize bot after start
Global $chkAutoHideEmulator, $chkAutoMinimizeBot
Global $g_bChkAutoHideEmulator = False
;Global $g_bFlagHideEmulator = False
Global $g_bChkAutoMinimizeBot = False
Global $g_bFlagMinimizeBot = False


; unit wave factor
Global $ichkUnitFactor
Global $itxtUnitFactor
Global $ichkWaveFactor
Global $itxtWaveFactor
Global $chkUnitFactor, $txtUnitFactor, $chkWaveFactor, $txtWaveFactor

; global delay increse
Global $ichkIncreaseGlobalDelay = 0
Global $itxtIncreaseGlobalDelay = 10

; stick to train page
Global $itxtStickToTrainWindow = 2

; Wait For CC
Global $ichkWait4CC = False
Global $CurCCCamp = 0
Global $CurTotalCCCamp = 0
Global $CCCapacity = 0
Global $CCStrength = 100
Global $FullCCTroops = False

Global $chkDropCCFirst

; check for cc
Global $ichkCheck4CC = 0
Global $itxtCheck4CCWaitTime = 7

; My custom train, custom spell
Global $chkCustomTrain, $lblMyQuickTrain, $cmbMyQuickTrain, $grpOtherTroops, $chkMyTroopsOrder, $cmbTroopSetting, $btnResetTroops, $btnResetOrder, $lblTotalCapacityOfMyTroops, $idProgressbar, _
$chkDisablePretrainTroops, $chkEnableDeleteExcessTroops, $lblStickToTrainWindow, $txtStickToTrainWindow
Global $grpSpells,$lblTotalSpell,$txtTotalCountSpell2

Global $lblLightningIcon,$lblHealIcon,$lblRageIcon,$lblJumpSpellIcon,$lblFreezeIcon,$lblCloneIcon,$lblPoisonIcon,$lblEarthquakeIcon,$lblHasteIcon,$lblSkeletonIcon
Global $lblLightningSpell,$lblHealSpell,$lblRageSpell,$lblJumpSpell,$lblFreezeSpell,$lblCloneSpell,$lblPoisonSpell,$lblEarthquakeSpell,$lblHasteSpell,$lblSkeletonSpell
Global $txtNumLightningSpell,$txtNumHealSpell,$txtNumRageSpell,$txtNumJumpSpell,$txtNumFreezeSpell,$txtNumCloneSpell,$txtNumPoisonSpell,$txtNumEarthSpell,$txtNumHasteSpell,$txtNumSkeletonSpell
Global $lblTimesLightS, $lblTimesHealS,$lblTimesRageS,$lblTimesJumpS,$lblFreezeS,$lblCloneS,$lblTimesPoisonS,$lblTimesEarthquakeS,$lblTimesHasteS,$lblTimesSkeletonS

Global $ichkCustomTrain = 0

Global $COLOR_HMLClick_LOG =0x004040
Global $COLOR_ELIXIR = 0xDE1AC0
Global $COLOR_DARKELIXIR = 0x301D38
;Global $icmbCoCVersion = 0
Global $bTempDisAddIdleTime = False ;disable add train idle when train finish soon
Global $TroopsUnitSize[19] = [1,1,5,1,2,5,4,14,20,25,10,5,2,5,8,30,12,30,6]
Global $ichkMyTroopsOrder = 0
Global $ichkDisablePretrainTroops = 0
Global $ichkEnableDeleteExcessTroops = 0
Global $bRestartCustomTrain = False
Global $icmbTroopSetting = 0
Global $icmbMyQuickTrain = 0
Global $txtMyBarb, $txtMyArch, $txtMyGiant, $txtMyGobl, $txtMyWall, $txtMyBall, $txtMyWiza, $txtMyHeal, $txtMyDrag, $txtMyPekk, $txtMyBabyD, $txtMyMine, _
$txtMyMini, $txtMyHogs, $txtMyValk, $txtMyGole, $txtMyWitc, $txtMy, $txtMyLava, $txtMyBowl
Global $cmbMyBarbOrder, $cmbMyArchOrder, $cmbMyGiantOrder, $cmbMyGoblOrder, $cmbMyWallOrder, $cmbMyBallOrder, $cmbMyWizaOrder, $cmbMyHealOrder, $cmbMyDragOrder, $cmbMyPekkOrder, $cmbMyBabyDOrder, $cmbMyMineOrder, _
$cmbMyMiniOrder, $cmbMyHogsOrder, $cmbMyValkOrder, $cmbMyGoleOrder, $cmbMyWitcOrder, $cmbMyOrder, $cmbMyLavaOrder, $cmbMyBowlOrder

Global $CurBarb = 0, $CurArch = 0, $CurGiant = 0, $CurGobl = 0, $CurWall = 0, $CurBall = 0, $CurWiza = 0, $CurHeal = 0
Global $CurMini = 0, $CurHogs = 0, $CurValk = 0, $CurGole = 0, $CurWitc = 0, $CurLava = 0, $CurBowl = 0, $CurDrag = 0, $CurPekk = 0, $CurBabyD = 0, $CurMine = 0

Global $MyTroopsSetting[3][19][2]=[[[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],[[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],[[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]]
Global $MySpellSetting[3][10][2] = [[[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],[[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],[[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]]

Global $MyTroopsIcon[19] = [$eIcnBarbarian, $eIcnArcher, $eIcnGiant, $eIcnGoblin, $eIcnWallBreaker, $eIcnBalloon, $eIcnWizard, $eIcnHealer, $eIcnDragon, $eIcnPekka, $eIcnBabyDragon, $eIcnMiner,$eIcnMinion, $eIcnHogRider, $eIcnValkyrie, $eIcnGolem, $eIcnWitch, $eIcnLavaHound, $eIcnBowler]
Global $MyTroops[19][5] = _
[["Barb",  1,  1, 0,0], _
["Arch"	,  2,  1, 0,0], _
["Giant",  3,  5, 0,0], _
["Gobl"	,  4,  1, 0,0], _
["Wall"	,  5,  2, 0,0], _
["Ball"	,  6,  5, 0,0], _
["Wiza"	,  7,  4, 0,0], _
["Heal"	,  8, 14, 0,0], _
["Drag"	,  9, 20, 0,0], _
["Pekk"	, 10, 25, 0,0], _
["BabyD", 11, 10, 0,0], _
["Mine"	, 12,  5, 0,0], _
["Mini"	, 13,  2, 0,0], _
["Hogs"	, 14,  5, 0,0], _
["Valk"	, 15,  8, 0,0], _
["Gole"	, 16, 30, 0,0], _
["Witc"	, 17, 12, 0,0], _
["Lava"	, 18, 30, 0,0], _
["Bowl"	, 19,  6, 0,0]]
;name,order,size,unit quantity,train cost


;~ Global $sTxtBarbarians = GetTranslated(604,1, "Barbarians")
;~ Global $sTxtArchers = GetTranslated(604,2, "Archers")
;~ Global $sTxtGiants = GetTranslated(604,3, "Giants")
;~ Global $sTxtGoblins = GetTranslated(604,4, "Goblins")
;~ Global $sTxtWallBreakers = GetTranslated(604,5, "Wall Breakers")
;~ Global $sTxtBalloons = GetTranslated(604,7, "Balloons")
;~ Global $sTxtWizards = GetTranslated(604,8, "Wizards")
;~ Global $sTxtHealers = GetTranslated(604,9, "Healers")
;~ Global $sTxtDragons = GetTranslated(604,10, "Dragons")
;~ Global $sTxtPekkas = GetTranslated(604,11, "Pekkas")
;~ Global $sTxtMinions = GetTranslated(604,13, "Minions")
;~ Global $sTxtHogRiders = GetTranslated(604,14, "Hog Riders")
;~ Global $sTxtValkyries = GetTranslated(604,15, "Valkyries")
;~ Global $sTxtGolems = GetTranslated(604,16, "Golems")
;~ Global $sTxtWitches = GetTranslated(604,17, "Witches")
;~ Global $sTxtLavaHounds = GetTranslated(604,18, "Lava Hounds")
;~ Global $sTxtBowlers = GetTranslated(604, 19, "Bowlers")
;~ Global $sTxtBabyDragons = GetTranslated(604,20, "Baby Dragons")
;~ Global $sTxtMiners = GetTranslated(604,21, "Miners")

Global $MyTroopsCost[19][9] = _
[[250,25,40,60,100,150,200,250,250], _
[500,50,80,120,200,300,400,500,500], _
[4000,250,750,1250,1750,2250,3000,3500,4000], _
[200,25,40,60,80,100,150,200,200], _
[3500,1000,1500,2000,2500,3000,3500,3500,3500], _
[5000,2000,2500,3000,3500,4000,4500,5000,5000], _
[4500,1500,2000,2500,3000,3500,4000,4500,4500], _
[10000,5000,6000,8000,10000,10000,10000,10000,10000], _
[47000,25000,29000,33000,37000,42000,47000,47000,47000], _
[45000,28000,32000,36000,40000,45000,45000,45000,45000], _
[19000,15000,16000,17000,18000,19000,19000,19000,19000], _
[6000,4200,4800,5400,6000,6000,6000,6000,6000], _
[12,6,7,8,9,10,11,12,12], _
[90,40,45,52,58,65,90,90,90], _
[190,70,100,130,160,190,190,190,190], _
[750,450,550,600,675,750,750,750,750], _
[450,250,350,450,450,450,450,450,450], _
[570,390,450,510,570,570,570,570,570], _
[170,130,150,170,170,170,170,170,170]]

Global Enum $enumLightning, $enumHeal, $enumRage, $enumJump, $enumFreeze, $enumClone, $enumPoison, $enumEarth, $enumHaste, $enumSkeleton

Global $iLightningSpellComp = 0, $iHealSpellComp = 0, $iRageSpellComp = 0, $iJumpSpellComp = 0, $iFreezeSpellComp = 0,$iCloneSpellComp = 0, $iPoisonSpellComp = 0, $iEarthSpellComp = 0, $iHasteSpellComp = 0, $iSkeletonSpellComp = 0
Global $CurLightningSpell = 0, $CurHealSpell = 0, $CurRageSpell = 0, $CurJumpSpell = 0, $CurFreezeSpell = 0, $CurCloneSpell = 0, $CurPoisonSpell = 0, $CurHasteSpell = 0, $CurEarthSpell = 0, $CurSkeletonSpell = 0
Global $chkPreLightning, $chkPreHeal, $chkPreRage, $chkPreJump, $chkPreFreeze, $chkPreClone, $chkPrePoison, $chkPreEarth, $chkPreHaste, $chkPreSkeleton

Global $MySpells[10][5] = _
[["Lightning",  1,  2, 0, 0], _
["Heal"	     ,  2,  2, 0, 0], _
["Rage"      ,  3,  2, 0, 0], _
["Jump"	     ,  4,  2, 0, 0], _
["Freeze"	 ,  5,  2, 0, 0], _
["Clone"	 ,  6,  4, 0, 0], _
["Poison"	 ,  7,  1, 0, 0], _
["Earth"	 ,  8,  1, 0, 0], _
["Haste"	 ,  9,  1, 0, 0], _
["Skeleton"	 , 10,  1, 0, 0]]


Global $MySpellsCost[10][8] = _
[[26000,15000,16500,18000,20000,22000,24000,26000], _
[24000,15000,16500,18000,20000,22000,24000,24000], _
[33000,23000,25000,27000,30000,33000,33000,33000], _
[31000,23000,27000,31000,31000,31000,31000,31000], _
[35000,26000,29000,31000,33000,35000,35000,35000], _
[44000,38000,40000,42000,44000,44000,44000,44000], _
[140,95,110,125,140,140,140,140], _
[180,125,140,160,180,180,180,180], _
[95,80,85,90,95,95,95,95], _
[140,110,120,130,140,140,140,140]]

Global $preLightning = 0
Global $preRage = 0
Global $preJump = 0
Global $preHeal = 0
Global $preFreeze = 0
Global $preClone = 0
Global $prePoison = 0
Global $preHaste = 0
Global $preSkeleton = 0
Global $preEarth = 0

Global $preLightningSlot = 0
Global $preRageSlot = 0
Global $preJumpSlot = 0
Global $preHealSlot = 0
Global $preFreezeSlot = 0
Global $preCloneSlot = 0
Global $prePoisonSlot = 0
Global $preHasteSlot = 0
Global $preSkeletonSlot = 0
Global $preEarthSlot = 0

Global $OnBrewLightning = 0
Global $OnBrewRage = 0
Global $OnBrewJump = 0
Global $OnBrewHeal = 0
Global $OnBrewFreeze = 0
Global $OnBrewClone = 0
Global $OnBrewPoison = 0
Global $OnBrewHaste = 0
Global $OnBrewSkeleton = 0
Global $OnBrewEarth = 0

Global $OnBrewLightningSlot = 0
Global $OnBrewRageSlot = 0
Global $OnBrewJumpSlot = 0
Global $OnBrewHealSlot = 0
Global $OnBrewFreezeSlot = 0
Global $OnBrewCloneSlot = 0
Global $OnBrewPoisonSlot = 0
Global $OnBrewHasteSlot = 0
Global $OnBrewSkeletonSlot = 0
Global $OnBrewEarthSlot = 0

Global $ichkPreLightning = 0
Global $ichkPreRage = 0
Global $ichkPreJump = 0
Global $ichkPreHeal = 0
Global $ichkPreFreeze = 0
Global $ichkPreClone = 0
Global $ichkPrePoison = 0
Global $ichkPreHaste = 0
Global $ichkPreSkeleton = 0
Global $ichkPreEarth = 0

Global $tempDisableBrewSpell = False
Global $tempDisableTrain = False
Global $iMyTotalTrainSpaceSpell = 0

; Multi Finger Attack Style Setting
Global Enum $directionLeft, $directionRight
Global Enum $sideBottomRight, $sideTopLeft, $sideBottomLeft, $sideTopRight
Global Enum $mfRandom, $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight, $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight

Global $iMultiFingerStyle = 0

Global Enum  $eCCSpell = $eSkSpell + 1
Global $lblDBMultiFinger, $cmbDBMultiFinger

; SmartZap GUI variables from ChaCalGyn (LunaEclipse) - DEMEN
Global $ichkSmartZapDB = 1
Global $ichkSmartZapSaveHeroes = 1
Global $ichkSmartZapRnd = 1
Global $itxtMinDE = 400
; SmartZap stats from ChaCalGyn (LunaEclipse) - DEMEN
;Global $smartZapGain = 0
;Global $numLSpellsUsed = 0
; SmartZap Array to hold Total Amount of DE available from Drill at each level (1-6) from ChaCalGyn (LunaEclipse) - DEMEN
;Global Const $drillLevelHold[6] = [120,225,405,630,960,1350]
; SmartZap Array to hold Amount of DE available to steal from Drills at each level (1-6) from ChaCalGyn (LunaEclipse) - DEMEN
;Global Const $drillLevelSteal[6] = [59,102,172,251,343,479]

;samm0d zap
Global $ichkUseSamM0dZap = 1
Global $ichkDrillExistBeforeZap = 1
Global $itxtMinDEGetFromDrill = 120
Global $numLSpellDrop = 0
Global $debugZapSetLog = 0
Global $ichkPreventTripleZap = 1
Global $grpSmartZap, $chkUseSamM0dZap, $lblMinDark2, $txtMinDark2, $chkSmartZapDB2, $chkSmartZapSaveHeroes2, $chkSmartZapRnd, $chkDrillExistBeforeZap, $chkPreventTripleZap, $lblMinDEGetFromDrill, $txtMinDEGetFromDrill, _
$lblMySmartZap, $lblMyLightningUsed, $chkSmartZapDB, $chkSmartZapSaveHeroes, $txtMinDark

; samm0d chinese request
Global $ichkEnableCustomOCR4CCRequest = 0

; Check Collectors Outside - Added by TheRevenor
#region Check Collectors Outside
; collectors outside filter
Global $ichkDBMeetCollOutside, $iDBMinCollOutsidePercent = 80, $iCollOutsidePercent ; check later if $iCollOutsidePercent obsolete
; constants
Global Const $THEllipseWidth = 200, $THEllipseHeigth = 150, $CollectorsEllipseWidth = 130, $CollectorsEllipseHeigth = 97.5
Global Const $centerX = 430, $centerY = 335 ; check later if $THEllipseWidth, $THEllipseHeigth obsolete
Global $hBitmapFirst
;samm0d
Global $ichkSkipCollectorCheckIF = 1
Global $itxtSkipCollectorGold = 400000
Global $itxtSkipCollectorElixir = 400000
Global $itxtSkipCollectorDark = 0
Global $ichkSkipCollectorCheckIFTHLevel = 1
Global $itxtIFTHLevel = 7
Global $ichkDBCollectorsNearRedline = 0
Global $icmbRedlineTiles = 1
Global $chkDBMeetCollOutside, $txtDBMinCollOutsidePercent, $chkDBCollectorsNearRedline, $cmbRedlineTiles, $chkSkipCollectorCheckIF, $lblSkipCollectorGold, $txtSkipCollectorGold, $lblSkipCollectorElixir, _
$txtSkipCollectorElixir, $lblSkipCollectorDark, $txtSkipCollectorDark, $chkSkipCollectorCheckIFTHLevel, $txtIFTHLevel
#endregion

; Check League For DeadBase
Global $chkDBNoLeague, $chkABNoLeague, $iChkNoLeague[$g_iModeCount]
Global $aNoLeague[4] 		 = [30, 30, 0x616568, 20] ; No League Shield

; HLFClick by Samkie
Global $ichkEnableHLFClick = 1
Global $isldHLFClickDelayTime = 400
Global $ichkEnableHLFClickSetlog = 0
Global $iHLFClickMin = 7 ; Minimum click per wave
Global $iHLFClickMax = 14 ; Maximum click per wave
Global $EnableHMLSetLog = 0
Global $bDonateAwayFlag = False

; HLFClick GUI
Global $grpHLFClick, $lblHLFClickDelay, $lblDesc1, $chkEnableHLFClick, $lblHLFClickDelayTime, $sldHLFClickDelayTime, $chkEnableHLFClickSetlog


; advanced update for wall by Samkie
Global $ichkSmartUpdateWall = 1
Global $itxtClickWallDelay = 500
Global $aBaseNode[2] = [-1,-1] ;first found with core
Global $iFaceDirection = 1
Global $aLastWall[2] = [-1,-1]

Global $grpStatsMisc, $chkSmartUpdateWall,$txtClickWallDelay, $chkEnableCustomOCR4CCRequest, $chkWait4CC, $txtCCStrength, $chkCheck4CC, $txtCheck4CCWaitTime, $chkIncreaseGlobalDelay, $txtIncreaseGlobalDelay, _
$chkAutoDock

; CSV Deployment Speed Mod
Global $isldSelectedCSVSpeed[$g_iModeCount], $iCSVSpeeds[19]
$isldSelectedCSVSpeed[$DB] = 4
$isldSelectedCSVSpeed[$LB] = 4
$iCSVSpeeds[0] = .1
$iCSVSpeeds[1] = .25
$iCSVSpeeds[2] = .5
$iCSVSpeeds[3] = .75
$iCSVSpeeds[4] = 1
$iCSVSpeeds[5] = 1.25
$iCSVSpeeds[6] = 1.5
$iCSVSpeeds[7] = 1.75
$iCSVSpeeds[8] = 2
$iCSVSpeeds[9] = 2.25
$iCSVSpeeds[10] = 2.5
$iCSVSpeeds[11] = 2.75
$iCSVSpeeds[12] = 3
$iCSVSpeeds[13] = 5
$iCSVSpeeds[14] = 8
$iCSVSpeeds[15] = 10
$iCSVSpeeds[16] = 20
$iCSVSpeeds[17] = 50
$iCSVSpeeds[18] = 99
Global $grpScriptSpeedDB, $lbltxtSelectedSpeedDB, $sldSelectedSpeedDB, $grpScriptSpeedAB, $lbltxtSelectedSpeedAB, $sldSelectedSpeedAB

Global $btnAttNowDB, $btnAttNowLB

; MySwitch
Global $ichkUseADBLoadVillage = 0
Global $iSelectAccError = 0
Global $iTotalDonateType = 0
Global $iCheckAccProfileError = 0
Global $iSlotYOffset = 0
Global $chkProfileImage
Global $chkEnableMySwitch
Global $chkUseADBLoadVillage
Global $chkEnableAcc[8]
Global $cmbWithProfile[8]
Global $cmbAtkDon[8]
Global $cmbStayTime[8]
Global $lblActiveAcc

Global $ichkProfileImage = 0
Global $ichkEnableAcc[8] = [0,0,0,0,0,0,0,0]
Global $icmbWithProfile[8] = [0,0,0,0,0,0,0,0]
Global $icmbAtkDon[8] = [0,0,0,0,0,0,0,0]
Global $icmbStayTime[8] = [0,0,0,0,0,0,0,0]

Global $ichkEnableMySwitch = 0
Global $iDoPerformAfterSwitch = False
Global $iCurActiveAcc = -1
Global $iNextAcc = 0
Global $iCurStep = 0
Global $iSortEnd = 0
Global $bChangeNextAcc = True
Global $grpMySwitch, $chkEnableMySwitch, $chkProfileImage, $g_hLblProfileName, $arrowleft2, $arrowright2, $btnMakeSwitchADBFolder, $chkUseADBLoadVillage
Global $chkEnableAcc[8], $cmbWithProfile[8], $cmbAtkDon[8], $cmbStayTime[8]

Global $ichkSwitchDonTypeOnlyWhenAtkTypeNotReady = False

Global $aSwitchList[1][7]

Global $aProfileStats[44][9] = _
[["g_iFirstAttack",0,0,0,0,0,0,0,0], _
["g_iSkippedVillageCount",0,0,0,0,0,0,0,0], _
["g_iDroppedTrophyCount",0,0,0,0,0,0,0,0], _
["g_iCostGoldWall",0,0,0,0,0,0,0,0], _
["g_iCostElixirWall",0,0,0,0,0,0,0,0], _
["g_iCostGoldBuilding",0,0,0,0,0,0,0,0], _
["g_iCostElixirBuilding",0,0,0,0,0,0,0,0], _
["g_iCostDElixirHero",0,0,0,0,0,0,0,0], _
["g_iNbrOfWallsUppedGold",0,0,0,0,0,0,0,0], _
["g_iNbrOfWallsUppedElixir",0,0,0,0,0,0,0,0], _
["g_iNbrOfBuildingsUppedGold",0,0,0,0,0,0,0,0], _
["g_iNbrOfBuildingsUppedElixir",0,0,0,0,0,0,0,0], _
["g_iNbrOfHeroesUpped",0,0,0,0,0,0,0,0], _
["g_iSearchCost",0,0,0,0,0,0,0,0], _
["g_iTrainCostElixir",0,0,0,0,0,0,0,0], _
["g_iTrainCostDElixir",0,0,0,0,0,0,0,0], _
["g_iNbrOfOoS",0,0,0,0,0,0,0,0], _
["g_iNbrOfTHSnipeFails",0,0,0,0,0,0,0,0], _
["g_iNbrOfTHSnipeSuccess",0,0,0,0,0,0,0,0], _
["g_iGoldFromMines",0,0,0,0,0,0,0,0], _
["g_iElixirFromCollectors",0,0,0,0,0,0,0,0], _
["g_iDElixirFromDrills",0,0,0,0,0,0,0,0], _
["g_iFreeBuilderCount",0,0,0,0,0,0,0,0], _
["g_iTotalBuilderCount",0,0,0,0,0,0,0,0], _
["g_iGemAmount",0,0,0,0,0,0,0,0], _
["g_iTownHallLevel",0,0,0,0,0,0,0,0], _
["g_sLeague",0,0,0,0,0,0,0,0], _
["g_iLeagueNo",0,0,0,0,0,0,0,0], _
["g_iSmartZapGain",0,0,0,0,0,0,0,0], _
["g_iNumEQSpellsUsed",0,0,0,0,0,0,0,0], _
["g_iNumLSpellsUsed",0,0,0,0,0,0,0,0], _
["g_aiCurrentLoot",0,0,0,0,0,0,0,0], _
["g_iStatsStartedWith",0,0,0,0,0,0,0,0], _
["g_iStatsTotalGain",0,0,0,0,0,0,0,0], _
["g_iStatsLastAttack",0,0,0,0,0,0,0,0], _
["g_iStatsBonusLast",0,0,0,0,0,0,0,0], _
["g_aiAttackedVillageCount",0,0,0,0,0,0,0,0], _
["g_aiTotalGoldGain",0,0,0,0,0,0,0,0], _
["g_aiTotalElixirGain",0,0,0,0,0,0,0,0], _
["g_aiTotalDarkGain",0,0,0,0,0,0,0,0], _
["g_aiTotalTrophyGain",0,0,0,0,0,0,0,0], _
["g_aiNbrOfDetectedMines",0,0,0,0,0,0,0,0], _
["g_aiNbrOfDetectedCollectors",0,0,0,0,0,0,0,0], _
["g_aiNbrOfDetectedDrills",0,0,0,0,0,0,0,0]]
