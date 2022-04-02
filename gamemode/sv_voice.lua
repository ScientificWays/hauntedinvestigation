---- Haunted Investigation

timer.Create("PlayerVoiceFilterUpdate", 0.5, 0, function()

	local AllPlayers = player.GetAll()

	UtilDoForPlayers(player.GetAll(), function(InIndex, InPlayer)

		InPlayer.VoiceFilteredPlayers = {}

		local VoiceFilter = RecipientFilter()
		
		VoiceFilter:AddPVS(InPlayer:EyePos())

		for SampleIndex, VisiblePlayer in ipairs(VoiceFilter:GetPlayers()) do

			InPlayer.VoiceFilteredPlayers[VisiblePlayer:UserID()] = true
		end

		--MsgN(InPlayer, table.ToString(InPlayer.VoiceFilteredPlayers))
	end)
end)

function GM:PlayerCanHearPlayersVoice(InListener, InTalker)

	--MsgN(InListener, table.ToString(InListener.VoiceFilteredPlayers))

	if InListener:Team() == TEAM_INVESTIGATOR and (InTalker:Team() == TEAM_GHOST or InTalker:Team() == TEAM_SPECTATOR) then

		return false, false

	elseif InListener:Team() ~= TEAM_INVESTIGATOR and InTalker:Team() ~= TEAM_INVESTIGATOR then

		return true, false
	
	elseif UtilCanHearByTalkie(InListener, InTalker) then

		return true, false

	elseif InListener.VoiceFilteredPlayers and InListener.VoiceFilteredPlayers[InTalker:UserID()] then

		--MsgN("Test")

		local TraceResult = util.TraceLine({
			start = InListener:EyePos(),
			endpos = InTalker:EyePos(),
			mask = CONTENTS_SOLID
		})

		local CurrentDistance, MaxDistance = InListener:GetPos():DistToSqr(InTalker:GetPos()), 4200000

		if TraceResult.Hit then

			MaxDistance = 22500
		end

		local bWithinDistance = CurrentDistance < MaxDistance

		return bWithinDistance, true
	else
		return false, false
	end
end
