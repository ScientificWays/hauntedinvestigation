---- Haunted Investigation

local IconRuby						= Material("icon16/ruby.png")
local IconMonitor					= Material("icon16/monitor.png")

timer.Create("HUDHintDataTick", 0.2, 0, function()

	ResetHUDHintData()

	local ClientPlayer = LocalPlayer()

	if not IsValid(ClientPlayer) then

		return
	end

	local EyeTrace = ClientPlayer:GetEyeTrace()

	if EyeTrace.Fraction * 32768 > 128 or not IsValid(EyeTrace.Entity) then

		return
	end

	--MsgN(EyeTrace.Entity:GetCollisionGroup())

	UpdateHUDHintData(ClientPlayer, EyeTrace.Entity)
end)

function ResetHUDHintData()

	--MsgN("ResetHUDHintData()")

	--Default size and color defined here
	HUDHintData = {Icon = nil, IconColor = COLOR_WHITE, IconSize = {x = 32, y = 32}, Text = nil}
end

local function SetHUDHintDataCodeInfo()

	MsgN("SetHUDHintDataCodeInfo()")

	HUDHintData.Icon = IconMonitor

	HUDHintData.IconColor = COLOR_WHITE

	HUDHintData.Text = GetGlobalInt("InvestigationCode")
end

local function SetHUDHintDataCodeKeypad()

	--MsgN("SetHUDHintDataCodeKeypad()")

	HUDHintData.Icon = IconCalculator

	HUDHintData.IconColor = COLOR_WHITE

	HUDHintData.Text = UtilLocalizable("HI_HUD.Input")
end

local function SetHUDHintDataArtifact()

	--MsgN("SetHUDHintDataArtifact()")

	HUDHintData.Icon = IconRuby

	HUDHintData.IconColor = COLOR_WHITE

	HUDHintData.Text = UtilLocalizable("HI_HUD.Artifact")
end

function UpdateHUDHintData(InClient, InTargetEntity)

	--MsgN(InTargetEntity)

	if not InTargetEntity:GetNWBool("bShowHint") and not InTargetEntity:IsPlayer() then

		local TargetEntityParent = InTargetEntity:GetParent()

		if IsValid(TargetEntityParent) and TargetEntityParent:GetNWBool("bShowHint") then

			UpdateHUDHintData(InPlayer, TargetEntityParent)
		end

		return
	end

	if InClient:Team() == TEAM_INVESTIGATOR then

		if InTargetEntity:GetNWBool("bCodeInfo") then

			SetHUDHintDataCodeInfo()

		elseif InTargetEntity:GetNWBool("bCodeKeypad") then

			SetHUDHintDataCodeKeypad()

		elseif InTargetEntity:GetNWBool("bArtifact") then

			SetHUDHintDataArtifact()
		end
	end
end

local function TryDrawHUDHint()

	if HUDHintData.Icon then

		surface.SetMaterial(HUDHintData.Icon)

		surface.SetDrawColor(HUDHintData.IconColor)

		surface.DrawTexturedRect(ScrW() * 0.5 - HUDHintData.IconSize.x * 0.5,
			ScrH() * 0.5 - HUDHintData.IconSize.y * 0.5,
			HUDHintData.IconSize.x, HUDHintData.IconSize.y)
	end

	if HUDHintData.Text then

		draw.DrawText(HUDHintData.Text, "HUDTextSmall", ScrW() * 0.5, ScrH() * 0.5 + 16, COLOR_YELLOW, TEXT_ALIGN_CENTER)
	end
end

local function DrawPreparePhaseInfo(InClient)

	draw.SimpleText(UtilLocalizable("HI_HUD.PreparePhaseInfo"),
		"HUDText", ScrW() * 0.5, ScrH() - 150, COLOR_CYAN, TEXT_ALIGN_CENTER)
end

local function DrawEndGameInfo(InClient)

	draw.SimpleText(UtilLocalizable("HI_HUD.EndGameInfo"),
		"HUDText", ScrW() * 0.5, ScrH() - 150, COLOR_CYAN, TEXT_ALIGN_CENTER)
end

local function DrawInvestigatorHUD(InClient)

	draw.SimpleText(Format(UtilLocalizable("HI_HUD.Energy"), InClient:GetNWFloat("EnergyValue") * 100),
		"HUDTextSmall", 50, ScrH() - 150, COLOR_YELLOW, TEXT_ALIGN_LEFT)

	draw.SimpleText(Format(UtilLocalizable("HI_HUD.TalkieFrequency"), InClient:GetNWFloat("TalkieFrequency")),
		"HUDTextSmall", 200, ScrH() - 150, COLOR_YELLOW, TEXT_ALIGN_LEFT)
end

