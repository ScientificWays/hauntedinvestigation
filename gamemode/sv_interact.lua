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

		if InActivator:Team() == TEAM_INVESTIGATOR then

			MsgN(InTargetEntity)

			if InTargetEntity:GetNWBool("bCodeKeypad") then

				net.Start("ClientOpenKeypad")

				net.Send(InActivator)
			end
		end

	elseif InInput == "StartTouch" then

		if InActivator:Team() == TEAM_GHOST or InActivator:Team() == TEAM_SPECTATOR then

			MsgN(Format("Block start touch input of %s", InActivator))

			return true
		end
	end

	return false
end
