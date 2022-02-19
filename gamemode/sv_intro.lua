---- Haunted Investigation

IntroDriverSeat = nil

IntroPassengerSeats = {}

local function PickSeatForInvestigator(InInvestigator)

	--MsgN(Format("PickSeatForInvestigator() %s", InInvestigator))

	if not IsValid(IntroDriverSeat:GetDriver()) then

		InInvestigator:EnterVehicle(IntroDriverSeat)

		MsgN(Format("%s enter vehicle %s", InInvestigator, IntroDriverSeat))
	else
		local FreePassengerSeats = {}

		for Index, SamplePassengerSeat in ipairs(IntroPassengerSeats) do

			if not IsValid(SamplePassengerSeat:GetDriver()) then

				table.insert(FreePassengerSeats, SamplePassengerSeat)
			end
		end

		PrintTable(FreePassengerSeats)

		if not table.IsEmpty(FreePassengerSeats) then

			local SampleIndex = math.Random(#FreePassengerSeats)

			InInvestigator:EnterVehicle(FreePassengerSeats[SampleIndex])

			MsgN(Format("%s enter vehicle %s", InInvestigator, FreePassengerSeats[SampleIndex]))

			table.remove(FreePassengerSeats, SampleIndex)
		end
	end
end

function StartVehicleIntro(InDriverSeatName, InPassengerSeatsName)

	SetGlobalInt("CurrentGameState", GAMESTATE_VEHICLEINTRO)

	local AllEntites = ents.GetAll()

	for Index, SampleEntity in ipairs(AllEntites) do

		local SampleEntityName = SampleEntity:GetName()

		if SampleEntityName == InDriverSeatName and SampleEntity:IsVehicle() then

			IntroDriverSeat = SampleEntity

		elseif SampleEntityName == InPassengerSeatsName and SampleEntity:IsVehicle() then

			table.insert(IntroPassengerSeats, SampleEntity)
		end
	end

	MsgN(IntroDriverSeat)

	PrintTable(IntroPassengerSeats)

	local AllInvestigators = team.GetPlayers(TEAM_INVESTIGATOR)

	for Index, SampleInvestigator in ipairs(AllInvestigators) do

		SampleInvestigator:Spawn()
	end

	local AllGhosts = team.GetPlayers(TEAM_GHOST)

	for Index, SampleGhost in ipairs(AllGhosts) do

		SampleGhost:SpectateEntity(table.Random(AllInvestigators))
	end
end

function EndVehicleIntro()

	OnInvestigationStarted()
end

function OnInvestigationStarted()

	SetGlobalInt("CurrentGameState", GAMESTATE_INVESTIGATION)

	local AllPlayers = player.GetAll()

	for Index, SamplePlayer in ipairs(AllPlayers) do

		if not SamplePlayer:IsAlive() or not SamplePlayer:InVehicle() then

			SamplePlayer:Spawn()
		end
	end
end

function OnPlayerSpawnDuringVehicleIntro(InPlayer)

	--MsgN(Format("OnPlayerSpawnDuringVehicleIntro() %s", InPlayer))

	if InPlayer:Team() == TEAM_INVESTIGATOR then

		PickSeatForInvestigator(InPlayer)

	elseif InPlayer:Team() == TEAM_GHOST then

		local AllInvestigators = team.GetPlayers(TEAM_INVESTIGATOR)

		SampleGhost:SpectateEntity(table.Random(AllInvestigators))
	end
end
