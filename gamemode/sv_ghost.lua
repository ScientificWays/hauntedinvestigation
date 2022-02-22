---- Haunted Investigation

GhostAreaList = {}

hook.Add("KeyPress", "GhostTeleport", function(InPlayer, InKey)

	if InPlayer:GetNWFloat("SpectralValue") == 1.0 and InKey == IN_USE then

		local AllInvestigators = team.GetPlayers(TEAM_INVESTIGATOR)

		if not table.IsEmpty(AllInvestigators) then

			local SampleTeleportPlayer = table.Random(AllInvestigators)

			InPlayer:SetPos(SampleTeleportPlayer:GetPos())
		end
	end
end)

hook.Add("SetupMove", "GhostMove", function(InPlayer, InMoveData, InUserCmd)

	if InPlayer:GetNWFloat("SpectralValue") == 1.0 then

		if InMoveData:KeyDown(IN_RELOAD) then

			local OldVelocity = InMoveData:GetVelocity()

			InMoveData:SetVelocity(Vector(OldVelocity.x, OldVelocity.y, 280))
		end
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

function StartUpdateGhostAreas()

	UpdateGhostAreas()
end

function StopUpdateGhostAreas()

	timer.Remove("GhostAreaChangeTimer")
end

timer.Create("GhostPresenceOrAttackTick", 1.0, 0, function()

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
		end
	end
end)

function InvestigatorPresenceTick(InInvestigator, InGhost, bPresence)

	InInvestigator:SetNWBool("bGhostNearby", bPresence)

	InGhost:SetNWBool("bInvestigatorNearby", bPresence)
end

function InvestigatorAttackedTick(InInvestigator, InGhost, bNewState)

	local bOldState = InInvestigator:GetNWBool("bAttackedByGhost")

	InInvestigator:SetNWBool("bAttackedByGhost", bNewState)

	--[[if bOldState == false and bNewState == true then



	elseif bOldState == false and bNewState == true then



	end--]]

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
