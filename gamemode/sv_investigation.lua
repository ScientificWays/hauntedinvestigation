---- Haunted Investigation

function OnInvestigationStarted(InScenarioData)

	SetGlobalInt("CurrentGameState", GAMESTATE_INVESTIGATION)

	SetGlobalInt("InvestigationTimeLeft", InScenarioData.BaseTimeLimit)

	timer.Create("InvestigationTimer", 1.0, 0, InvestigationTimerTick)

	local AllPlayers = player.GetAll()

	for Index, SamplePlayer in ipairs(AllPlayers) do

		if not SamplePlayer:InVehicle() and SamplePlayer:Team() ~= TEAM_SPECTATOR then

			SamplePlayer:Spawn()
		end
	end

	StartGhostLogic()

	EnableGhostSpecialSounds()
end

function InvestigationTimeAdd(InSeconds)

	SetGlobalInt(GetGlobalInt("InvestigationTimeLeft") + InSeconds)
end

function InvestigationTimerTick()

	local TimeLeft = GetGlobalInt("InvestigationTimeLeft")

	if TimeLeft >= 1 then

		SetGlobalInt("InvestigationTimeLeft", TimeLeft - 1)
	else

		SetGlobalInt("InvestigationTimeLeft", 0)

		timer.Remove("InvestigationTimer")

		StartPostGame()
	end
end
