---- Haunted Investigation

timer.Create("InvestigatorRegenerationTick", 2.0, 0, function()

	UtilDoForPlayers(team.GetPlayers(TEAM_INVESTIGATOR), function(InIndex, InPlayer)

		InPlayer:SetHealth(math.Clamp(InPlayer:Health() + 1, 0, InPlayer:GetMaxHealth()))
	end)
end)

function GM:PlayerCanJoinTeam(InPlayer, InNewTeam)

	if InPlayer:Team() == InNewTeam
		or (GetGlobalInt("CurrentGameState") == GAMESTATE_INVESTIGATION
			and InNewTeam == TEAM_INVESTIGATOR
			and GetGlobalInt("InvestigatorLifes") <= 0) then

		return false
	end

	return true
end

function GM:PlayerJoinTeam(InPlayer, InNewTeam)

	local OldTeam = InPlayer:Team()

	if InPlayer:Alive() then

		InPlayer:KillSilent()
	end

	InPlayer:SetTeam(InNewTeam)

	InPlayer.LastTeamSwitch = RealTime()

	GAMEMODE:OnPlayerChangedTeam(InPlayer, OldTeam, InNewTeam)
end

function GM:OnPlayerChangedTeam(InPlayer, InOldTeam, InNewTeam)

	InPlayer:Spawn()
	
	UtilSendChatMessageToPlayers({"HI_Event.ChangeTeam", InPlayer:GetName(), team.GetName(InNewTeam)})
end

--[[function GM:PlayerDeathThink(InPlayer)

end--]]

function GM:PlayerSelectSpawn(InPlayer, bTransition)

	MsgN(Format("PlayerSelectSpawn() %s", InPlayer))

	local SpawnPointList = {}

	if UtilGetCurrentGameState() == GAMESTATE_INVESTIGATION then

		if InPlayer:Team() == TEAM_INVESTIGATOR then

			local CheckpointList = GetInvestigatorCheckpointList()

			if not table.IsEmpty(CheckpointList) then

				SpawnPointList = CheckpointList
			else
				SpawnPointList = team.GetSpawnPoints(TEAM_INVESTIGATOR) or {}
			end
		else
			SpawnPointList = team.GetPlayers(TEAM_INVESTIGATOR)
		end
	end

	if table.IsEmpty(SpawnPointList) then

		local DefaultPlayerStarts = ents.FindByClass("info_player_start")

		return table.Random(DefaultPlayerStarts)
	end

	local OutSpawnPoint = table.Random(SpawnPointList)

	MsgN("OutSpawnPoint:", OutSpawnPoint)

	return OutSpawnPoint
end

function GM:PlayerInitialSpawn(InPlayer, bTransition)

	InPlayer:SetCustomCollisionCheck(true)

	InPlayer:SetTeam(TEAM_UNASSIGNED)

	InPlayer:ConCommand("gm_showteam")
end

function GM:PlayerSpawn(InPlayer, bTransiton)

	MsgN(Format("PlayerSpawn() %s", InPlayer))

	if InPlayer:Team() == TEAM_SPECTATOR
	or InPlayer:Team() == TEAM_UNASSIGNED
	or UtilGetCurrentGameState() == GAMESTATE_PREGAME
	or UtilGetCurrentGameState() == GAMESTATE_POSTGAME then

		InPlayer:SetNWBool("bSpectator", true)

		self:PlayerSpawnAsSpectator(InPlayer)
	else
		InPlayer:SetNWBool("bSpectator", false)

		player_manager.SetPlayerClass(InPlayer, table.Random(team.GetClass(InPlayer:Team())))

		InPlayer:UnSpectate()

		InPlayer:SetupHands()

		player_manager.OnPlayerSpawn(InPlayer, bTransiton)

		player_manager.RunClass(InPlayer, "Spawn")

		hook.Run("PlayerLoadout", InPlayer)

		hook.Run("PlayerSetModel", InPlayer)

		InPlayer:ConCommand("pp_colormod 1")

		InPlayer:ConCommand("pp_colormod_addr 0")
		InPlayer:ConCommand("pp_colormod_addg 0")
		InPlayer:ConCommand("pp_colormod_addb 0")
		InPlayer:ConCommand("pp_colormod_contrast 1")
		InPlayer:ConCommand("pp_colormod_mulr 0")
		InPlayer:ConCommand("pp_colormod_mulg 0")
		InPlayer:ConCommand("pp_colormod_mulb 0")
		InPlayer:ConCommand("pp_colormod_brightness 0.0")

		InPlayer:ConCommand("pp_motionblur 1")

		InPlayer:ConCommand("pp_motionblur_addalpha 1.0")
		InPlayer:ConCommand("pp_motionblur_drawalpha 1.0")
		InPlayer:ConCommand("pp_motionblur_delay 0.0")
	end
end

function GM:PlayerSpawnAsSpectator(InPlayer)

	MsgN(Format("PlayerSpawnAsSpectator() %s", InPlayer))

	InPlayer:StripWeapons()

	if InPlayer:Team() == TEAM_UNASSIGNED then

		InPlayer:Spectate(OBS_MODE_FIXED)
	else
		--InPlayer:SetTeam(TEAM_SPECTATOR)

		InPlayer:Spectate(OBS_MODE_ROAMING)
	end
end

function GM:CanPlayerEnterVehicle(InPlayer, InVehicle, InSeatIndex)

	return UtilGetCurrentGameState() == GAMESTATE_VEHICLEINTRO and InPlayer:Team() == TEAM_INVESTIGATOR
end

function GM:CanExitVehicle(InVehicle, InPlayer)

	return UtilGetCurrentGameState() ~= GAMESTATE_VEHICLEINTRO
end

function GM:EntityTakeDamage(InTarget, InDamageInfo)

	if InTarget:IsPlayer() and InTarget:Team() == TEAM_GHOST then

		InTarget.DamageSlowEndTime = InTarget.DamageSlowEndTime or 0.0

		InTarget.DamageSlowEndTime = math.max(InTarget.DamageSlowEndTime, 0.05 * InDamageInfo:GetDamage())

		return true
	end

	return false
end

function GM:PlayerNoClip(InPlayer, bDesiredNoClipState)
	
	return GetConVar("sv_cheats"):GetInt() > 0 and InPlayer:Alive()
end

function GM:PostPlayerDeath(InPlayer)

	if InPlayer:Team() == TEAM_INVESTIGATOR then

		SetGlobalInt("InvestigatorLifes", GetGlobalInt("InvestigatorLifes") - 1)

		UtilSendChatMessageToPlayers({"HI_Event.InvestigatorLifesDecrease", InPlayer:GetName(), GetGlobalInt("InvestigatorLifes")})

		if GetGlobalInt("InvestigatorLifes") <= 0 then

			UtilSendChatMessageToPlayers({"HI_Event.InvestigatorNoLifes"})

			GAMEMODE:PlayerJoinTeam(InPlayer, TEAM_SPECTATOR)

			local bNoAliveInvestigators = true

			UtilDoForPlayers(team.GetPlayers(TEAM_INVESTIGATOR), function(InIndex, InPlayer)

				if InPlayer:Alive() then

					bNoAliveInvestigators = false

					return
				end
			end)

			if bNoAliveInvestigators then

				FinishInvestigation(2)
			end
		end
	end
end
