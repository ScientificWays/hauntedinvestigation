---- Haunted Investigation

timer.Create("PlayerVoiceFilterUpdate", 0.5, 0, function()

	local AllPlayers = player.GetAll()

	for Index, SamplePlayer in ipairs(AllPlayers) do

		SamplePlayer.VoiceFilteredPlayers = {}

		local VoiceFilter = RecipientFilter()
		
		VoiceFilter:AddPVS(SamplePlayer:EyePos())

		for Index, VisiblePlayer in ipairs(VoiceFilter:GetPlayers()) do

			SamplePlayer.VoiceFilteredPlayers[VisiblePlayer:UserID()] = true
		end

		--MsgN(SamplePlayer, table.ToString(SamplePlayer.VoiceFilteredPlayers))
	end
end)

function GM:PlayerCanHearPlayersVoice(InListener, InTalker)

	--MsgN(InListener, table.ToString(InListener.VoiceFilteredPlayers))
	
	if UtilCanHearByTalkie(InListener, InTalker) then

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
