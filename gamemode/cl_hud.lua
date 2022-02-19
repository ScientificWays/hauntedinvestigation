---- Haunted Investigation

local function TryDrawPreparePhaseInfo(InClient)

	if UtilGetCurrentGameState() == GAMESTATE_PREGAME then

		draw.SimpleText(UtilLocalizable("HI_HUD.PreparePhaseInfo"),
			"HUDText", ScrW() / 2, ScrH() - 150, COLOR_CYAN, TEXT_ALIGN_CENTER)

		return true
	end

	return false
end

function GM:HUDPaint()

	local Client = LocalPlayer()

	if Client:Team() == TEAM_UNASSIGNED or not Client:Alive() then

		return
	end

	TryDrawPreparePhaseInfo(InClient)
end
