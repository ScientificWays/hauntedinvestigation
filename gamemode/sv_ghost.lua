---- Haunted Investigation

local GhostAreaList = {}

hook.Add("KeyPress", "GhostControls", function(InPlayer, InKey)

	if InKey == IN_USE then

		TrySpawnGhostProp(InPlayer)

	elseif InKey == IN_RELOAD then

		if InPlayer:GetNWFloat("SpectralValue") == 1.0 then

			local AllInvestigators = team.GetPlayers(TEAM_INVESTIGATOR)

			if not table.IsEmpty(AllInvestigators) then

				local SampleTeleportPlayer = table.Random(AllInvestigators)

				InPlayer:SetPos(SampleTeleportPlayer:GetPos())

				InPlayer:SetNWFloat("EnergyValue", math.Clamp(InPlayer:GetNWFloat("EnergyValue") - 0.5, 0.0, 1.0))
			end
		end

	elseif InKey == IN_ATTACK2 then

		if InPlayer:GetNWFloat("SpectralValue") == 1.0 then

			TryActivateNearestSabotage(InPlayer)
		end
	end
end)

hook.Add("SetupMove", "GhostMove", function(InPlayer, InMoveData, InUserCmd)

	if InPlayer:GetNWFloat("SpectralValue") == 1.0 then

		if InMoveData:KeyDown(IN_JUMP) then

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

	MsgN(Format("Potential areas for %s: %s", FinalGhostArea, table.ToString(GoodGhostAreaList)))

	local FinalGhostArea = table.Random(GoodGhostAreaList)

	MsgN(Format("Setting %s area for %s", FinalGhostArea, InGhostPlayer))

	local AreaMin, AreaMax = FinalGhostArea:GetCollisionBounds()

	InGhostPlayer:SetNWVector("GhostAreaPos", FinalGhostArea:GetPos())

	InGhostPlayer:SetNWVector("GhostAreaMin", AreaMin)

	InGhostPlayer:SetNWVector("GhostAreaMax", AreaMax)

	FinalGhostArea.CurrentGhostCount = FinalGhostArea.CurrentGhostCount + 1

	GhostAreaCurrentMax = math.max(GhostAreaCurrentMax, FinalGhostArea.CurrentGhostCount)
end

local function UpdateGhostAreas()

	GhostAreaCurrentMin = 0

	UtilDoForPlayers(team.GetPlayers(TEAM_GHOST), function(InIndex, InPlayer)

		PickAreaForGhost(InPlayer)
	end)

	timer.Create("GhostAreaChangeTimer", UtilGetGhostAreaChangeDelay(), 1, UpdateGhostAreas)
end

function StartGhostLogic()

	timer.Create("GhostPresenceOrAttackTickTimer", 1.0, 0, GhostPresenceOrAttackTick)

	if table.IsEmpty(SabotageRelayList) then

		MsgN("Warning! SabotageRelayList is empty for this map. Consider adding logic_relay with _GhostSabotage postfix!")
	else
		timer.Create("NearestSabotageUpdate", 1.41, 0, UpdateNearestSabotageForGhosts)
	end

	timer.Create("GhostPropsTickTimer", 1.19, 0, UpdateGhostProps)

	UpdateGhostAreas()
end

function StopGhostLogic()

	timer.Remove("GhostPresenceOrAttackTickTimer")

	timer.Remove("NearestSabotageUpdate")

	timer.Remove("GhostPropsTickTimer")

	timer.Remove("GhostAreaChangeTimer")

	UtilDoForPlayers(team.GetPlayers(TEAM_GHOST), function(InIndex, InPlayer)

		InPlayer:SetNWInt("GhostPropType", -1)
	end)
end

function GhostPresenceOrAttackTick()

	UtilDoForPlayers(team.GetPlayers(TEAM_GHOST), function(InIndex, InGhost)

		local GhostPos = InGhost:GetPos()

		UtilDoForPlayers(team.GetPlayers(TEAM_INVESTIGATOR), function(InInvestigatorIndex, InInvestigator)

			local InvestigatorPos = InInvestigator:GetPos()

			if math.abs(GhostPos.z - InvestigatorPos.z) < 256.0 then

				InvestigatorPresenceTick(InInvestigator, InGhost, math.DistanceSqr(GhostPos.x, GhostPos.y, InvestigatorPos.x, InvestigatorPos.y) < math.pow(UtilGetGhostPresenceRadius(), 2))
			else
				InvestigatorPresenceTick(InInvestigator, InGhost, false)
			end

			if InGhost:GetNWBool("bAttacking") then

				InvestigatorAttackedTick(InInvestigator, InGhost, GhostPos:DistToSqr(InvestigatorPos) < math.pow(UtilGetGhostAttackRadius(), 2))

				TryAddAttackTrail(InGhost, InInvestigator)
			else
				TryRemoveAttackTrail(InGhost, InInvestigator)
			end
		end)

		if not InGhost:GetNWBool("bAttacking") then

			TryStopGhostAttackLoopSound(InGhost)

			if InGhost:GetNWFloat("GhostBloomTime") > 0.0 then

				InGhost:SetNWFloat("GhostBloomTime", InGhost:GetNWFloat("GhostBloomTime") - 1.0)

			elseif math.random() < 0.04 then

				InGhost:SetNWFloat("GhostBloomTime", 5.0)

				MsgN(Format("%s is now with ghost bloom for 5 seconds!", InGhost))
			end
		end
	end)
end

function TryAddAttackTrail(InGhost, InInvestigator)

	if InGhost.AttackedSpriteTrail == nil then

		InGhost.AttackedSpriteTrail = util.SpriteTrail(InGhost, 0, COLOD_WHITE, false, 32, 16, 1.0, 0.2, "trails/plasma")

		MsgN("Add attack trail")
	end
end

function TryRemoveAttackTrail(InGhost, InInvestigator)

	if InGhost.AttackedSpriteTrail ~= nil then

		InGhost.AttackedSpriteTrail:Remove()

		InGhost.AttackedSpriteTrail = nil

		MsgN("Remove attack trail")
	end
end

function InvestigatorPresenceTick(InInvestigator, InGhost, bPresence)

	InInvestigator:SetNWBool("bChargedGhostNearby", bPresence and InGhost:GetNWFloat("EnergyValue") > 0.0)

	InGhost:SetNWBool("bInvestigatorNearby", bPresence)
end

function InvestigatorAttackedTick(InInvestigator, InGhost, bNewState)

	local bOldState = InInvestigator:GetNWBool("bAttackedByGhost")

	InInvestigator:SetNWBool("bAttackedByGhost", bNewState)

	if bOldState == false and bNewState == true then

		MsgN(InGhost.AttackedSpriteTrail)

		if IsValid(InGhost.AttackedSpriteTrail) then

			InGhost.AttackedSpriteTrail:Remove()
		end

		InGhost.AttackedSpriteTrail = util.SpriteTrail(InGhost, 1, COLOD_WHITE, false, 32, 4, 2.0, 0.5, "trails/plasma")

		timer.Simple(math.Rand(0.0, 2.0), function()

			RandomizeTalkieFrequency(InInvestigator)
		end)

	elseif bOldState == true and bNewState == false then

		
	end

	if bNewState then

		TryStartGhostAttackLoopSound(InGhost, InInvestigator)

		ApplyDamage = DamageInfo()

		ApplyDamage:SetAttacker(InGhost)

		ApplyDamage:SetDamageType(DMG_POISON)

		ApplyDamage:SetDamage(UtilGetGhostAttackDamage())

		InInvestigator:TakeDamageInfo(ApplyDamage)

		InInvestigator:ScreenFade(SCREENFADE.IN, ColorAlpha(COLOR_RED, 200), 1.0, 0.0)

		MsgN(Format("%s attacked, health now is %i", InInvestigator, InInvestigator:Health()))
	else
		TryStopGhostAttackLoopSound(InGhost)
	end
end
