---- Haunted Investigation

local InvestigatorCheckpointName = ""

function OnInvestigationStarted(InScenarioData)

	SetGlobalInt("CurrentGameState", GAMESTATE_INVESTIGATION)

	if UtilGetEnableTimeLimit() then

		SetGlobalInt("InvestigationTimeLeft", InScenarioData.BaseTimeLimit)

		timer.Create("InvestigationTimer", 1.0, 0, InvestigationTimerTick)
	else
		SetGlobalInt("InvestigationTimeLeft", -1)
	end

	SetGlobalInt("InvestigatorLifes", UtilGetInvestigatorMaxLifes())

	SetGlobalInt("InvestigationCode", math.random(1000, 9999))

	MsgN(Format("Current keypad code is %i", GetGlobalInt("InvestigationCode")))

	UtilDoForPlayers(team.GetPlayers(TEAM_INVESTIGATOR), function(InIndex, InPlayer)

		if not InPlayer:InVehicle() then

			InPlayer:Spawn()
		end

		InPlayer:SetNWBool("bRenderLight", false)
	end)

	UtilDoForPlayers(team.GetPlayers(TEAM_GHOST), function(InIndex, InPlayer)

		InPlayer:Spawn()
	end)

	StartGhostLogic()

	EnableGhostSpecialSounds()
end

function InvestigationTimeAdd(InSeconds)

	if UtilGetEnableTimeLimit() then

		SetGlobalInt("InvestigationTimeLeft", GetGlobalInt("InvestigationTimeLeft") + InSeconds)
	end
end

function InvestigationTimerTick()

	local TimeLeft = GetGlobalInt("InvestigationTimeLeft")

	if TimeLeft >= 1 then

		SetGlobalInt("InvestigationTimeLeft", TimeLeft - 1)
	else
		FinishInvestigation(1)
	end
end

function GetInvestigatorCheckpointList()

	local OutCheckpointList = ents.FindByName(InvestigatorCheckpointName)

	return OutCheckpointList
end

function SetInvestigatorCheckpointName(InCheckpointName)

	InvestigatorCheckpointName = InCheckpointName
end
