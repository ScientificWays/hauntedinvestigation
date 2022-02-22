---- Haunted Investigation

function GM:AcceptInput(InTargetEntity, InInput, InActivator, InCaller, InValue)

	if not InActivator:IsPlayer() then

		return false
	end

	--MsgN(InInput)

	if InInput == "Use" then

		if InActivator:Team() == TEAM_GHOST or InActivator:Team() == TEAM_SPECTATOR then

			return true
		end
	end

	return false
end
