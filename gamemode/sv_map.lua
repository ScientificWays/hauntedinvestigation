---- Haunted Investigation

--GhostAreaList = {}

local IntroRelayName = ""
local IntroDriverSeatName, IntroPassengerSeatsName = "", ""

local InvestigationStartRelayName = ""

local SelectedScenarioIndex = 1
local ScenarioDataList = {}

--[[function InitMapAreas()

	MsgN("InitMapAreas()")

	local PotentialAreas = ents.FindByClass("trigger_multiple")

	for Index, SampleArea in ipairs(PotentialAreas) do

		local SampleAreaName = SampleArea:GetName()

		if string.EndsWith(SampleAreaName, "_GhostArea") then

			table.insert(GhostAreaList, SampleArea)
		end
	end
end--]]

function RegisterIntroData(InIntroRelayName, InIntroDriverSeatName, InIntroPassengerSeatsName)

	IntroRelayName = InIntroRelayName

	IntroDriverSeatName, IntroPassengerSeatsName = InIntroDriverSeatName, InIntroPassengerSeatsName
end

function RegisterScenarioData(InScenarioIndex, InScenarioRelayName, InScenarioGhostAreasName)

	MsgN(Format("RegisterScenarioData() %i", InScenarioIndex))

	ScenarioDataList[InScenarioIndex] = {RelayName = InScenarioRelayName, GhostAreasName = InScenarioGhostAreasName}
end

function RegisterInvestigationStartRelay(InInvestigationStartRelayName)

	InvestigationStartRelayName = InInvestigationStartRelayName
end

function TrySetScenario(InScenarioIndex)

	MsgN(Format("TrySetScenario() %s", InScenarioIndex))

	if ScenarioDataList[InScenarioIndex] ~= nil then

		SelectedScenarioIndex = InScenarioIndex

		UtilSendChatMessageToPlayers({"HI_Event.SetScenario", SelectedScenarioIndex})
	end
end

function StartGame(bSkipIntro)

	UtilSendChatMessageToPlayers({"HI_Event.StartGame", SelectedScenarioIndex})

	local AllPlayers = player.GetAll()

	for Index, SamplePlayer in ipairs(AllPlayers) do

		SamplePlayer:Spawn()
	end

	MsgN(table.ToString(ScenarioDataList))

	local ScenarioRelay = ents.FindByName(ScenarioDataList[SelectedScenarioIndex].RelayName)[1]

	local ScenarioGhostAreaList = ents.FindByName(ScenarioDataList[SelectedScenarioIndex].GhostAreasName)

	SetGhostAreaList(ScenarioGhostAreaList)

	ScenarioRelay:Input("Trigger")

	if bSkipIntro then

		OnInvestigationStarted()
	else

		OnIntroStarted()
	end

	StartUpdateGhostAreas()

	EnableGhostSpecialSounds()
end

function OnIntroStarted()

	IntroRelay = ents.FindByName(IntroRelayName)[1]

	IntroRelay:Input("Trigger")

	StartVehicleIntro(IntroDriverSeatName, IntroPassengerSeatsName)
end

function OnInvestigationStarted()

	TryEndVehicleIntro()

	SetGlobalInt("CurrentGameState", GAMESTATE_INVESTIGATION)

	local InvestigationStartRelay = ents.FindByName(InvestigationStartRelayName)[1]

	InvestigationStartRelay:Input("Trigger")

	local AllInvestigators = team.GetPlayers(TEAM_INVESTIGATOR)

	for Index, SampleInvestigator in ipairs(AllInvestigators) do

		--SampleInvestigator:SetNWBool("bRenderLight", false)

		if not SampleInvestigator:Alive() or not SampleInvestigator:InVehicle() then

			SampleInvestigator:Spawn()
		end
	end

	local AllGhosts = team.GetPlayers(TEAM_GHOST)

	for Index, SampleGhost in ipairs(AllGhosts) do

		--SampleGhost:SetNWBool("bRenderLight", true)

		if not SampleGhost:Alive() or not SampleGhost:InVehicle() then

			SampleGhost:Spawn()
		end
	end
end

function EndGame()

	UtilSendChatMessageToPlayers({"HI_Event.EndGame"})

	StopUpdateGhostAreas()

	DisableGhostSpecialSounds()
end