local function DrawGhostHUD(InClient)

	draw.SimpleText(Format(UtilLocalizable("HI_HUD.Energy"), InClient:GetNWFloat("EnergyValue") * 100),
		"HUDTextSmall", 50, ScrH() - 150, COLOR_CYAN, TEXT_ALIGN_LEFT)

	draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostSpectralness"), InClient:GetNWFloat("SpectralValue") * 100),
		"HUDTextSmall", 200, ScrH() - 150, COLOR_CYAN, TEXT_ALIGN_LEFT)

	local CurrentColor = ColorAlpha(COLOR_CYAN, CurrentAlpha)

	if InClient:GetNWFloat("EnergyValue") > 0.0 then

		local SpecialSoundText = Format(UtilLocalizable("HI_HUD.GhostSpecialSound"), InClient:GetNWInt("GhostSpecialSoundCountdown"))

		if InClient:GetNWBool("bInvestigatorNearby") then

			SpecialSoundText = SpecialSoundText.." (x2)"
		end

		draw.SimpleText(SpecialSoundText, "HUDTextSmall", 50, ScrH() - 180, CurrentColor, TEXT_ALIGN_LEFT)
	end

	if InClient:GetNWFloat("SpectralValue") == 1.0 then

		local CurrentAlpha = (math.abs(math.sin(CurTime())) + 0.2) * 255

		if InClient:GetNWFloat("EnergyValue") == 0.0 then

			draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostAreaHint"), string.upper(input.LookupBinding("+walk"))),
				"HUDTextSmall", ScrW() * 0.5, ScrH() - 50, CurrentColor, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostTeleportHint"), string.upper(input.LookupBinding("+reload"))),
			"HUDTextSmall", ScrW() * 0.5, ScrH() - 80, CurrentColor, TEXT_ALIGN_CENTER)

		draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostFlyHint"), string.upper(input.LookupBinding("+jump"))),
			"HUDTextSmall", ScrW() * 0.5, ScrH() - 110, CurrentColor, TEXT_ALIGN_CENTER)

		draw.SimpleText(Format(UtilLocalizable("HI_HUD.GhostAttackHint"), string.upper(input.LookupBinding("+speed"))),
			"HUDTextSmall", ScrW() * 0.5, ScrH() - 140, CurrentColor, TEXT_ALIGN_CENTER)

		local CurrentPropType = InClient:GetNWInt("GhostPropType")

		local PropSpawnData = GetPropSpawnData()

		local PropCooldownTimeLeft = InClient:GetNWFloat("GhostPropCooldownTime") - CurTime()

		if PropSpawnData[CurrentPropType] ~= nil or PropCooldownTimeLeft > 0.0 then

			local PropHintText = Format(UtilLocalizable("HI_HUD.GhostPropHint"), string.upper(input.LookupBinding("+use")))

			if PropCooldownTimeLeft > 0.0 then

				PropHintText = PropHintText..Format(" (%.1f)", PropCooldownTimeLeft)
			end

			draw.SimpleText(PropHintText, "HUDTextSmall", ScrW() * 0.5, ScrH() - 170, CurrentColor, TEXT_ALIGN_CENTER)
		end
	end

	local SabotageRelayPos = InClient:GetNWVector("SabotageRelayPos")

	if not SabotageRelayPos:IsZero() then

		local SabotageHintText = Format(UtilLocalizable("HI_HUD.GhostSabotageHint"), string.upper(input.LookupBinding("+attack2")))

		draw.SimpleText(SabotageHintText, "HUDText", ScrW() * 0.5, ScrH() - 250, CurrentColor, TEXT_ALIGN_CENTER)
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

		draw.SimpleText(PlaySoundHintText, "HUDTextSmall", ScrW() * 0.5, ScrH() - 100, CurrentColor, TEXT_ALIGN_CENTER)
	end
end

local function DrawInvestigationTimeLeft(InClient)

	draw.SimpleText(string.ToMinutesSeconds(GetGlobalInt("InvestigationTimeLeft")),
		"HUDText", ScrW() * 0.5, 100, COLOR_CYAN, TEXT_ALIGN_CENTER)
end

local WallhackMaterial = CreateMaterial("WallhackMaterial", "VertexLitGeneric", {
	["$basetexture"] = "skybox/sky_fake_white",
	["$model"] = 1,
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1
})

function GM:HUDPaint()

	local Client = LocalPlayer()

	if Client:Team() == TEAM_UNASSIGNED or not Client:Alive() then

		return
	end

	if UtilGetCurrentGameState() == GAMESTATE_PREGAME then

		DrawPreparePhaseInfo(Client)

	elseif UtilGetCurrentGameState() == GAMESTATE_POSTGAME then

		DrawEndGameInfo(Client)
	else
		if Client:Team() == TEAM_INVESTIGATOR then

			DrawInvestigatorHUD(Client)

		elseif Client:Team() == TEAM_GHOST then

			DrawGhostHUD(Client)


		elseif Client:Team() == TEAM_SPECTATOR then

			DrawSpectatorHUD(Client)
		end

		if UtilGetCurrentGameState() == GAMESTATE_INVESTIGATION and GetGlobalInt("InvestigationTimeLeft") > 0.0 then

			DrawInvestigationTimeLeft(InClient)
		end

		TryDrawHUDHint()
	end

	--[[if Client:Team() ~= TEAM_INVESTIGATOR then

		UtilDoForPlayers(player.GetAll(), function(InIndex, InPlayer)

			if InPlayer:Team() == TEAM_GHOST
				or (InPlayer:Team() == TEAM_INVESTIGATOR and InPlayer:GetNWFloat("EnergyValue") <= 1.0) then

				cam.Start3D2D()

				draw.DrawText(InPlayer:GetName(), "HUDText", 2, 2, team.GetColor(InPlayer:Team()), TEXT_ALIGN_CENTER)

				InPlayer:DrawModel()
				
				cam.End3D2D()
			end
		end)
	end--]]
end
