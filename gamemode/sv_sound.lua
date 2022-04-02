---- Haunted Investigation

local GhostAttackSoundList = {
	"hauntedinvestigation/ghostattack001a.wav",
	"hauntedinvestigation/ghostattack002a.wav",
	"hauntedinvestigation/ghostattack003a.wav",
	"hauntedinvestigation/ghostattack004a.wav",
	"ambient/levels/citadel/zapper_warmup1.wav",
	"ambient/levels/citadel/zapper_warmup4.wav"
}

local GhostNearbySoundList = {
	"hauntedinvestigation/ghostnearby001a.wav",
	"hauntedinvestigation/ghostnearby002a.wav",
	"hauntedinvestigation/ghostnearby003a.wav",
	"hauntedinvestigation/ghostnearby004a.wav",
	"hauntedinvestigation/ghostnearby005a.wav",
	"hauntedinvestigation/ghostnearby006a.wav",
	"hauntedinvestigation/ghostnearby007a.wav"
}

local GhostRandomSoundList = {
	"hauntedinvestigation/ghostrandom001a.wav",
	"hauntedinvestigation/ghostrandom002a.wav",
	"hauntedinvestigation/ghostrandom003a.wav",
	"hauntedinvestigation/ghostrandom004a.wav",
	"hauntedinvestigation/ghostrandom005a.wav",
	"hauntedinvestigation/ghostrandom006a.wav"
}

local GhostAttackLoopSoundList = {
	"ambient/levels/citadel/zapper_loop1.wav",
	"ambient/levels/citadel/zapper_loop2.wav"
}

function EnableGhostSpecialSounds()

	UtilDoForPlayers(team.GetPlayers(TEAM_GHOST), function(InIndex, InPlayer)

		InPlayer:SetNWInt("GhostSpecialSoundCountdown", math.random(25.0, 60.0) * InIndex)
	end)

	timer.Create("GhostSpecialSoundTick", 1.0, 0, GhostEmitSpecialSoundTick)
end

function DisableGhostSpecialSounds()

	timer.Remove("GhostSpecialSoundTick")
end

function GhostEmitSpecialSoundTick()

	UtilDoForPlayers(team.GetPlayers(TEAM_GHOST), function(InIndex, InPlayer)

		if InPlayer:GetNWFloat("EnergyValue") <= 0.0 then

			return
		end

		local SpecialSoundList = GhostRandomSoundList

		--MsgN(InPlayer:GetNWBool("bInvestigatorNearby"))

		if InPlayer:GetNWBool("bInvestigatorNearby") then

			SpecialSoundList = GhostNearbySoundList

			InPlayer:SetNWInt("GhostSpecialSoundCountdown", InPlayer:GetNWInt("GhostSpecialSoundCountdown") - 1)
		end

		InPlayer:SetNWInt("GhostSpecialSoundCountdown", InPlayer:GetNWInt("GhostSpecialSoundCountdown") - 1)

		if InPlayer:GetNWInt("GhostSpecialSoundCountdown") <= 0 then

			InPlayer:SetNWInt("GhostSpecialSoundCountdown", math.random(30.0, 60.0))

			local SampleSoundName = table.Random(SpecialSoundList)

			InPlayer:EmitSound(SampleSoundName, 60)

			MsgN(Format("%s %s emit random sound %s", InPlayer:GetNWBool("bInvestigatorNearby"), InPlayer, SampleSoundName))
		end
	end)
end

function OnGhostTryMaterialize(InGhost)

	InGhost.LastGhostMaterializeSoundTime = InGhost.LastGhostMaterializeSoundTime or 0.0

	--MsgN(Format("%s %s + 10.0 < %s", InGhost:GetNWFloat("SpectralValue"), InGhost.LastGhostMaterializeSoundTime, CurTime()))

	if InGhost:GetNWFloat("SpectralValue") < 0.5 and InGhost.LastGhostMaterializeSoundTime + 8.0 < CurTime() then

		local SampleSoundName = table.Random(GhostAttackSoundList)

		InGhost:EmitSound(SampleSoundName)

		InGhost.LastGhostMaterializeSoundTime = CurTime()

		MsgN(Format("%s emit attack sound %s", InGhost, SampleSoundName))
	end
end

function TryStartGhostAttackLoopSound(InGhostPlayer, InTarget)

	--MsgN("TryStartGhostAttackLoopSound()")

	if InGhostPlayer.AttackSound == nil then

		InGhostPlayer.AttackSound = CreateSound(InTarget, table.Random(GhostAttackLoopSoundList), RecipientFilter():AddAllPlayers())

		InGhostPlayer.AttackSound:Play()

		MsgN("Start attack loop sound")
	end
end

function TryStopGhostAttackLoopSound(InGhostPlayer)

	--MsgN("TryStopGhostAttackLoopSound()")

	if InGhostPlayer.AttackSound ~= nil then

		InGhostPlayer.AttackSound:Stop()

		InGhostPlayer.AttackSound = nil

		MsgN("Stop attack loop sound")
	end
end
