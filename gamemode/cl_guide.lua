---- Roleplay: Prison

local GuideFrame = {}

local GuideFrameWidth, GuideFrameHeight = 800, 300

local GuideHintList = {}

function IsGuideOpen()

	return IsValid(GuideFrame)
end

function ShowGuide(InTeamID)

	if IsGuideOpen() then

		return
	end

	GuideFrame = vgui.Create("DFrame")

	GuideFrame:SetTitle(UtilLocalizable("HI_Guide.Info"))
	
	GuideFrame:SetSize(GuideFrameWidth, GuideFrameHeight)

	GuideFrame:Center()

	GuideFrame:MakePopup()

	function GuideFrame.OnClose()

		HideGuide()
	end

	local GuideTextPanel = vgui.Create("DPanel", GuideFrame)

	GuideTextPanel:Dock(TOP)

	GuideTextPanel:SetSize(GuideFrameWidth, GuideFrameHeight)

	GuideTextPanel:Center()

	GuideHintList = {}

	for HintIndex = 1, 5 do

		table.insert(GuideHintList, UtilLocalizable("HI_Guide."..team.GetName(InTeamID)..HintIndex))
	end

	MsgN(GuideText)

	GuideTextPanel.Paint = function(self, w, h)

		local HintY = 20

		for SampleIndex, SampleHint in ipairs(GuideHintList) do

			draw.DrawText(SampleIndex..". "..SampleHint, "HUDTextSmall", GuideFrameWidth * 0.5, HintY, team.GetColor(InTeamID), TEXT_ALIGN_CENTER)

			HintY = HintY + 50
		end
	end
end

function HideGuide()

	if not IsGuideOpen() then
		
		return
	end
	
	GuideFrame:Remove()

	GuideFrame = nil
end

function ToggleGuide()

	if IsValid(GuideFrame) then

		HideGuide()
	else

		ShowGuide()
	end
end
