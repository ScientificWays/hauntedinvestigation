---- Haunted Investigation

local function DrawPreparePhaseInfo(InClient)

	draw.SimpleText(UtilLocalizable("HI_HUD.PreparePhaseInfo"),
		"HUDText", ScrW() / 2, ScrH() - 150, COLOR_CYAN, TEXT_ALIGN_CENTER)
end

local function DrawGhostHUD(InClient)

	draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostSpectralness"), InClient:GetNWFloat("SpectralValue") * 100),
		"HUDText", 50, ScrH() - 300, COLOR_CYAN, TEXT_ALIGN_LEFT)

	draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostEnergy"), InClient:GetNWFloat("EnergyValue") * 100),
		"HUDText", 50, ScrH() - 250, COLOR_CYAN, TEXT_ALIGN_LEFT)

	local SpecialSoundText = Format(UtilLocalizable("HI_HUD.GhostSpecialSound"), InClient:GetNWInt("GhostSpecialSoundCountdown"))

	if InClient:GetNWBool("bInvestigatorNearby") then

		SpecialSoundText = table.concat({SpecialSoundText, "(x2)"}, " ")
	end

	draw.SimpleText(SpecialSoundText, "HUDText", 50, ScrH() - 200, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_LEFT)

	if InClient:GetNWFloat("SpectralValue") == 1.0 then

		local CurrentAlpha = (math.abs(math.sin(CurTime())) + 0.2) * 255

		if InClient:GetNWFloat("EnergyValue") == 0.0 then

			draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostAreaHint"), string.upper(input.LookupBinding("+walk"))),
				"HUDText", ScrW() / 2, ScrH() - 50, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_CENTER)
		end

		draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostTeleportHint"), string.upper(input.LookupBinding("+use"))),
			"HUDText", ScrW() / 2, ScrH() - 100, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_CENTER)

		draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostFlyHint"), string.upper(input.LookupBinding("+reload"))),
			"HUDText", ScrW() / 2, ScrH() - 150, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_CENTER)

		draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostAttackHint"), string.upper(input.LookupBinding("+speed"))),
			"HUDText", ScrW() / 2, ScrH() - 200, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_CENTER)
	end
end

function GM:HUDPaint()

	local Client = LocalPlayer()

	if Client:Team() == TEAM_UNASSIGNED or not Client:Alive() then

		return
	end

	if UtilGetCurrentGameState() == GAMESTATE_PREGAME then

		DrawPreparePhaseInfo(Client)
	else
		if Client:Team() == TEAM_GHOST then

			DrawGhostHUD(Client)
		end
	end
end
