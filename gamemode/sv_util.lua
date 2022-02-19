---- Haunted Investigation

function UtilGetMaxInvestigators()

	return GetConVar("sk_maxinvestigators"):GetInt()
end

function UtilGetMaxGhosts()

	return GetConVar("sk_maxghosts"):GetInt()
end

function UtilSendChatMessageToPlayers(InMessageStrings)

	net.Start("SendChatMessageToClients")

	for Index, SampleString in ipairs(InMessageStrings) do

		net.WriteString(SampleString)
	end

	net.Broadcast()
end
