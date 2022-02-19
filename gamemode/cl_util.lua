---- Haunted Investigation

hook.Add("Think", "GhostVision", function()

	local Client = LocalPlayer()

	if Client:GetNWBool("bRenderLight") then

		local DynamicLight = DynamicLight(Client:EntIndex())

		if DynamicLight then

			DynamicLight.pos = Client:EyePos()

			DynamicLight.r = 25

			DynamicLight.g = 25

			DynamicLight.b = 25

			DynamicLight.brightness = 1

			DynamicLight.Decay = 1000

			DynamicLight.Size = 2048

			DynamicLight.DieTime = CurTime() + 1
		end
	end
end)

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

	chat.AddText(COLOR_CYAN, Format(unpack(PrintArgumets)))
end
