---- Haunted Investigation

hook.Add("SetupMove", "EnergyMove", function(InPlayer, InMoveData, InCommandData)

	if InPlayer:Team() == TEAM_INVESTIGATOR then

		local FinalMaxSpeed = Lerp(InPlayer:GetNWFloat("EnergyValue"), 100, InMoveData:GetMaxClientSpeed())

		InMoveData:SetMaxClientSpeed(FinalMaxSpeed)
	end
end)

hook.Add("KeyPress", "EnergyJump", function(InPlayer, InKey)

	if InPlayer:Team() == TEAM_INVESTIGATOR then

		if InKey == IN_JUMP and (InPlayer.LastJumpEnergyDrain or 0) + 1.5 < CurTime() then

			InPlayer:SetNWFloat("EnergyValue", InPlayer:GetNWFloat("EnergyValue") * 0.8)

			InPlayer.LastJumpEnergyDrain = CurTime()
		end
	end
end)

local function HandleInvestigatorSprintingTick(InInvestigatorPlayer)

	local ValueMultiplier = 1.0 / UtilGetInvestigatorSprintDuration()

	local EnergyDelta = 0.0

	if InInvestigatorPlayer:IsSprinting() then

		EnergyDelta = -ValueMultiplier
	else

		if InInvestigatorPlayer:GetNWFloat("EnergyValue") < 1.0 then

			EnergyDelta = ValueMultiplier * 2
		end
	end

	if EnergyDelta ~= 0.0 then

		MsgN(InInvestigatorPlayer:GetNWFloat("EnergyValue"))

		UtilAddToFractionalNWFloat(InInvestigatorPlayer, "EnergyValue", EnergyDelta)

		if InInvestigatorPlayer:GetNWFloat("EnergyValue") < 0.4 then

			if InInvestigatorPlayer.BreatheSound == nil then

				InInvestigatorPlayer.BreatheSound = CreateSound(InInvestigatorPlayer, "player/breathe1.wav", RecipientFilter():AddAllPlayers())

				InInvestigatorPlayer.BreatheSound:Play()

				--MsgN("Play sound")
			end

			InInvestigatorPlayer.BreatheSound:ChangeVolume(1.0 - InInvestigatorPlayer:GetNWFloat("EnergyValue") * 4.0)
		else

			--MsgN(InInvestigatorPlayer.BreatheSound)

			if InInvestigatorPlayer.BreatheSound ~= nil then

				InInvestigatorPlayer.BreatheSound:Stop()

				InInvestigatorPlayer.BreatheSound = nil

				--MsgN("Stop sound")
			end
		end

		InInvestigatorPlayer:SetJumpPower(200.0 * math.Clamp(InInvestigatorPlayer:GetNWFloat("EnergyValue") + 0.5, 0.0, 1.0))
	end
end

local function HandleGhostSprintingTick(InGhostPlayer)

	local SpectralValueDelta = 1.0 / UtilGetGhostAttackStartDelay()

	InGhostPlayer:SetNWBool("bAttacking", false)

	if InGhostPlayer:IsSprinting() and InGhostPlayer:GetNWFloat("EnergyValue") > 0.0 then

		if InGhostPlayer:GetNWFloat("SpectralValue") > 0.0 then

			UtilAddToFractionalNWFloat(InGhostPlayer, "SpectralValue", -SpectralValueDelta)

			OnGhostTryMaterialize(InGhostPlayer)
		else
			local EnergyValueDelta = 1.0 / UtilGetGhostAttackMaxDuration()

			UtilAddToFractionalNWFloat(InGhostPlayer, "EnergyValue", -EnergyValueDelta)

			InGhostPlayer:SetNWBool("bAttacking", true)
		end

		return
	else
		UtilAddToFractionalNWFloat(InGhostPlayer, "SpectralValue", SpectralValueDelta)
	end

	local GhostPos = InGhostPlayer:GetPos()

	local AreaPos = InGhostPlayer:GetNWVector("GhostAreaPos")

	local AreaBoundMin, AreaBoundMax = InGhostPlayer:GetNWVector("GhostAreaMin"), InGhostPlayer:GetNWVector("GhostAreaMax")

	if GhostPos:WithinAABox(AreaPos + AreaBoundMin, AreaPos + AreaBoundMax) then

		local EnergyRefillValueDelta = 0.25 / UtilGetGhostAreaEnergyRefillTime()

		UtilAddToFractionalNWFloat(InGhostPlayer, "EnergyValue", EnergyRefillValueDelta)
	else
		local EnergyDrainValueDelta = 0.25 / UtilGetGhostAreaEnergyDrainTime()

		UtilAddToFractionalNWFloat(InGhostPlayer, "EnergyValue", -EnergyDrainValueDelta)
	end
end

timer.Create("InvestigatorEnergyTick", 1.0, 0, function()

	local AllInvestigators = team.GetPlayers(TEAM_INVESTIGATOR)

	for Index, SampleInvestigator in ipairs(AllInvestigators) do

		if not SampleInvestigator:GetNWBool("bSpectator") then

			HandleInvestigatorSprintingTick(SampleInvestigator)
		end
	end
end)

timer.Create("GhostAttackTick", 0.25, 0, function()

	local AllGhosts = team.GetPlayers(TEAM_GHOST)

	for Index, SampleGhost in ipairs(AllGhosts) do

		if not SampleGhost:GetNWBool("bSpectator") then

			HandleGhostSprintingTick(SampleGhost)
		end
	end
end)
