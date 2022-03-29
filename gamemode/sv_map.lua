---- Haunted Investigation

--GhostAreaList = {}

IntroData = {}

InvestigationStartRelayName = ""

SelectedScenarioIndex = 1
ScenarioDataList = {}

function InitMap()

	MsgN("InitMap()")

	local AllEntities = ents.GetAll()

	for Index, SampleEntity in ipairs(AllEntities) do

		local SampleEntityName = SampleEntity:GetName()

		if SampleEntityName == "InvestigationSetup_Relay" then

			MsgN(SampleEntityName.." is triggered!")

			SampleEntity:Input("Trigger")

		elseif string.EndsWith(SampleEntityName, "_CodeInfo") then

			MsgN(SampleEntityName.." is registered!")

			SampleEntity:SetNWBool("bShowHint")

			SampleEntity:SetNWBool("bCodeInfo")

		elseif string.EndsWith(SampleEntityName, "_GhostSabotage") then

			MsgN(SampleEntityName.." is registered!")

			RegisterSabotageData(SampleEntity)
		end
	end
end

function RegisterIntroData(InIntroRelayName, InIntroDriverSeatName, InIntroPassengerSeatName)

	MsgN("RegisterIntroData()")

	IntroData = {
		RelayName = InIntroRelayName,
		DriverSeatName = InIntroDriverSeatName,
		PassengerSeatName = InIntroPassengerSeatName
	}
end

function RegisterScenarioData(InScenarioIndex, InScenarioRelayName, InScenarioGhostAreasName, InBaseTimeLimit)

	MsgN(Format("RegisterScenarioData() %i", InScenarioIndex))

	ScenarioDataList[InScenarioIndex] = {
		RelayName = InScenarioRelayName,
		GhostAreasName = InScenarioGhostAreasName,
		BaseTimeLimit = InBaseTimeLimit
	}
end

function RegisterInvestigationStartRelay(InInvestigationStartRelayName)

	MsgN("RegisterInvestigationStartRelay()")

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

	if ScenarioDataList[SelectedScenarioIndex] == nil then

		MsgN("ScenarioData is invalid, attempt to reregister...")

		InitMap()
	end

	local ScenarioData = ScenarioDataList[SelectedScenarioIndex]

	local ScenarioRelay = ents.FindByName(ScenarioData.RelayName)[1]

	local ScenarioGhostAreaList = ents.FindByName(ScenarioData.GhostAreasName)

	SetGhostAreaList(ScenarioGhostAreaList)

	ScenarioRelay:Input("Trigger")

	if bSkipIntro then

		StartInvestigation()
	else
		StartIntro()
	end
end

function StartIntro()

	if GetGlobalInt("CurrentGameState") ~= GAMESTATE_PREGAME then

		UtilSendChatMessageToPlayers({"HI_Error.StartIntroError"})

		return
	end

	OnIntroStarted(IntroData)
end

function StartInvestigation()

	if GetGlobalInt("CurrentGameState") ~= GAMESTATE_PREGAME and GetGlobalInt("CurrentGameState") ~= GAMESTATE_VEHICLEINTRO then

		UtilSendChatMessageToPlayers({"HI_Error.StartInvestigationError"})

		return
	end

	local InvestigationStartRelay = ents.FindByName(InvestigationStartRelayName)[1]

	InvestigationStartRelay:Input("Trigger")

	OnInvestigationStarted(ScenarioDataList[SelectedScenarioIndex])
end

function StartPostGame()

	if GetGlobalInt("CurrentGameState") ~= GAMESTATE_INVESTIGATION then

		UtilSendChatMessageToPlayers({"HI_Error.StartPostGameError"})

		return
	end

	UtilSendChatMessageToPlayers({"HI_Event.EndGame"})

	StopGhostLogic()

	DisableGhostSpecialSounds()
end
