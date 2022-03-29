---- Haunted Investigation

hook.Add("KeyPress", "SpectatorSoundInterfaceOpen", function(InPlayer, InKey)

	if InPlayer:Team() == TEAM_SPECTATOR and InKey == IN_USE then

		if CanPlaySpectatorSound(InPlayer) then

			net.Start("ClientOpenSoundInterface")

			net.Send(InPlayer)
		end
	end
end)

function ServerReceiveTryPlaySpectatorSound(InMessageLength, InPlayer)

	local SoundIndex = net.ReadInt(32)

	if CanPlaySpectatorSound(InPlayer, SoundIndex) then

		local SoundDataList = GetSoundDataList()

		local FinalSound = table.Random(SoundDataList[SoundIndex].List)

		MsgN(Format("%s played spectator sound \"%s\"", InPlayer, FinalSound))

		InPlayer:EmitSound(FinalSound)

		InPlayer:SetNWFloat("SpectatorSoundCooldownTime", CurTime() + UtilGetSpectatorSoundCooldown())
	end
end
