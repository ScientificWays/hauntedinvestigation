---- Haunted Investigation

local IntroData = {}

local InvestigationStartRelayName = ""

local SelectedScenarioIndex = 1
local ScenarioDataList = {}

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

			SampleEntity:SetNWBool("bShowHint", true)

			SampleEntity:SetNWBool("bCodeInfo", true)

		elseif string.EndsWith(SampleEntityName, "_CodeKeypad") then

			MsgN(SampleEntityName.." is registered!")

			SampleEntity:SetNWBool("bShowHint", true)

			SampleEntity:SetNWBool("bCodeKeypad", true)

		elseif string.EndsWith(SampleEntityName, "_Artifact") then

			MsgN(SampleEntityName.." is registered!")

			SampleEntity:SetNWBool("bShowHint", true)

			SampleEntity:SetNWBool("bArtifact", true)

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
	MsgN(Format("Current scenarion data: %s", table.ToString(ScenarioDataList)))
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

	UtilDoForPlayers(player.GetAll(), function(InIndex, InPlayer)

		InPlayer:Spawn()
	end)

	if ScenarioDataList[SelectedScenarioIndex] == nil then

		MsgN("ScenarioData is invalid, attempt to reregister...")

		InitMap()
	end

	timer.Simple(0.4, function()

		MsgN(Format("ScenarioDataList: %s", table.ToString(ScenarioDataList)))

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
	end)
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

function FinishInvestigation(InFinishCode)

	SetGlobalInt("InvestigationTimeLeft", 0)

	timer.Remove("InvestigationTimer")

	local FinishDelay = 2.0

	if InFinishCode == 1 then

		FinishDelay = 4.0

		UtilSendChatMessageToPlayers({"HI_Event.TimeoutGameEnd"})

	elseif InFinishCode == 2 then

		UtilSendChatMessageToPlayers({"HI_Event.NoLifesGameEnd"})
	end

	UtilDoForPlayers(player.GetAll(), function(InIndex, InPlayer)

		InPlayer:ScreenFade(SCREENFADE.OUT, COLOR_WHITE, FinishDelay, 2.0)
	end)

	timer.Simple(FinishDelay, function()

		StartPostGame()

		UtilDoForPlayers(player.GetAll(), function(InIndex, InPlayer)

			InPlayer:ScreenFade(SCREENFADE.IN, COLOR_WHITE, 0.0, 2.0)
		end)
	end)
end

function StartPostGame()

	if GetGlobalInt("CurrentGameState") ~= GAMESTATE_INVESTIGATION then

		UtilSendChatMessageToPlayers({"HI_Error.StartPostGameError"})

		return
	end

	SetGlobalInt("CurrentGameState", GAMESTATE_POSTGAME)

	UtilSendChatMessageToPlayers({"HI_Event.EndGame"})

	StopGhostLogic()

	DisableGhostSpecialSounds()

	UtilDoForPlayers(player.GetAll(), function(InIndex, InPlayer)

		InPlayer:Spawn()
	end)
end

function ServerReceiveTryUseKeypadCode(InMessageLength, InPlayer)

	local ReceiveCode = net.ReadInt(32)

	if ReceiveCode == GetGlobalInt("InvestigationCode") then

		local SampleCodeSuccessRelays = ents.FindByName("*_CodeSuccess")

		if not table.IsEmpty(SampleCodeSuccessRelays) then

			local SuccessRelay = SampleCodeSuccessRelays[1]

			SuccessRelay:Input("Trigger")
		end
	end
end
