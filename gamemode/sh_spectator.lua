---- Haunted Investigation

local SoundDataList = {
	[1] = {
		Name = "HI_Spectator.DistGrowl",
		List = {"ambient/levels/caves/dist_growl1.wav", "ambient/levels/caves/dist_growl2.wav", "ambient/levels/caves/dist_growl3.wav", "ambient/levels/caves/dist_growl4.wav"}
	},
	[2] = {
		Name = "HI_Spectator.CaveHit",
		List = {"ambient/atmosphere/cave_hit1.wav", "ambient/atmosphere/cave_hit2.wav", "ambient/atmosphere/cave_hit3.wav", "ambient/atmosphere/cave_hit4.wav","ambient/atmosphere/cave_hit5.wav","ambient/atmosphere/cave_hit6.wav"}
	},
	[3] = {
		Name = "HI_Spectator.Spooky01",
		List = {"hauntedinvestigation/spectatorspooky001a.wav", "hauntedinvestigation/spectatorspooky002a.wav", "hauntedinvestigation/spectatorspooky003a.wav", "hauntedinvestigation/spectatorspooky004a.wav"}
	}
}

function GetSoundDataList()

	--MsgN("GetSoundDataList()")

	return SoundDataList
end

function CanPlaySpectatorSound(InPlayer, InSoundIndex)

	return InPlayer:Team() == TEAM_SPECTATOR
		and InPlayer:GetNWFloat("SpectatorSoundCooldownTime") < CurTime()
		and (InSoundIndex == nil or SoundDataList[InSoundIndex] ~= nil)
end
