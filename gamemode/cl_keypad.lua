---- Haunted Investigation

local KeypadFrame = nil

local KeypadFrameWidth, KeypadFrameHeight = 300, 100

function IsKeypadOpen()

	return IsValid(KeypadFrame)
end

function ShowKeypad()

	if IsKeypadOpen() then

		return
	end

	KeypadFrame = vgui.Create("DFrame")

	KeypadFrame:SetTitle(UtilLocalizable("HI_HUD.Input"))
	
	local KeypadInput = vgui.Create("DTextEntry", KeypadFrame)

	KeypadInput:SetNumeric(true)

	KeypadInput:SetPos(10, 30)

	KeypadInput:SetSize(KeypadFrameWidth - 20, 20)

	KeypadInput:SetFont("HUDTextSmall")

	function KeypadInput.OnChange()

		surface.PlaySound("buttons/blip1.wav")
	end

	local KeypadButton = vgui.Create("DButton", KeypadFrame)

	KeypadButton:SetPos(10, 60)

	KeypadButton:SetSize(KeypadFrameWidth - 20, 20)

	function KeypadButton.DoClick()

		local ReceiveCode = KeypadInput:GetInt()

		MsgN(GetGlobalInt("InvestigationCode"))

		if ReceiveCode == GetGlobalInt("InvestigationCode") then

			net.Start("SendTryUseKeypadCode")

			net.WriteInt(KeypadInput:GetInt(), 32)

			net.SendToServer()

			surface.PlaySound("buttons/button14.wav")
		else
			surface.PlaySound("buttons/button10.wav")
		end

		HideKeypad()
	end

	KeypadFrame:SetSize(KeypadFrameWidth, KeypadFrameHeight)

	KeypadFrame:Center()

	KeypadFrame:MakePopup()

	KeypadFrame:SetKeyboardInputEnabled(true)
end

function HideKeypad()

	if not IsKeypadOpen() then

		return
	end

	KeypadFrame:Remove()

	KeypadFrame = nil
end
