---- Haunted Investigation

local PropSpawnData = {
	[1] = Model("models/props_junk/wood_crate001a.mdl"),
	[2] = Model("models/props_junk/wood_crate002a.mdl"),
	[3] = Model("models/props_junk/wood_pallet001a.mdl"),
	[4] = Model("models/props_c17/oildrum001.mdl"),
	[5] = Model("models/props_c17/oildrum001_explosive.mdl"),
	[6] = Model("models/props_phx/oildrum001.mdl"),
	[7] = Model("models/props_phx/oildrum001_explosive.mdl"),
	[8] = Model("models/props_junk/gascan001a.mdl"),
	[9] = Model("models/props_junk/plasticbucket001a.mdl"),
	[10] = Model("models/props_junk/plasticcrate01a.mdl"),
	[11] = Model("models/props_junk/propane_tank001a.mdl"),
	[12] = Model("models/props_junk/watermelon01.mdl"),
	[13] = Model("models/props_wasteland/prison_toilet01.mdl"),
	[14] = Model("models/props_c17/doll01.mdl")
}

function GetPropSpawnData()

	return PropSpawnData
end

function GetGhostPropPosAnglesNormal(InPlayer)

	local EyeTrace = InPlayer:GetEyeTrace()

	if EyeTrace.Fraction * 32768 > 256 then

		--MsgN("Eye trace was too far!")

		return nil, nil, nil
	end

	local RenderPos = EyeTrace.HitPos

	local RenderAngles = EyeTrace.HitNormal:AngleEx(Vector(0, 0, 1))

	RenderAngles.pitch = RenderAngles.pitch + 90

	return RenderPos, RenderAngles, EyeTrace.HitNormal
end
