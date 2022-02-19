---- Haunted Investigation

hook.Add("KeyPress", "GhostTeleport", function(InPlayer, InKey)

	if InPlayer:GetNWBool("SpectralValue") == 1.0 and InKey == IN_RELOAD then

		local InvestigatorPlayers = team.GetPlayers(TEAM_INVESTIGATOR)

		if not table.IsEmpty(InvestigatorPlayers) then

			local SampleTeleportPlayer = table.Random(InvestigatorPlayers)

			InPlayer:SetPos(SampleTeleportPlayer:GetPos())
		end
	end
end)
