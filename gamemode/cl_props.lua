---- Haunted Investigation

local PropSpawnPreviewModel = nil

function CreatePropSpawnPreviewModel()

	if IsValid(PropSpawnPreviewModel) then

		PropSpawnPreviewModel:Remove()
	end

	PropSpawnPreviewModel = ClientsideModel("models/props_c17/doll01.mdl", RENDERGROUP_TRANSLUCENT)
end

function GM:PreDrawOpaqueRenderables(bDrawingDepth, bDrawSkybox, bDraw3DSkybox)

	--MsgN("PreDrawOpaqueRenderables()")

	if not IsValid(PropSpawnPreviewModel) then

		return
	end

	local Client = LocalPlayer()

	local CurrentPropType = Client:GetNWInt("GhostPropType")

	local PropSpawnData = GetPropSpawnData()

	if PropSpawnData[CurrentPropType] ~= nil then

		--MsgN(PropSpawnPreviewModel)

		local RenderPos, RenderAngles, SurfaceNormal = GetGhostPropPosAnglesNormal(LocalPlayer())

		--MsgN(RenderPos)

		if RenderPos ~= nil then

			PropSpawnPreviewModel:SetModel(PropSpawnData[CurrentPropType])

			--MsgN(PropSpawnPreviewModel:GetModelRadius())

			RenderPos = RenderPos + SurfaceNormal * PropSpawnPreviewModel:GetModelRadius()

			PropSpawnPreviewModel:SetPos(RenderPos)

			PropSpawnPreviewModel:SetAngles(RenderAngles)

			PropSpawnPreviewModel:SetColor(ColorAlpha(COLOR_WHITE, 100))

			PropSpawnPreviewModel:SetNoDraw(false)
		else
			PropSpawnPreviewModel:SetNoDraw(true)
		end
	else
		PropSpawnPreviewModel:SetNoDraw(true)
	end
end
