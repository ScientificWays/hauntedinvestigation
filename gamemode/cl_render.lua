---- Haunted Investigation

local GhostMaterial = CreateMaterial("GhostMaterial", "VertexLitGeneric", {
	["$basetexture"] = "tools/toolsblack",
	["$model"] = 1,
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1
})

local OldSpectralValue = 0.0

local LerpPresenceValue = 0.0
local OldLerpPresenceValue = 0.0

timer.Create("PostProcessUpdate", 0.2, 0, function()

	local Client = LocalPlayer()

	if not IsValid(Client) then

		return
	end

	if Client:Team() == TEAM_INVESTIGATOR then

		if Client:GetNWBool("bGhostNearby") then

			LerpPresenceValue = Lerp(FrameTime() * 0.4, LerpPresenceValue, 1.0)

		else

			LerpPresenceValue = Lerp(FrameTime() * 0.4, LerpPresenceValue, 0.0)
		end

		if math.abs(LerpPresenceValue - OldLerpPresenceValue) > 0.01 then

			Client:ConCommand(Format("pp_motionblur_addalpha %f", Lerp(LerpPresenceValue, 1.0, 0.4)))
			Client:ConCommand(Format("pp_motionblur_drawalpha %f", Lerp(LerpPresenceValue, 1.0, 1.0)))
			Client:ConCommand(Format("pp_motionblur_delay %f", Lerp(LerpPresenceValue, 0.0, 0.02)))

			OldLerpPresenceValue = LerpPresenceValue

			--MsgN(OldLerpPresenceValue)
		end

	elseif Client:Team() == TEAM_GHOST then

		local SpectralValue = Client:GetNWFloat("SpectralValue")

		if SpectralValue ~= OldSpectralValue then

			Client:ConCommand(Format("pp_colormod_addg %f", Lerp(SpectralValue, 0, 20)))

			Client:ConCommand(Format("pp_colormod_addb %f", Lerp(SpectralValue, 0, 20)))

			Client:ConCommand(Format("pp_colormod_brightness %f", Lerp(SpectralValue, 0.0, -0.4)))
		end
	end
end)

hook.Add("Think", "NightVision", function()

	local Client = LocalPlayer()

	if Client:GetNWBool("bRenderLight") or Client:GetNWBool("bSpectator") then

		local DynamicLight = DynamicLight(Client:EntIndex())

		if DynamicLight then

			DynamicLight.pos = Client:EyePos()

			DynamicLight.r = 25

			DynamicLight.g = 25

			DynamicLight.b = 25

			DynamicLight.brightness = 1

			DynamicLight.Decay = 1000

			DynamicLight.Size = 2048

			DynamicLight.DieTime = CurTime() + 1
		end
	end
end)

hook.Add("PostDrawTranslucentRenderables", "GhostAreaDraw", function()

	local Client = LocalPlayer()

	if Client:Team() == TEAM_GHOST and Client:KeyDown(IN_WALK) then

		local AreaPos = Client:GetNWVector("GhostAreaPos")

		local Min, Max = AreaPos + Client:GetNWVector("GhostAreaMin"), AreaPos + Client:GetNWVector("GhostAreaMax")

		if not Min:IsZero() or not Max:IsZero() then

			local Color = ColorAlpha(COLOR_CYAN, (math.sin(CurTime() * 3) + 1.0) * 128)

			render.DrawLine(Vector(Min.x, Min.y, Min.z), Vector(Min.x, Min.y, Max.z), Color)

			render.DrawLine(Vector(Min.x, Max.y, Min.z), Vector(Min.x, Max.y, Max.z), Color)
			
			render.DrawLine(Vector(Max.x, Min.y, Min.z), Vector(Max.x, Min.y, Max.z), Color)
			
			render.DrawLine(Vector(Max.x, Max.y, Min.z), Vector(Max.x, Max.y, Max.z), Color)
			----
			render.DrawLine(Vector(Min.x, Min.y, Min.z), Vector(Min.x, Max.y, Min.z), Color)

			render.DrawLine(Vector(Min.x, Min.y, Min.z), Vector(Max.x, Min.y, Min.z), Color)

			render.DrawLine(Vector(Max.x, Max.y, Min.z), Vector(Min.x, Max.y, Min.z), Color)

			render.DrawLine(Vector(Max.x, Max.y, Min.z), Vector(Max.x, Min.y, Min.z), Color)
			----
			render.DrawLine(Vector(Min.x, Min.y, Max.z), Vector(Min.x, Max.y, Max.z), Color)

			render.DrawLine(Vector(Min.x, Min.y, Max.z), Vector(Max.x, Min.y, Max.z), Color)

			render.DrawLine(Vector(Max.x, Max.y, Max.z), Vector(Min.x, Max.y, Max.z), Color)

			render.DrawLine(Vector(Max.x, Max.y, Max.z), Vector(Max.x, Min.y, Max.z), Color)
		end
	end
end)

local SabotageIconMaterial = Material("icon16/drive_error.png", "ignorez")

hook.Add("PostDrawTranslucentRenderables", "SabotageIconDraw", function()

	local Client = LocalPlayer()

	if Client:Team() == TEAM_GHOST then

		local SabotagePos = Client:GetNWVector("SabotageRelayPos")

		--MsgN(SabotagePos)

		if not SabotagePos:IsZero() then

			render.SetMaterial(SabotageIconMaterial)

			render.DrawSprite(SabotagePos, 16.0, 16.0, COLOR_WHITE)
		end
	end
end)

local GhostBloomMaterial = Material("hauntedinvestigation/ghostbloom")

local GhostBloomColor	= Color(50, 50, 50)

function GM:PrePlayerDraw(InPlayer, InFlags)

	local Client = LocalPlayer()

	if Client:Team() == TEAM_INVESTIGATOR and InPlayer:Team() == TEAM_GHOST then

		if InPlayer:GetNWFloat("SpectralValue") > 0.0 then

			if InPlayer:GetNWFloat("GhostBloomTime") > 0.0 then

				render.SetMaterial(GhostBloomMaterial)

				render.DrawSprite(InPlayer:GetPos() + Vector(0.0, 0.0, 48.0), 256.0, 256.0, GhostBloomColor)
			end

			return true
		end
	end

	return false
end
