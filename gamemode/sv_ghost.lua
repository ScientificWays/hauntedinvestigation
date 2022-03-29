---- Haunted Investigation

GhostAreaList = {}

hook.Add("KeyPress", "GhostTeleport", function(InPlayer, InKey)

	if InPlayer:GetNWFloat("SpectralValue") == 1.0 and InKey == IN_USE then

		local AllInvestigators = team.GetPlayers(TEAM_INVESTIGATOR)

		if not table.IsEmpty(AllInvestigators) then

			local SampleTeleportPlayer = table.Random(AllInvestigators)

			InPlayer:SetPos(SampleTeleportPlayer:GetPos())

			InPlayer:SetNWFloat("EnergyValue", InPlayer:GetNWFloat("EnergyValue") * 0.5)
		end
	end
end)

hook.Add("SetupMove", "GhostMove", function(InPlayer, InMoveData, InUserCmd)

	if InPlayer:GetNWFloat("SpectralValue") == 1.0 then

		if InMoveData:KeyDown(IN_RELOAD) then

			local OldVelocity = InMoveData:GetVelocity()

			InMoveData:SetVelocity(Vector(OldVelocity.x, OldVelocity.y, 280))
		end

	elseif (InPlayer.DamageSlowEndTime or 0.0) > CurTime() then

		InMoveData:SetMaxClientSpeed(100)
	else
		InMoveData:SetMaxClientSpeed(200)
	end
end)

function SetGhostAreaList(InAreaList)

	GhostAreaList = InAreaList
end

local GhostAreaCurrentMax = 0

function PickAreaForGhost(InGhostPlayer)

	local GoodGhostAreaList = {}

	for Index, SampleGhostArea in ipairs(GhostAreaList) do

		SampleGhostArea.CurrentGhostCount = SampleGhostArea.CurrentGhostCount or 0

		if SampleGhostArea.CurrentGhostCount < GhostAreaCurrentMax then

			table.insert(GoodGhostAreaList, SampleGhostArea)
		end
	end

	if table.IsEmpty(GoodGhostAreaList) then

		GoodGhostAreaList = GhostAreaList
	end

	local FinalGhostArea = table.Random(GoodGhostAreaList)

	local AreaMin, AreaMax = FinalGhostArea:GetCollisionBounds()

	InGhostPlayer:SetNWVector("GhostAreaPos", FinalGhostArea:GetPos())

	InGhostPlayer:SetNWVector("GhostAreaMin", AreaMin)

	InGhostPlayer:SetNWVector("GhostAreaMax", AreaMax)

	FinalGhostArea.CurrentGhostCount = FinalGhostArea.CurrentGhostCount + 1

	GhostAreaCurrentMax = math.max(GhostAreaCurrentMax, FinalGhostArea.CurrentGhostCount)

	MsgN(Format("Setting %s area for %s", FinalGhostArea, InGhostPlayer))
end

local function UpdateGhostAreas()

	GhostAreaCurrentMin = 0

	--[[local AllGhosts = team.GetPlayers(TEAM_GHOST)

	for Index, SampleGhost in ipairs(AllGhosts) do

		PickAreaForGhost(SampleGhost)
	end--]]

	timer.Create("GhostAreaChangeTimer", UtilGetGhostAreaChangeDelay(), 1, UpdateGhostAreas)
end

function StartGhostLogic()

	timer.Create("GhostPresenceOrAttackTickTimer", 1.0, 0, GhostPresenceOrAttackTick)

	UpdateGhostAreas()
end

function StopGhostLogic()

	timer.Remove("GhostPresenceOrAttackTickTimer")

	timer.Remove("GhostAreaChangeTimer")
end

function GhostPresenceOrAttackTick()

	local AllGhosts = team.GetPlayers(TEAM_GHOST)

	for GhostIndex, GhostPlayer in ipairs(AllGhosts) do

		local GhostPos = GhostPlayer:GetPos()

		local AllInvestigators = team.GetPlayers(TEAM_INVESTIGATOR)

		for InvestigatorIndex, InvestigatorPlayer in ipairs(AllInvestigators) do

			local InvestigatorPos = InvestigatorPlayer:GetPos()

			if math.abs(GhostPos.z - InvestigatorPos.z) < 256.0 then

				InvestigatorPresenceTick(InvestigatorPlayer, GhostPlayer, math.DistanceSqr(GhostPos.x, GhostPos.y, InvestigatorPos.x, InvestigatorPos.y) < math.pow(UtilGetGhostPresenceRadius(), 2))
			end

			if GhostPlayer:GetNWBool("bAttacking") then

				InvestigatorAttackedTick(InvestigatorPlayer, GhostPlayer, GhostPos:DistToSqr(InvestigatorPos) < math.pow(UtilGetGhostAttackRadius(), 2))
			end
		end

		if not GhostPlayer:GetNWBool("bAttacking") then

			TryStopGhostAttackLoopSound(GhostPlayer)

			if GhostPlayer:GetNWFloat("GhostBloomTime") > 0.0 then

				GhostPlayer:SetNWFloat("GhostBloomTime", GhostPlayer:GetNWFloat("GhostBloomTime") - 1.0)

			elseif math.random() < 0.04 then

				GhostPlayer:SetNWFloat("GhostBloomTime", 5.0)

				MsgN(Format("%s is now with ghost bloom for 5 seconds!", GhostPlayer))
			end
		end
	end
end

function InvestigatorPresenceTick(InInvestigator, InGhost, bPresence)

	InInvestigator:SetNWBool("bGhostNearby", bPresence)

	InGhost:SetNWBool("bInvestigatorNearby", bPresence)
end

function InvestigatorAttackedTick(InInvestigator, InGhost, bNewState)

	local bOldState = InInvestigator:GetNWBool("bAttackedByGhost")

	InInvestigator:SetNWBool("bAttackedByGhost", bNewState)

	if bOldState == false and bNewState == true then

		timer.Simple(math.Rand(1.0, 3.0), InInvestigator:SteamID(), function()

			RandomizeTalkieFrequency(InInvestigator)
		end)

	elseif bOldState == false and bNewState == true then



	end

	if bNewState then

		TryStartGhostAttackLoopSound(InGhost, InInvestigator)

		ApplyDamage = DamageInfo()

		ApplyDamage:SetAttacker(InGhost)

		ApplyDamage:SetDamageType(DMG_POISON)

		ApplyDamage:SetDamage(UtilGetGhostAttackDamage())

		InInvestigator:TakeDamageInfo(ApplyDamage)

		--MsgN(Format("%s attacked, health now is %i", InInvestigator, InInvestigator:Health()))
	else
		TryStopGhostAttackLoopSound(InGhost)
	end
end

function GM:PlayerHurt(InVictimPlayer, InAttackerEntity, InHealthRemaining, InDamageTaken)

	UpdatePlayersHealthValue()

	if InVictimPlayer:Team() == TEAM_GHOST and InAttackerEntity:IsPlayer() then

		InVictimPlayer:SetNWFloat("DamageSlowTime", 2.0)
	end
end

timer.Create("DamageSlowUpdate", 0.5, 0, function()

	local AllPlayers = player.GetAll()

	for Index, SamplePlayer in ipairs(AllPlayers) do

		if SamplePlayer:GetNWFloat("DamageSlowTime") > 0.5 then

			SamplePlayer:SetNWFloat("DamageSlowTime", SamplePlayer:GetNWFloat("DamageSlowTime") - 0.5)

		else
			SamplePlayer:SetNWFloat("DamageSlowTime", 0.0)
		end
	end
end)
