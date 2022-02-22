---- Haunted Investigation

function GM:OnPlayerChangedTeam(InPlayer, InOldTeam, InNewTeam)

	InPlayer:Spawn()
end

--[[function GM:PlayerDeathThink(InPlayer)

end--]]

function GM:PlayerSelectSpawn(InPlayer, bTransition)

	MsgN(Format("PlayerSelectSpawn() %s", InPlayer))

	local SpawnPointList = {}

	if UtilGetCurrentGameState() == GAMESTATE_INVESTIGATION then

		if InPlayer:Team() == TEAM_INVESTIGATOR then

			SpawnPointList = team.GetSpawnPoints(TEAM_INVESTIGATOR) or {}

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

function GM:CanPlayerEnterVehicle(InVehicle, InPlayer, InSeatIndex)

	return UtilGetCurrentGameState() == GAMESTATE_VEHICLEINTRO and InPlayer:Team() == TEAM_INVESTIGATOR
end

function GM:CanExitVehicle(InVehicle, InPlayer)

	return UtilGetCurrentGameState() ~= GAMESTATE_VEHICLEINTRO
end

function GM:PlayerShouldTakeDamage(InPlayer, InEntity)

	if InPlayer:Team() == TEAM_GHOST then

		return false
	end

	return true
end
