---- Haunted Investigation

local GhostAreaList = {}

local IntroRelay = nil
local IntroDriverSeatName, IntroPassengerSeatsName = "", ""

local SelectedScenarioIndex = 1
local ScenarioRelayList = {}

function InitMapAreas()

	MsgN("InitMapAreas()")

	local PotentialAreas = ents.FindByClass("trigger_multiple")

	for Index, SampleArea in ipairs(PotentialAreas) do

		local SampleAreaName = SampleArea:GetName()

		if string.EndsWith(SampleAreaName, "_GhostArea") then

			table.insert(GhostAreaList, SampleArea)
		end
	end
end

function RegisterIntroData(InIntroRelayName, InIntroDriverSeatName, InIntroPassengerSeatsName)

	IntroRelay = ents.FindByName(InIntroRelayName)[1]

	IntroDriverSeatName, IntroPassengerSeatsName = InIntroDriverSeatName, InIntroPassengerSeatsName
end

function RegisterScenarioRelay(InScenarioRelayName, InScenarioIndex)

	local SampleScenarioRelay = ents.FindByName(InScenarioRelayName)[1]

	ScenarioRelayList[InScenarioIndex] = SampleScenarioRelay
end

function TrySetScenario(InScenarioIndex)

	MsgN(Format("TrySetScenario() %s", InScenarioIndex))

	if ScenarioRelayList[InScenarioIndex] ~= nil then

		SelectedScenarioIndex = InScenarioIndex

		UtilSendChatMessageToPlayers({"HI_Event.SetScenario", SelectedScenarioIndex})
	end
end

function StartGame(bSkipIntro)

	local AllPlayers = player.GetAll()

	for Index, SamplePlayer in ipairs(AllPlayers) do

		SamplePlayer:Spawn()
	end

	ScenarioRelayList[SelectedScenarioIndex]:Input("Trigger")

	if bSkipIntro then

		OnInvestigationStarted()
	else
		IntroRelay:Input("Trigger")

		StartVehicleIntro(IntroDriverSeatName, IntroPassengerSeatsName)
	end

	UtilSendChatMessageToPlayers({"HI_Event.StartGame", SelectedScenarioIndex})
end
