---- Haunted Investigation

function UtilGetMaxInvestigators()

	return GetConVar("sk_maxinvestigators"):GetInt()
end

function UtilGetMaxGhosts()

	return GetConVar("sk_maxghosts"):GetInt()
end

function UtilGetGhostAreaChangeDelay()

	return GetConVar("sk_ghost_area_change_delay"):GetInt()
end

function UtilGetGhostAreaEnergyRefillTime()

	return GetConVar("sk_ghost_area_energy_refill_time"):GetInt()
end

function UtilGetGhostAreaEnergyDrainTime()

	return GetConVar("sk_ghost_area_energy_drain_time"):GetInt()
end

function UtilGetInvestigatorSprintDuration()

	return GetConVar("sk_investigator_sprint_duration"):GetFloat()
end

function UtilGetGhostAttackStartDelay()

	return GetConVar("sk_ghost_attack_start_delay"):GetFloat()
end

function UtilGetGhostAttackMaxDuration()

	return GetConVar("sk_ghost_attack_max_duration"):GetFloat()
end

function UtilGetGhostAttackDamage()

	return GetConVar("sk_ghost_attack_damage"):GetFloat()
end

function UtilGetGhostAttackRadius()

	return GetConVar("sk_ghost_attack_radius"):GetFloat()
end

function UtilGetGhostPresenceRadius()

	return GetConVar("sk_ghost_presence_radius"):GetFloat()
end

function UtilGetSpectatorSoundCooldown()

	return GetConVar("sk_spectator_sound_cooldown"):GetFloat()
end

function UtilGetGhostSabotageCooldown()

	return GetConVar("sk_ghost_sabotage_cooldown"):GetFloat()
end

function UtilSendChatMessageToPlayers(InMessageStrings)

	net.Start("SendChatMessageToClients")

	for Index, SampleString in ipairs(InMessageStrings) do

		net.WriteString(SampleString)
	end

	net.Broadcast()
end

function UtilAddToFractionalNWFloat(InPlayer, InValueName, InDelta)

	InPlayer:SetNWFloat(InValueName, math.Clamp(InPlayer:GetNWFloat(InValueName) + InDelta, 0.0, 1.0))
end

function UtilCheckPlayerInArea(InPlayer, InArea)

	if IsValid(InArea) then

		local PlayerPos = InPlayer:GetPos()

		local AreaPos = InArea:GetPos()

		local AreaBoundMin, AreaBoundMax = InArea:GetCollisionBounds()

		--MsgN(InArea:GetName(), AreaBoundMin, AreaBoundMax)

		--MsgN(PlayerPos:WithinAABox(AreaPos + AreaBoundMin, AreaPos + AreaBoundMax))

		if PlayerPos:WithinAABox(AreaPos + AreaBoundMin, AreaPos + AreaBoundMax) then

			return true
		end
	end

	return false
end

function UtilGetNearestEntity(InEntityList, InCheckPos, InMaxDistance)

	local OutEntity = nil

	local FilteredDistanceSquared = InMaxDistance * InMaxDistance

	MsgN(table.ToString(InEntityList))

	for SampleIndex, SampleEntity in ipairs(InEntityList) do

		--MsgN(SampleEntity:GetPos())

		local SampleDistanceSquared = InCheckPos:DistToSqr(SampleEntity:GetPos())

		--MsgN(SampleDistanceSquared)

		if SampleDistanceSquared < FilteredDistanceSquared then

			OutEntity = SampleEntity

			FilteredDistanceSquared = SampleDistanceSquared
		end
	end

	MsgN(OutEntity)

	return OutEntity
end
