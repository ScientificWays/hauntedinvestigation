---- Haunted Investigation

SabotageRelayList = {}

function UpdateNearestSabotageForGhosts()

	UtilDoForPlayers(team.GetPlayers(TEAM_GHOST), function(InIndex, InPlayer)

		local SabotageEntity = UtilGetNearestEntity(SabotageRelayList, InPlayer:GetPos(), 1024.0)

		--MsgN(SabotageEntity)

		if IsValid(SabotageEntity) and SabotageEntity:GetNWFloat("GhostSabotageCooldownTime") < CurTime() then

			--MsgN(SabotageEntity:GetPos())

			InPlayer:SetNWVector("SabotageRelayPos", SabotageEntity:GetPos())

			InPlayer.NearestSabotage = SabotageEntity
		else
			InPlayer:SetNWVector("SabotageRelayPos", Vector())

			InPlayer.NearestSabotage = nil
		end
	end)
end

function RegisterSabotageData(InSabotageRelay)

	MsgN(Format("RegisterSabotageData() %s", InSabotageRelay))

	table.insert(SabotageRelayList, InSabotageRelay)
end

function CanActivateSabotage(InPlayer)

	return UtilGetCurrentGameState() == GAMESTATE_INVESTIGATION
		and InPlayer:Team() == TEAM_GHOST
		and InPlayer.NearestSabotage ~= nil
		and InPlayer.NearestSabotage:GetNWFloat("GhostSabotageCooldownTime") < CurTime()
		and InPlayer:GetNWFloat("EnergyValue") >= 0.25
end

function TryActivateNearestSabotage(InPlayer)

	if CanActivateSabotage(InPlayer) then

		InPlayer.NearestSabotage:SetNWFloat("GhostSabotageCooldownTime", CurTime() + UtilGetGhostSabotageCooldown())

		InPlayer.NearestSabotage:Input("Trigger")

		InPlayer:SetNWFloat("EnergyValue", math.Clamp(InPlayer:GetNWFloat("EnergyValue") - 0.25, 0.0, 1.0))

		UpdateNearestSabotageForGhosts()
	end
end
