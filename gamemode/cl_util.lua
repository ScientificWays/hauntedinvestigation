---- Haunted Investigation

local BlurMaterial = Material("pp/blurscreen")

function UtilDrawBlur(InPanel, InValue)

	local ScreenX, ScreenY = InPanel:LocalToScreen(0, 0)

	surface.SetDrawColor(255, 255, 255)

	surface.SetMaterial(BlurMaterial)

	for i = 1, 3 do

		BlurMaterial:SetFloat("$blur", (i / 3) * (InValue or 6))

		BlurMaterial:Recompute()

		render.UpdateScreenEffectTexture()

		surface.DrawTexturedRect(ScreenX * -1, ScreenY * -1, ScrW(), ScrH())
	end
end

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
