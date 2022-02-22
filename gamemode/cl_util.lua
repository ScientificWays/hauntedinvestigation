---- Haunted Investigation

function UtilLocalizable(InString)

	return language.GetPhrase(InString)
end

function UtilClientReceiveChatMessage(InMessageLength, InPlayer)

	local PrintArgumets = {}

	for Index = 1, 10 do

		local SampleString = net.ReadString()

		if SampleString == "" then

			break
		else

			table.insert(PrintArgumets, UtilLocalizable(SampleString))
		end
	end

	--MsgN(PrintTable(PrintArgumets))

	--MsgN(unpack(PrintArgumets))

	chat.AddText(Color, Format(unpack(PrintArgumets)))
end
