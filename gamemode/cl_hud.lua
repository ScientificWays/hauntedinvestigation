---- Haunted Investigation

local function DrawPreparePhaseInfo(InClient)

	draw.SimpleText(UtilLocalizable("HI_HUD.PreparePhaseInfo"),
		"HUDText", ScrW() * 0.5, ScrH() - 150, COLOR_CYAN, TEXT_ALIGN_CENTER)
end

local function DrawInvestigatorHUD(InClient)

	
end

local function DrawGhostHUD(InClient)

	draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostSpectralness"), InClient:GetNWFloat("SpectralValue") * 100),
		"HUDText", 50, ScrH() - 300, COLOR_CYAN, TEXT_ALIGN_LEFT)

	draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostEnergy"), InClient:GetNWFloat("EnergyValue") * 100),
		"HUDText", 50, ScrH() - 250, COLOR_CYAN, TEXT_ALIGN_LEFT)

	local SpecialSoundText = Format(UtilLocalizable("HI_HUD.GhostSpecialSound"), InClient:GetNWInt("GhostSpecialSoundCountdown"))

	if InClient:GetNWBool("bInvestigatorNearby") then

		SpecialSoundText = SpecialSoundText.." (x2)"
	end

	draw.SimpleText(SpecialSoundText, "HUDText", 50, ScrH() - 200, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_LEFT)

	if InClient:GetNWFloat("SpectralValue") == 1.0 then

		local CurrentAlpha = (math.abs(math.sin(CurTime())) + 0.2) * 255

		if InClient:GetNWFloat("EnergyValue") == 0.0 then

			draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostAreaHint"), string.upper(input.LookupBinding("+walk"))),
				"HUDText", ScrW() * 0.5, ScrH() - 50, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_CENTER)
		end

		draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostTeleportHint"), string.upper(input.LookupBinding("+use"))),
			"HUDText", ScrW() * 0.5, ScrH() - 100, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_CENTER)

		draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostFlyHint"), string.upper(input.LookupBinding("+reload"))),
			"HUDText", ScrW() * 0.5, ScrH() - 150, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_CENTER)

		draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostAttackHint"), string.upper(input.LookupBinding("+speed"))),
			"HUDText", ScrW() * 0.5, ScrH() - 200, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_CENTER)
	end

	local SabotageRelayPos = InClient:GetNWVector("SabotageRelayPos")

	if not SabotageRelayPos:IsZero() then

		local SabotageHintText = Format(UtilLocalizable("HI_HUD.GhostSabotageHint"), string.upper(input.LookupBinding("+attack2")))

		draw.SimpleText(SabotageHintText, "HUDText", 50, ScrH() - 500, ColorAlpha(COLOR_CYAN, CurrentAlpha), TEXT_ALIGN_LEFT)
	end
end

local function DrawSpectatorHUD(InClient)

	local CurrentAlpha = (math.abs(math.sin(CurTime())) + 0.2) * 255

	local CurrentColor = ColorAlpha(COLOR_CYAN, CurrentAlpha)

	if not IsSoundInterfaceOpen() then

		local PlaySoundHintText = Format(UtilLocalizable("HI_HUD.SpectatorPlaySoundHint"), string.upper(input.LookupBinding("+use")))

		local CooldownTimeLeft = InClient:GetNWFloat("SpectatorSoundCooldownTime") - CurTime()

		if CooldownTimeLeft > 0.0 then

			PlaySoundHintText = PlaySoundHintText..Format(" (%.1f)", CooldownTimeLeft)
		end

		draw.SimpleText(PlaySoundHintText, "HUDText", ScrW() * 0.5, ScrH() - 100, CurrentColor, TEXT_ALIGN_CENTER)
	end
end

local function DrawInvestigationTimeLeft(InClient)

	draw.SimpleText(string.ToMinutesSeconds(GetGlobalInt("InvestigationTimeLeft")),
		"HUDText", ScrW() * 0.5, 100, COLOR_CYAN, TEXT_ALIGN_CENTER)
end

function GM:HUDPaint()

	local Client = LocalPlayer()

	if Client:Team() == TEAM_UNASSIGNED or not Client:Alive() then

		return
	end

	if UtilGetCurrentGameState() == GAMESTATE_PREGAME then

		DrawPreparePhaseInfo(Client)
	else
		if Client:Team() == TEAM_INVESTIGATOR then

			DrawInvestigatorHUD(Client)

		elseif Client:Team() == TEAM_GHOST then

			DrawGhostHUD(Client)

		elseif Client:Team() == TEAM_SPECTATOR then

			DrawSpectatorHUD(Client)
		end

		if UtilGetCurrentGameState() == GAMESTATE_INVESTIGATION then

			DrawInvestigationTimeLeft(InClient)
		end
	end
end
