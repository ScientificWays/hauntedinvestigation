---- Haunted Investigation

function GM:OnPlayerChangedTeam(InPlayer, InOldTeam, InNewTeam)

	InPlayer:Spawn()
end

function GM:PlayerDeathThink(InPlayer)

end

function GM:PlayerSelectTeamSpawn(TeamID, InPlayer)

	MsgN(Format("PlayerSelectTeamSpawn() %s", InPlayer))

	local SpawnPointList = {}

	if UtilGetCurrentGameState() == GAMESTATE_INVESTIGATION then

		if TeamID == TEAM_INVESTIGATOR then

			SpawnPointList = team.GetSpawnPoints(TeamID)

		else
			SpawnPointList = team.GetPlayers(TEAM_INVESTIGATOR)
		end
	end

	if table.IsEmpty(SpawnPointList) then

		return
	end

	local OutSpawnPoint = table.Random(SpawnPointList)

	return OutSpawnPoint
end

function GM:PlayerSpawn(InPlayer, InTransiton)

	MsgN(Format("PlayerSpawn() %s", InPlayer))

	if InPlayer:Team() == TEAM_SPECTATOR
	or InPlayer:Team() == TEAM_UNASSIGNED
	or UtilGetCurrentGameState() == GAMESTATE_PREGAME
	or UtilGetCurrentGameState() == GAMESTATE_POSTGAME then

		self:PlayerSpawnAsSpectator(InPlayer)

		InPlayer:SetNWBool("bRenderLight", true)
	else
		player_manager.SetPlayerClass(InPlayer, table.Random(team.GetClass(InPlayer:Team())))

		InPlayer:UnSpectate()

		InPlayer:SetupHands()

		player_manager.OnPlayerSpawn(InPlayer, InTransiton)

		player_manager.RunClass(InPlayer, "Spawn")

		hook.Run("PlayerLoadout", InPlayer)

		hook.Run("PlayerSetModel", InPlayer)

		if UtilGetCurrentGameState() == GAMESTATE_VEHICLEINTRO then

			OnPlayerSpawnDuringVehicleIntro(InPlayer)
		end

		InPlayer:SetNWBool("bRenderLight", InPlayer:Team() == TEAM_GHOST)
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

function GM:CanExitVehicle(InVehicle, InPlayer)

	return UtilGetCurrentGameState() ~= GAMESTATE_VEHICLEINTRO
end
