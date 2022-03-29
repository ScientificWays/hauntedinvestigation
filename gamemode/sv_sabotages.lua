---- Haunted Investigation

SabotageRelayList = {}

hook.Add("KeyPress", "GhostSabotageActivate", function(InPlayer, InKey)

	if InKey == IN_ATTACK2 then

		TryActivateNearestSabotage(InPlayer)
	end
end)

timer.Create("NearestSabotageUpdate", 2.0, 0, function()

	if table.IsEmpty(SabotageRelayList) then

		MsgN("Warning! SabotageRelayList is empty for this map. Consider adding logic_relay with _GhostSabotage postfix!")

		timer.Remove("NearestSabotageUpdate")

		return
	end

	UpdateNearestSabotageForGhosts()
end)

function UpdateNearestSabotageForGhosts()

	local AllGhosts = team.GetPlayers(TEAM_GHOST)

	for SampleIndex, SampleGhost in ipairs(AllGhosts) do

		local SabotageEntity = UtilGetNearestEntity(SabotageRelayList, SampleGhost:GetPos(), 1024.0)

		--MsgN(SabotageEntity)

		if IsValid(SabotageEntity) and SabotageEntity:GetNWFloat("GhostSabotageCooldownTime") < CurTime() then

			MsgN(SabotageEntity:GetPos())

			SampleGhost:SetNWVector("SabotageRelayPos", SabotageEntity:GetPos())

			SampleGhost.NearestSabotage = SabotageEntity
		else
			SampleGhost:SetNWVector("SabotageRelayPos", Vector())

			SampleGhost.NearestSabotage = nil
		end
	end
end

function RegisterSabotageData(InSabotageRelay)

	MsgN(Format("RegisterSabotageData() %s", InSabotageRelay))

	table.insert(SabotageRelayList, InSabotageRelay)
end

function CanActivateSabotage(InPlayer)

	return InPlayer:Team() == TEAM_GHOST
		and InPlayer.NearestSabotage ~= nil
		and InPlayer.NearestSabotage:GetNWFloat("GhostSabotageCooldownTime") < CurTime()
end

function TryActivateNearestSabotage(InPlayer)

	if CanActivateSabotage(InPlayer) then

		InPlayer.NearestSabotage:SetNWFloat("GhostSabotageCooldownTime", CurTime() + UtilGetGhostSabotageCooldown())

		InPlayer.NearestSabotage:Input("Trigger")

		UpdateNearestSabotageForGhosts()
	end
end
