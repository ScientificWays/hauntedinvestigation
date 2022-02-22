---- Haunted Investigation

local IntroDriverSeat = nil

local IntroPassengerSeats = {}

function PickSeatForInvestigator(InInvestigatorPlayer)

	--MsgN(Format("PickSeatForInvestigator() %s", InInvestigatorPlayer))

	if not IsValid(IntroDriverSeat:GetDriver()) then

		InInvestigatorPlayer:EnterVehicle(IntroDriverSeat)

		MsgN(Format("%s enter vehicle %s", InInvestigatorPlayer, IntroDriverSeat))
	else
		local FreePassengerSeats = {}

		for Index, SamplePassengerSeat in ipairs(IntroPassengerSeats) do

			if not IsValid(SamplePassengerSeat:GetDriver()) then

				table.insert(FreePassengerSeats, SamplePassengerSeat)
			end
		end

		PrintTable(FreePassengerSeats)

		if not table.IsEmpty(FreePassengerSeats) then

			local SampleFreeSeat = table.Random(FreePassengerSeats)

			InInvestigatorPlayer:EnterVehicle(SampleFreeSeat)

			MsgN(Format("%s enter vehicle %s", InInvestigatorPlayer, SampleFreeSeat))
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

		SampleGhost:Spectate(OBS_MODE_CHASE)
		
		SampleGhost:SpectateEntity(table.Random(AllInvestigators))
	end
end

function TryEndVehicleIntro()

	if UtilGetCurrentGameState() ~= GAMESTATE_VEHICLEINTRO then

		return
	end
end
