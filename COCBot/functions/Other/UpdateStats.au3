; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateStats
; Description ...: This function will update the statistics in the GUI.
; Syntax ........: UpdateStats()
; Parameters ....: None
; Return values .: None
; Author ........: kaganus (06-2015)
; Modified ......: CodeSlinger69 (01-2017), Fliegerfaust (02-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
#include-once

Global $ResetStats = 0

Func UpdateStats()
    Static $s_iOldSmartZapGain = 0, $s_iOldNumLSpellsUsed = 0, $s_iOldNumEQSpellsUsed = 0
    Static $topgoldloot = 0, $topelixirloot = 0, $topdarkloot = 0, $topTrophyloot = 0
    Static $bDonateTroopsStatsChanged = False, $bDonateSpellsStatsChanged = False
    Static $iOldFreeBuilderCount, $iOldTotalBuilderCount, $iOldGemAmount ; builder and gem amounts
    Static $iOldCurrentLoot[$eLootCount] ; current stats
    Static $iOldTotalLoot[$eLootCount] ; total stats
    Static $iOldLastLoot[$eLootCount] ; loot and trophy gain from last raid
    Static $iOldLastBonus[$eLootCount] ; bonus loot from last raid
    Static $iOldSkippedVillageCount, $iOldDroppedTrophyCount ; skipped village and dropped trophy counts
    Static $iOldCostGoldWall, $iOldCostElixirWall, $iOldCostGoldBuilding, $iOldCostElixirBuilding, $iOldCostDElixirHero ; wall, building and hero upgrade costs
    Static $iOldNbrOfWallsUppedGold, $iOldNbrOfWallsUppedElixir, $iOldNbrOfBuildingsUppedGold, $iOldNbrOfBuildingsUppedElixir, $iOldNbrOfHeroesUpped ; number of wall, building, hero upgrades with gold, elixir, delixir
    Static $iOldSearchCost, $iOldTrainCostElixir, $iOldTrainCostDElixir ; search and train troops cost
    Static $iOldNbrOfOoS ; number of Out of Sync occurred
    Static $iOldNbrOfTHSnipeFails, $iOldNbrOfTHSnipeSuccess ; number of fails and success while TH Sniping
    Static $iOldGoldFromMines, $iOldElixirFromCollectors, $iOldDElixirFromDrills ; number of resources gain by collecting mines, collectors, drills
    Static $iOldAttackedCount, $iOldAttackedVillageCount[$g_iModeCount + 1] ; number of attack villages for DB, LB, TB, TS
    Static $iOldTotalGoldGain[$g_iModeCount + 1], $iOldTotalElixirGain[$g_iModeCount + 1], $iOldTotalDarkGain[$g_iModeCount + 1], $iOldTotalTrophyGain[$g_iModeCount + 1] ; total resource gains for DB, LB, TB, TS
    Static $iOldNbrOfDetectedMines[$g_iModeCount + 1], $iOldNbrOfDetectedCollectors[$g_iModeCount + 1], $iOldNbrOfDetectedDrills[$g_iModeCount + 1] ; number of mines, collectors, drills detected for DB, LB, TB

	If $g_iFirstRun = 1 Then
		;GUICtrlSetState($g_hLblResultStatsTemp, $GUI_HIDE)
		GUICtrlSetState($g_hLblVillageReportTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultGoldTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultElixirTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultDETemp, $GUI_HIDE)

		GUICtrlSetState($g_hLblResultGoldNow, $GUI_SHOW + $GUI_DISABLE) ; $GUI_DISABLE to trigger default view in btnVillageStat
		GUICtrlSetState($g_hPicResultGoldNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultElixirNow, $GUI_SHOW)
		GUICtrlSetState($g_hPicResultElixirNow, $GUI_SHOW)
		If $g_aiCurrentLoot[$eLootDarkElixir] <> "" Then
			GUICtrlSetState($g_hLblResultDeNow, $GUI_SHOW)
			GUICtrlSetState($g_hPicResultDeNow, $GUI_SHOW)
		Else
			GUICtrlSetState($g_hPicResultDEStart, $GUI_HIDE)
			GUICtrlSetState($g_hPicDarkLoot, $GUI_HIDE)
			GUICtrlSetState($g_hPicDarkLastAttack, $GUI_HIDE)
			GUICtrlSetState($g_hPicHourlyStatsDark, $GUI_HIDE)
		EndIf
		GUICtrlSetState($g_hLblResultTrophyNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultBuilderNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultGemNow, $GUI_SHOW)
		btnVillageStat("UpdateStats")
		$g_iStatsStartedWith[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
		$g_iStatsStartedWith[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
		$g_iStatsStartedWith[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
		$g_iStatsStartedWith[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
		GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
		$iOldCurrentLoot[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
		GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
		$iOldCurrentLoot[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
			GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
			$iOldCurrentLoot[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
		EndIf
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
		GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
		$iOldCurrentLoot[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
		GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($g_iGemAmount, True))
		$iOldGemAmount = $g_iGemAmount
		GUICtrlSetData($g_hLblResultBuilderNow, $g_iFreeBuilderCount & "/" & $g_iTotalBuilderCount)
		$iOldFreeBuilderCount = $g_iFreeBuilderCount
		$iOldTotalBuilderCount = $g_iTotalBuilderCount
		$g_iFirstRun = 0
		GUICtrlSetState($btnResetStats, $GUI_ENABLE)
		Return
	EndIf

	If $g_iFirstAttack = 1 Then
		;GUICtrlSetState($lblLastAttackTemp, $GUI_HIDE)
		;GUICtrlSetState($lblLastAttackBonusTemp, $GUI_HIDE)
		;GUICtrlSetState($lblTotalLootTemp, $GUI_HIDE)
		;GUICtrlSetState($lblHourlyStatsTemp, $GUI_HIDE)
		$g_iFirstAttack = 2
	EndIf

	If Number($g_iStatsLastAttack[$eLootGold]) > Number($topgoldloot) Then
		$topgoldloot = $g_iStatsLastAttack[$eLootGold]
		GUICtrlSetData($g_ahLblStatsTop[$eLootGold],_NumberFormat($topgoldloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootElixir]) > Number($topelixirloot) Then
		$topelixirloot = $g_iStatsLastAttack[$eLootElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootElixir],_NumberFormat($topelixirloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootDarkElixir]) > Number($topdarkloot) Then
		$topdarkloot = $g_iStatsLastAttack[$eLootDarkElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootDarkElixir],_NumberFormat($topdarkloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootTrophy]) > Number($topTrophyloot) Then
		$topTrophyloot = $g_iStatsLastAttack[$eLootTrophy]
		GUICtrlSetData($g_ahLblStatsTop[$eLootTrophy],_NumberFormat($topTrophyloot))
	EndIf

	If $ResetStats = 1 Then
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
		EndIf
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootGold], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootElixir], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootDarkElixir], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootTrophy], "")
		GUICtrlSetData($g_hLblResultGoldHourNow, "") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, "");GUI BOTTOM
		GUICtrlSetData($g_hLblResultDEHourNow, "") ;GUI BOTTOM

	EndIf

	If $iOldFreeBuilderCount <> $g_iFreeBuilderCount Or $iOldTotalBuilderCount <> $g_iTotalBuilderCount Then
		GUICtrlSetData($g_hLblResultBuilderNow, $g_iFreeBuilderCount & "/" & $g_iTotalBuilderCount)
		$iOldFreeBuilderCount = $g_iFreeBuilderCount
		$iOldTotalBuilderCount = $g_iTotalBuilderCount
	EndIf

	If $iOldGemAmount <> $g_iGemAmount Then
		GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($g_iGemAmount, True))
		$iOldGemAmount = $g_iGemAmount
	EndIf

	If $iOldCurrentLoot[$eLootGold] <> $g_aiCurrentLoot[$eLootGold] Then
		GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
		$iOldCurrentLoot[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
	EndIf

	If $iOldCurrentLoot[$eLootElixir] <> $g_aiCurrentLoot[$eLootElixir] Then
		GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
		$iOldCurrentLoot[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
	EndIf

	If ($iOldCurrentLoot[$eLootDarkElixir] <> $g_aiCurrentLoot[$eLootDarkElixir]) And ($g_iStatsStartedWith[$eLootDarkElixir] <> "") Then
		GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
		$iOldCurrentLoot[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
	EndIf

	If $iOldCurrentLoot[$eLootTrophy] <> $g_aiCurrentLoot[$eLootTrophy] Then
		GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
		$iOldCurrentLoot[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
	EndIf

	If $iOldTotalLoot[$eLootGold] <> $g_iStatsTotalGain[$eLootGold] And ($g_iFirstAttack = 2 Or $ResetStats = 1) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootGold], _NumberFormat($g_iStatsTotalGain[$eLootGold]))
		$iOldTotalLoot[$eLootGold] = $g_iStatsTotalGain[$eLootGold]
	EndIf

	If $iOldTotalLoot[$eLootElixir] <> $g_iStatsTotalGain[$eLootElixir] And ($g_iFirstAttack = 2 Or $ResetStats = 1) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootElixir], _NumberFormat($g_iStatsTotalGain[$eLootElixir]))
		$iOldTotalLoot[$eLootElixir] = $g_iStatsTotalGain[$eLootElixir]
	EndIf

	If $iOldTotalLoot[$eLootDarkElixir] <> $g_iStatsTotalGain[$eLootDarkElixir] And (($g_iFirstAttack = 2 And $g_iStatsStartedWith[$eLootDarkElixir] <> "") Or $ResetStats = 1) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootDarkElixir], _NumberFormat($g_iStatsTotalGain[$eLootDarkElixir]))
		$iOldTotalLoot[$eLootDarkElixir] = $g_iStatsTotalGain[$eLootDarkElixir]
	EndIf

	If $iOldTotalLoot[$eLootTrophy] <> $g_iStatsTotalGain[$eLootTrophy] And ($g_iFirstAttack = 2 Or $ResetStats = 1) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootTrophy], _NumberFormat($g_iStatsTotalGain[$eLootTrophy]))
		$iOldTotalLoot[$eLootTrophy] = $g_iStatsTotalGain[$eLootTrophy]
	EndIf

	If $iOldLastLoot[$eLootGold] <> $g_iStatsLastAttack[$eLootGold] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootGold], _NumberFormat($g_iStatsLastAttack[$eLootGold]))
		$iOldLastLoot[$eLootGold] = $g_iStatsLastAttack[$eLootGold]
	EndIf

	If $iOldLastLoot[$eLootElixir] <> $g_iStatsLastAttack[$eLootElixir] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootElixir], _NumberFormat($g_iStatsLastAttack[$eLootElixir]))
		$iOldLastLoot[$eLootElixir] = $g_iStatsLastAttack[$eLootElixir]
	EndIf

	If $iOldLastLoot[$eLootDarkElixir] <> $g_iStatsLastAttack[$eLootDarkElixir] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootDarkElixir], _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]))
		$iOldLastLoot[$eLootDarkElixir] = $g_iStatsLastAttack[$eLootDarkElixir]
	EndIf

	If $iOldLastLoot[$eLootTrophy] <> $g_iStatsLastAttack[$eLootTrophy] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootTrophy], _NumberFormat($g_iStatsLastAttack[$eLootTrophy]))
		$iOldLastLoot[$eLootTrophy] = $g_iStatsLastAttack[$eLootTrophy]
	EndIf

	If $iOldLastBonus[$eLootGold] <> $g_iStatsBonusLast[$eLootGold] Then
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootGold], _NumberFormat($g_iStatsBonusLast[$eLootGold]))
		$iOldLastBonus[$eLootGold] = $g_iStatsBonusLast[$eLootGold]
	EndIf

	If $iOldLastBonus[$eLootElixir] <> $g_iStatsBonusLast[$eLootElixir] Then
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootElixir], _NumberFormat($g_iStatsBonusLast[$eLootElixir]))
		$iOldLastBonus[$eLootElixir] = $g_iStatsBonusLast[$eLootElixir]
	EndIf

	If $iOldLastBonus[$eLootDarkElixir] <> $g_iStatsBonusLast[$eLootDarkElixir] Then
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootDarkElixir], _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]))
		$iOldLastBonus[$eLootDarkElixir] = $g_iStatsBonusLast[$eLootDarkElixir]
	EndIf

	If $iOldCostGoldWall <> $g_iCostGoldWall Then
		GUICtrlSetData($g_hLblWallUpgCostGold, _NumberFormat($g_iCostGoldWall, True))
		$iOldCostGoldWall = $g_iCostGoldWall
	EndIf

	If $iOldCostElixirWall <> $g_iCostElixirWall Then
		GUICtrlSetData($g_hLblWallUpgCostElixir, _NumberFormat($g_iCostElixirWall, True))
		$iOldCostElixirWall = $g_iCostElixirWall
	EndIf

	If $iOldCostGoldBuilding <> $g_iCostGoldBuilding Then
		GUICtrlSetData($g_hLblBuildingUpgCostGold, _NumberFormat($g_iCostGoldBuilding, True))
		$iOldCostGoldBuilding = $g_iCostGoldBuilding
	EndIf

	If $iOldCostElixirBuilding <> $g_iCostElixirBuilding Then
		GUICtrlSetData($g_hLblBuildingUpgCostElixir, _NumberFormat($g_iCostElixirBuilding, True))
		$iOldCostElixirBuilding = $g_iCostElixirBuilding
	EndIf

	If $iOldCostDElixirHero <> $g_iCostDElixirHero Then
		GUICtrlSetData($g_hLblHeroUpgCost, _NumberFormat($g_iCostDElixirHero, True))
		$iOldCostDElixirHero = $g_iCostDElixirHero
	EndIf

	If $iOldSkippedVillageCount <> $g_iSkippedVillageCount Then
		GUICtrlSetData($g_hLblResultVillagesSkipped, _NumberFormat($g_iSkippedVillageCount, True))
		GUICtrlSetData($g_hLblResultSkippedHourNow, _NumberFormat($g_iSkippedVillageCount, True))
		$iOldSkippedVillageCount = $g_iSkippedVillageCount
	EndIf

	If $iOldDroppedTrophyCount <> $g_iDroppedTrophyCount Then
		GUICtrlSetData($g_hLblResultTrophiesDropped, _NumberFormat($g_iDroppedTrophyCount, True))
		$iOldDroppedTrophyCount = $g_iDroppedTrophyCount
	EndIf

	If $iOldNbrOfWallsUppedGold <> $g_iNbrOfWallsUppedGold Then
		GUICtrlSetData($g_hLblWallGoldMake, $g_iNbrOfWallsUppedGold)
		$iOldNbrOfWallsUppedGold = $g_iNbrOfWallsUppedGold
		WallsStatsMAJ()
	EndIf

	If $iOldNbrOfWallsUppedElixir <> $g_iNbrOfWallsUppedElixir Then
		GUICtrlSetData($g_hLblWallElixirMake, $g_iNbrOfWallsUppedElixir)
		$iOldNbrOfWallsUppedElixir = $g_iNbrOfWallsUppedElixir
		WallsStatsMAJ()
	EndIf

	If $iOldNbrOfBuildingsUppedGold <> $g_iNbrOfBuildingsUppedGold Then
		GUICtrlSetData($g_hLblNbrOfBuildingUpgGold, $g_iNbrOfBuildingsUppedGold)
		$iOldNbrOfBuildingsUppedGold = $g_iNbrOfBuildingsUppedGold
	EndIf

	If $iOldNbrOfBuildingsUppedElixir <> $g_iNbrOfBuildingsUppedElixir Then
		GUICtrlSetData($g_hLblNbrOfBuildingUpgElixir, $g_iNbrOfBuildingsUppedElixir)
		$iOldNbrOfBuildingsUppedElixir = $g_iNbrOfBuildingsUppedElixir
	EndIf

	If $iOldNbrOfHeroesUpped <> $g_iNbrOfHeroesUpped Then
		GUICtrlSetData($g_hLblNbrOfHeroUpg, $g_iNbrOfHeroesUpped)
		$iOldNbrOfHeroesUpped = $g_iNbrOfHeroesUpped
	EndIf

	If $iOldSearchCost <> $g_iSearchCost Then
		GUICtrlSetData($g_hLblSearchCost, _NumberFormat($g_iSearchCost, True))
		$iOldSearchCost = $g_iSearchCost
	EndIf

	If $iOldTrainCostElixir <> $g_iTrainCostElixir Then
		GUICtrlSetData($g_hLblTrainCostElixir, _NumberFormat($g_iTrainCostElixir, True))
		$iOldTrainCostElixir = $g_iTrainCostElixir
	EndIf

	If $iOldTrainCostDElixir <> $g_iTrainCostDElixir Then
		GUICtrlSetData($g_hLblTrainCostDElixir, _NumberFormat($g_iTrainCostDElixir, True))
		$iOldTrainCostDElixir = $g_iTrainCostDElixir
	EndIf

	If $iOldNbrOfOoS <> $g_iNbrOfOoS Then
		GUICtrlSetData($g_hLblNbrOfOoS, $g_iNbrOfOoS)
		$iOldNbrOfOoS = $g_iNbrOfOoS
	EndIf

	If $iOldNbrOfTHSnipeFails <> $g_iNbrOfTHSnipeFails Then
		GUICtrlSetData($g_hLblNbrOfTSFailed, $g_iNbrOfTHSnipeFails)
		$iOldNbrOfTHSnipeFails = $g_iNbrOfTHSnipeFails
	EndIf

	If $iOldNbrOfTHSnipeSuccess <> $g_iNbrOfTHSnipeSuccess Then
		GUICtrlSetData($g_hLblNbrOfTSSuccess, $g_iNbrOfTHSnipeSuccess)
		$iOldNbrOfTHSnipeSuccess = $g_iNbrOfTHSnipeSuccess
	EndIf

	If $iOldGoldFromMines <> $g_iGoldFromMines Then
		GUICtrlSetData($g_hLblGoldFromMines, _NumberFormat($g_iGoldFromMines, True))
		$iOldGoldFromMines = $g_iGoldFromMines
	EndIf

	If $iOldElixirFromCollectors <> $g_iElixirFromCollectors Then
		GUICtrlSetData($g_hLblElixirFromCollectors, _NumberFormat($g_iElixirFromCollectors, True))
		$iOldElixirFromCollectors = $g_iElixirFromCollectors
	EndIf

	If $iOldDElixirFromDrills <> $g_iDElixirFromDrills Then
		GUICtrlSetData($g_hLblDElixirFromDrills, _NumberFormat($g_iDElixirFromDrills, True))
		$iOldDElixirFromDrills = $g_iDElixirFromDrills
	EndIf

	For $i = 0 To $eTroopCount - 1
		If $g_aiDonateStatsTroops[$i][0] <> $g_aiDonateStatsTroops[$i][1] Then
			GUICtrlSetData($g_hLblDonTroop[$i], _NumberFormat($g_aiDonateStatsTroops[$i][0], True))
			$g_iTotalDonateStatsTroops += ($g_aiDonateStatsTroops[$i][0] - $g_aiDonateStatsTroops[$i][1])
			$g_iTotalDonateStatsTroopsXP += (($g_aiDonateStatsTroops[$i][0] - $g_aiDonateStatsTroops[$i][1]) * $g_aiTroopDonateXP[$i])
			$g_aiDonateStatsTroops[$i][1] = $g_aiDonateStatsTroops[$i][0]
			$bDonateTroopsStatsChanged = True
		EndIf
	Next
	If $bDonateTroopsStatsChanged Then
		GUICtrlSetData($g_hLblTotalTroopsQ, _NumberFormat($g_iTotalDonateStatsTroops, True))
		GUICtrlSetData($g_hLblTotalTroopsXP, _NumberFormat($g_iTotalDonateStatsTroopsXP, True))
		$bDonateTroopsStatsChanged = False
	EndIf

	For $i = 0 To $eSpellCount - 1
		If $g_aiDonateStatsSpells[$i][0] <> $g_aiDonateStatsSpells[$i][1] And $i <> $eSpellClone Then
			GUICtrlSetData($g_hLblDonSpell[$i], _NumberFormat($g_aiDonateStatsSpells[$i][0], True))
			$g_iTotalDonateStatsSpells += ($g_aiDonateStatsSpells[$i][0] - $g_aiDonateStatsSpells[$i][1])
			$g_iTotalDonateStatsSpellsXP += (($g_aiDonateStatsSpells[$i][0] - $g_aiDonateStatsSpells[$i][1]) * $g_aiSpellDonateXP[$i])
			$g_aiDonateStatsSpells[$i][1] = $g_aiDonateStatsSpells[$i][0]
			$bDonateSpellsStatsChanged = True
		EndIf
	Next

	If $bDonateSpellsStatsChanged Then
		GUICtrlSetData($g_hLblTotalSpellsQ, _NumberFormat($g_iTotalDonateStatsSpells, True))
		GUICtrlSetData($g_hLblTotalSpellsXP, _NumberFormat($g_iTotalDonateStatsSpellsXP, True))
		$bDonateSpellsStatsChanged = False
	EndIf

	; samm0d - samm0dzap
	; SmartZap DE Gain
	If $s_iOldSmartZapGain <> $g_iSmartZapGain Then
		GUICtrlSetData($g_hLblSmartZap, _NumberFormat($g_iSmartZapGain, True))
		GUICtrlSetData($lblMySmartZap, _NumberFormat($g_iSmartZapGain, True))
		$s_iOldSmartZapGain = $g_iSmartZapGain
	EndIf

	If $s_iOldNumLSpellsUsed <> $g_iNumLSpellsUsed Then
		GUICtrlSetData($g_hLblSmartLightningUsed, _NumberFormat($g_iNumLSpellsUsed, True))
		GUICtrlSetData($lblMyLightningUsed, _NumberFormat($g_iNumLSpellsUsed, True))
		$s_iOldNumLSpellsUsed = $g_iNumLSpellsUsed
 	EndIf
	;--------------------

	If $s_iOldNumEQSpellsUsed <> $g_iNumEQSpellsUsed Then
		GUICtrlSetData($g_hLblSmartEarthQuakeUsed, _NumberFormat($g_iNumEQSpellsUsed, True))
		$s_iOldNumEQSpellsUsed = $g_iNumEQSpellsUsed
 	EndIf

	$g_aiAttackedCount = 0

	For $i = 0 To $g_iModeCount

		If $iOldAttackedVillageCount[$i] <> $g_aiAttackedVillageCount[$i] Then
			GUICtrlSetData($g_hLblAttacked[$i], _NumberFormat($g_aiAttackedVillageCount[$i], True))
			$iOldAttackedVillageCount[$i] = $g_aiAttackedVillageCount[$i]
		EndIf
		$g_aiAttackedCount += $g_aiAttackedVillageCount[$i]

		If $iOldTotalGoldGain[$i] <> $g_aiTotalGoldGain[$i] Then
			GUICtrlSetData($g_hLblTotalGoldGain[$i], _NumberFormat($g_aiTotalGoldGain[$i], True))
			$iOldTotalGoldGain[$i] = $g_aiTotalGoldGain[$i]
		EndIf

		If $iOldTotalElixirGain[$i] <> $g_aiTotalElixirGain[$i] Then
			GUICtrlSetData($g_hLblTotalElixirGain[$i], _NumberFormat($g_aiTotalElixirGain[$i], True))
			$iOldTotalElixirGain[$i] = $g_aiTotalElixirGain[$i]
		EndIf

		If $iOldTotalDarkGain[$i] <> $g_aiTotalDarkGain[$i] Then
			GUICtrlSetData($g_hLblTotalDElixirGain[$i], _NumberFormat($g_aiTotalDarkGain[$i], True))
			$iOldTotalDarkGain[$i] = $g_aiTotalDarkGain[$i]
		EndIf

		If $iOldTotalTrophyGain[$i] <> $g_aiTotalTrophyGain[$i] Then
			GUICtrlSetData($g_hLblTotalTrophyGain[$i], _NumberFormat($g_aiTotalTrophyGain[$i], True))
			$iOldTotalTrophyGain[$i] = $g_aiTotalTrophyGain[$i]
		EndIf

	Next

	If $iOldAttackedCount <> $g_aiAttackedCount Then
		GUICtrlSetData($g_hLblResultVillagesAttacked, _NumberFormat($g_aiAttackedCount, True))
		GUICtrlSetData($g_hLblResultAttackedHourNow, _NumberFormat($g_aiAttackedCount, True))
		$iOldAttackedCount = $g_aiAttackedCount
	EndIf

	For $i = 0 To $g_iModeCount

		If $i = $TS Then ContinueLoop

		If $iOldNbrOfDetectedMines[$i] <> $g_aiNbrOfDetectedMines[$i] Then
			GUICtrlSetData($g_hLblNbrOfDetectedMines[$i], $g_aiNbrOfDetectedMines[$i])
			$iOldNbrOfDetectedMines[$i] = $g_aiNbrOfDetectedMines[$i]
		EndIf

		If $iOldNbrOfDetectedCollectors[$i] <> $g_aiNbrOfDetectedCollectors[$i] Then
			GUICtrlSetData($g_hLblNbrOfDetectedCollectors[$i], $g_aiNbrOfDetectedCollectors[$i])
			$iOldNbrOfDetectedCollectors[$i] = $g_aiNbrOfDetectedCollectors[$i]
		EndIf

		If $iOldNbrOfDetectedDrills[$i] <> $g_aiNbrOfDetectedDrills[$i] Then
			GUICtrlSetData($g_hLblNbrOfDetectedDrills[$i], $g_aiNbrOfDetectedDrills[$i])
			$iOldNbrOfDetectedDrills[$i] = $g_aiNbrOfDetectedDrills[$i]
		EndIf

	Next

	If $g_iFirstAttack = 2 Then
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootGold], _NumberFormat(Round($g_iStatsTotalGain[$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootElixir], _NumberFormat(Round($g_iStatsTotalGain[$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootDarkElixir], _NumberFormat(Round($g_iStatsTotalGain[$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		EndIf
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootTrophy], _NumberFormat(Round($g_iStatsTotalGain[$eLootTrophy] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")

		GUICtrlSetData($g_hLblResultGoldHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_hLblResultDEHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h") ;GUI BOTTOM
		EndIf

	EndIf

	If Number($g_iStatsLastAttack[$eLootGold]) > Number($topgoldloot) Then
		$topgoldloot = $g_iStatsLastAttack[$eLootGold]
		GUICtrlSetData($g_ahLblStatsTop[$eLootGold],_NumberFormat($topgoldloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootElixir]) > Number($topelixirloot) Then
		$topelixirloot = $g_iStatsLastAttack[$eLootElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootElixir],_NumberFormat($topelixirloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootDarkElixir]) > Number($topdarkloot) Then
		$topdarkloot = $g_iStatsLastAttack[$eLootDarkElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootDarkElixir],_NumberFormat($topdarkloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootTrophy]) > Number($topTrophyloot) Then
		$topTrophyloot = $g_iStatsLastAttack[$eLootTrophy]
		GUICtrlSetData($g_ahLblStatsTop[$eLootTrophy],_NumberFormat($topTrophyloot))
	EndIf

	; samm0d ==============================================
	If $ichkEnableMySwitch Then
		If $iCurActiveAcc <> - 1 Then
			If $aProfileStats[32][$iCurActiveAcc+1] = 0 Then
				$aProfileStats[32][$iCurActiveAcc+1] = $g_aiCurrentLoot

				$g_iStatsStartedWith[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
				$g_iStatsStartedWith[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
				$g_iStatsStartedWith[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
				$g_iStatsStartedWith[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]

				$aProfileStats[32][$iCurActiveAcc+1] = $g_iStatsStartedWith

				Local $tempStatsStartedWith[$eLootCount]
				$tempStatsStartedWith = $aProfileStats[32][$iCurActiveAcc+1]

				GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($tempStatsStartedWith[$eLootGold], True))
				GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($tempStatsStartedWith[$eLootElixir], True))
				If $tempStatsStartedWith[$eLootDarkElixir] <> "" Then
					GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($tempStatsStartedWith[$eLootDarkElixir], True))
				EndIf
				GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($tempStatsStartedWith[$eLootTrophy], True))
			EndIf

			saveCurStats($iCurActiveAcc)

			If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
				GUICtrlSetState($g_hLblResultDeNow, $GUI_SHOW)
				GUICtrlSetState($g_hPicResultDeNow, $GUI_SHOW)

				GUICtrlSetState($g_hPicResultDEStart, $GUI_SHOW)
				GUICtrlSetState($g_hPicDarkLoot, $GUI_SHOW)
				GUICtrlSetState($g_hPicDarkLastAttack, $GUI_SHOW)
				GUICtrlSetState($g_hPicHourlyStatsDark, $GUI_SHOW)

				;GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($g_iStatsStartedWith[$eLootDarkElixir], True))
				;GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($g_iStatsStartedWith[$eLootDarkElixir], True))
			Else
				GUICtrlSetState($g_hPicResultDEStart, $GUI_HIDE)
				GUICtrlSetState($g_hPicDarkLoot, $GUI_HIDE)
				GUICtrlSetState($g_hPicDarkLastAttack, $GUI_HIDE)
				GUICtrlSetState($g_hPicHourlyStatsDark, $GUI_HIDE)
			EndIf

			If $bUpdateStats = True Then
				If $aSwitchList[$iCurStep][4] <> $iCurActiveAcc Then
					For $i = 0 To UBound($aSwitchList) - 1
						If $aSwitchList[$i][4] = $iCurActiveAcc Then
							$iCurStep = $i
						EndIf
					Next
					GUICtrlSetData($g_hGrpVillage, GetTranslated(603, 32, "Village") & ": " & $aSwitchList[$iCurStep][3])
					GUICtrlSetData($g_hLblProfileName,$aSwitchList[$iCurStep][3])

					displayStats($iCurActiveAcc)
				EndIf
			EndIf
		EndIf
	EndIf
	;===================================

	If $ResetStats = 1 Then
		$ResetStats = 0
	EndIf

EndFunc   ;==>UpdateStats

Func ResetStats()
	$ResetStats = 1
	$g_iFirstAttack = 0
	$g_iTimePassed = 0
	$g_hTimerSinceStarted = __TimerInit()
	GUICtrlSetData($g_hLblResultRuntime, "00:00:00")
	GUICtrlSetData($g_hLblResultRuntimeNow, "00:00:00")
	$g_iStatsStartedWith[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
	$g_iStatsStartedWith[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
	$g_iStatsStartedWith[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
	$g_iStatsStartedWith[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
	$g_iStatsTotalGain[$eLootGold] = 0
	$g_iStatsTotalGain[$eLootElixir] = 0
	$g_iStatsTotalGain[$eLootDarkElixir] = 0
	$g_iStatsTotalGain[$eLootTrophy] = 0
	$g_iStatsLastAttack[$eLootGold] = 0
	$g_iStatsLastAttack[$eLootElixir] = 0
	$g_iStatsLastAttack[$eLootDarkElixir] = 0
	$g_iStatsLastAttack[$eLootTrophy] = 0
	$g_iStatsBonusLast[$eLootGold] = 0
	$g_iStatsBonusLast[$eLootElixir] = 0
	$g_iStatsBonusLast[$eLootDarkElixir] = 0
	$g_iSkippedVillageCount = 0
	$g_iDroppedTrophyCount = 0
	$g_iCostGoldWall = 0
	$g_iCostElixirWall = 0
	$g_iCostGoldBuilding = 0
	$g_iCostElixirBuilding = 0
	$g_iCostDElixirHero = 0
	$g_iNbrOfWallsUppedGold = 0
	$g_iNbrOfWallsUppedElixir = 0
	$g_iNbrOfBuildingsUppedGold = 0
	$g_iNbrOfBuildingsUppedElixir = 0
	$g_iNbrOfHeroesUpped = 0
	$g_iSearchCost = 0
	$g_iTrainCostElixir = 0
	$g_iTrainCostDElixir = 0
	$g_iNbrOfOoS = 0
	$g_iNbrOfTHSnipeFails = 0
	$g_iNbrOfTHSnipeSuccess = 0
	$g_iGoldFromMines = 0
	$g_iElixirFromCollectors = 0
	$g_iDElixirFromDrills = 0
	$g_iSmartZapGain = 0
	$g_iNumLSpellsUsed = 0
	$g_iNumEQSpellsUsed = 0
	For $i = 0 To $g_iModeCount
		$g_aiAttackedVillageCount[$i] = 0
		$g_aiTotalGoldGain[$i] = 0
		$g_aiTotalElixirGain[$i] = 0
		$g_aiTotalDarkGain[$i] = 0
		$g_aiTotalTrophyGain[$i] = 0
		$g_aiNbrOfDetectedMines[$i] = 0
		$g_aiNbrOfDetectedCollectors[$i] = 0
		$g_aiNbrOfDetectedDrills[$i] = 0
	Next

	For $i = 0 To $eTroopCount - 1
		$g_aiDonateStatsTroops[$i][0] = 0
    Next

	For $i = 0 To $eSpellCount - 1
	   If $i <> $eSpellClone Then
		   $g_aiDonateStatsSpells[$i][0] = 0
	   EndIf
	Next

	$g_iTotalDonateStatsTroops = 0
	$g_iTotalDonateStatsTroopsXP = 0
	$g_iTotalDonateStatsSpells = 0
	$g_iTotalDonateStatsSpellsXP = 0

	;========SamM0d===========
	If $ichkEnableMySwitch Then
		If $iCurActiveAcc <> - 1 Then
			; samm0d myswitch
			For $i = 0 To 7
				resetCurStats($i)
			Next
			$aProfileStats[32][$iCurActiveAcc+1] = $g_aiCurrentLoot
		EndIf
	EndIf

	UpdateStats()
 EndFunc   ;==>ResetStats

 Func WallsStatsMAJ()
	$g_aiWallsCurrentCount[$g_iCmbUpgradeWallsLevel + 4] -= Number($g_iNbrOfWallsUpped)
	$g_aiWallsCurrentCount[$g_iCmbUpgradeWallsLevel + 5] += Number($g_iNbrOfWallsUpped)
	$g_iNbrOfWallsUpped = 0
	For $i = 4 To 12
		GUICtrlSetData($g_ahWallsCurrentCount[$i], $g_aiWallsCurrentCount[$i])
    Next
    SaveConfig()
EndFunc   ;==>WallsStatsMAJ
