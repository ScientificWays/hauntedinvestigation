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

function OnIntroStarted(InIntroData)

	SetGlobalInt("CurrentGameState", GAMESTATE_VEHICLEINTRO)

	local IntroRelay = ents.FindByName(InIntroData.RelayName)[1]

	IntroRelay:Input("Trigger")

	local AllEntites = ents.GetAll()

	for Index, SampleEntity in ipairs(AllEntites) do

		local SampleEntityName = SampleEntity:GetName()

		if SampleEntityName == InIntroData.DriverSeatName and SampleEntity:IsVehicle() then

			IntroDriverSeat = SampleEntity

		elseif SampleEntityName == InIntroData.PassengerSeatName and SampleEntity:IsVehicle() then

			table.insert(IntroPassengerSeats, SampleEntity)
		end
	end

	--MsgN(IntroDriverSeat)

	--PrintTable(IntroPassengerSeats)

	UtilDoForPlayers(team.GetPlayers(TEAM_INVESTIGATOR), function(InIndex, InPlayer)

		InPlayer:Spawn()
	end)

	UtilDoForPlayers(team.GetPlayers(TEAM_GHOST), function(InIndex, InPlayer)

		InPlayer:Spectate(OBS_MODE_CHASE)
		
		InPlayer:SpectateEntity(table.Random(team.GetPlayers(TEAM_INVESTIGATOR)))
	end)
end
