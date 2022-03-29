---- Haunted Investigation

local SoundInterfaceFrame = nil

local SoundInterfaceFrameWidth, SoundInterfaceFrameHeight = 300, 800

function IsSoundInterfaceOpen()

	return IsValid(SoundInterfaceFrame)
end

function ShowSoundInterface()

	if IsSoundInterfaceOpen() then

		return
	end

	SoundInterfaceFrame = vgui.Create("DFrame")

	SoundInterfaceFrame:SetSize(SoundInterfaceFrameWidth, SoundInterfaceFrameHeight)

	SoundInterfaceFrame:SetPos(10, ScrH() / 2 - SoundInterfaceFrameHeight / 2)

	SoundInterfaceFrame:SetTitle("")

	SoundInterfaceFrame:SetAlpha(0)

	SoundInterfaceFrame:AlphaTo(255, 0.4, 0)

	SoundInterfaceFrame:SetDraggable(false)

	SoundInterfaceFrame:ShowCloseButton(false)

	SoundInterfaceFrame:MakePopup()

	SoundInterfaceFrame.Paint = function(self, w, h)

		UtilDrawBlur(self, 3)

		draw.RoundedBoxEx(10, 0, 0, w, h, Color(0, 0, 0, 200), true, true, true, true)

		draw.SimpleText(UtilLocalizable("HI_HUD.SoundList"), "HUDTextSmall", SoundInterfaceFrameWidth / 2, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.RoundedBoxEx(0, 0, 25, w, 5, Color(255, 255, 255), true, true, true, true)
	end

	local SoundListScrollPanel = vgui.Create("DScrollPanel", SoundInterfaceFrame)

	SoundListScrollPanel:Dock(FILL)

	local ScrollBar = SoundListScrollPanel:GetVBar()

		ScrollBar.Paint = function()
	end

	function ScrollBar.btnUp:Paint(h,i)

		draw.RoundedBox(0, 0, 0, h, i, Color(0, 0, 0, 200))
	end
		
	function ScrollBar.btnDown:Paint(h,i)

		draw.RoundedBox(0, 0, 0, h, i, Color(0, 0, 0, 200))
	end

	function ScrollBar.btnGrip:Paint(h,i)

		draw.RoundedBox(0, 0, 0, h, i, Color(0, 0, 0, 200))
	end

	local SoundDataList = GetSoundDataList()

	for SoundIndex, SoundData in ipairs(SoundDataList) do

		local SoundButton = SoundListScrollPanel:Add("DButton")

		SoundButton:SetSize(SoundInterfaceFrameWidth, 50)

		SoundButton:Dock(TOP)

		SoundButton:DockMargin(5, 5, 0, 5)

		SoundButton:SetText("")

		SoundButton.lerp = 0

		SoundButton.Paint = function(self, w, h)

			draw.RoundedBoxEx(10, 0, 0, w, h, Color(30, 30, 30, 200), true, false, true, false)

			if self:IsHovered() then

				self.lerp = Lerp(FrameTime() * 6, self.lerp, 10)

				draw.RoundedBoxEx(10, 0, 0, self.lerp, h, Color(116, 0, 255, 255), true, false, true, false)
			else
				self.lerp = Lerp(FrameTime() * 6, self.lerp, 0)

				draw.RoundedBoxEx(10, 0, 0, self.lerp, h, Color(116, 0, 255, 255), true, false, true, false)
			end

			draw.SimpleText(UtilLocalizable(SoundData.Name), "HUDTextSmall", SoundInterfaceFrameWidth / 2, 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		SoundButton.DoClick = function()

			--Kind of prediction logic
			if CanPlaySpectatorSound(LocalPlayer(), SoundIndex) then

				net.Start("SendTryPlaySpectatorSound")

				net.WriteInt(SoundIndex, 32)

				net.SendToServer()

				HideSoundInterface()
			else

				surface.PlaySound("buttons/button10.wav")
			end

			MsgN("Клик")
		end
	end

	local CloseButton = vgui.Create("DButton", SoundInterfaceFrame)

	CloseButton:SetSize(25, 25)

	CloseButton:SetPos(SoundInterfaceFrameWidth - 25, 0)

	CloseButton:SetText("")

	CloseButton.lerp = 0

	CloseButton.Paint = function(self, w, h)

		if self:IsHovered() then
			self.lerp = Lerp(FrameTime() * 6, self.lerp, w)
			draw.RoundedBoxEx(10, 0, 0, self.lerp, h, Color(220, 20, 60), false, true, false, false)
		else
			self.lerp = Lerp(FrameTime() * 6, self.lerp, 0)
			draw.RoundedBoxEx(10, 0, 0, self.lerp, h, Color(220, 20, 60), false, true, false, false)
		end

		draw.SimpleText("X", "HUDTextSmall", 12, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

	CloseButton.DoClick = function()

		HideSoundInterface()
	end
end

function HideSoundInterface()

	if not IsSoundInterfaceOpen() then

		return
	end

	SoundInterfaceFrame:AlphaTo(0, 0.4, 0)

	timer.Simple(0.4, function()

		SoundInterfaceFrame:Remove()

		SoundInterfaceFrame = nil
	end)
end
