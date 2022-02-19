---- Haunted Investigation

function GM:PlayerSay(InSender, InText, bTeamChat)

	if InText[1] ~= "/" then

		MsgN(Format("Chat text: %s ", InText))

		return InText
	end

	local SeparatedStrings = string.Explode(" ", InText, false)

	if SeparatedStrings[1] == "/help" then

		UtilSendChatMessageToPlayers({"HI_Chat.Help"})

	elseif InSender:IsAdmin() and SeparatedStrings[1] == "/scenario" and SeparatedStrings[2] ~= nil then

		TrySetScenario(tonumber(SeparatedStrings[2]) or 1)

	elseif InSender:IsAdmin() and SeparatedStrings[1] == "/start" then

		StartGame(SeparatedStrings[2] == "nointro")

	elseif InSender:IsAdmin() and SeparatedStrings[1] == "/Лёха" then

		local DebugDude = player.CreateNextBot("Лёха")

		DebugDude:SetTeam(TEAM_INVESTIGATOR)

		DebugDude:Spawn()
	end

	return ""
end
