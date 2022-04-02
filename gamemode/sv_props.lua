---- Haunted Investigation

function UpdateGhostProps()

	if GetGlobalInt("CurrentGameState") ~= GAMESTATE_INVESTIGATION then

		return
	end

	UtilDoForPlayers(team.GetPlayers(TEAM_GHOST), function(InIndex, InPlayer)

		local bGhostVisible = false

		UtilDoForPlayers(team.GetPlayers(TEAM_INVESTIGATOR), function(InIndex, InInvestigatorPlayer)

			if InPlayer:Visible(InInvestigatorPlayer) then

				bGhostVisible = true

				return
			end
		end)

		--MsgN(Format("%s visibility is %s", InPlayer, bGhostVisible))

		if bGhostVisible or InPlayer:GetNWFloat("GhostPropCooldownTime") > CurTime() then

			InPlayer:SetNWInt("GhostPropType", -1)
		else
			local PropSpawnData = GetPropSpawnData()

			if PropSpawnData[InPlayer:GetNWInt("GhostPropType")] == nil then

				InPlayer:SetNWInt("GhostPropType", math.random(#PropSpawnData))

				MsgN(Format("%s CurrentPropType is %s", InPlayer, InPlayer:GetNWInt("GhostPropType")))
			end
		end
	end)
end

function TrySpawnGhostProp(InPlayer)

	local PropSpawnData = GetPropSpawnData()

	local CurrentPropType = InPlayer:GetNWInt("GhostPropType")

	if PropSpawnData[CurrentPropType] ~= nil then

		local SpawnPos, SpawnAngles, SurfaceNormal = GetGhostPropPosAnglesNormal(InPlayer)

		if SpawnPos ~= nil then

			local SpawnedEntity = ents.Create("prop_physics")

			SpawnedEntity:SetModel(PropSpawnData[CurrentPropType])

			SpawnPos = SpawnPos + SurfaceNormal * SpawnedEntity:GetModelRadius()

			SpawnedEntity:SetPos(SpawnPos)

			SpawnedEntity:SetAngles(SpawnAngles)

			SpawnedEntity:Spawn()

			InPlayer:SetNWInt("GhostPropType", -1)

			InPlayer:SetNWFloat("GhostPropCooldownTime", CurTime() + UtilGetGhostPropCooldown())
		end
	end
end
