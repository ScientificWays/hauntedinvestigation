---- Haunted Investigation

GM.Name = "Haunted Investigation"
GM.Author = "zana"
GM.Email = "N/A"
GM.Website = "N/A"
GM.TeamBased = true
GM.SecondsBetweenTeamSwitches = 0

COLOR_WHITE  			= Color(255, 255, 255, 255)
COLOR_TRANSPARENT		= Color(255, 255, 255, 0)
COLOR_BLACK  			= Color(0, 0, 0, 255)

COLOR_RED    			= Color(255, 0, 0, 255)
COLOR_YELLOW 			= Color(200, 200, 0, 255)
COLOR_GREEN  			= Color(0, 255, 0, 255)
COLOR_CYAN   			= Color(0, 255, 255, 255)
COLOR_BLUE   			= Color(0, 0, 255, 255)

GAMESTATE_PREGAME		= 1
GAMESTATE_VEHICLEINTRO	= 2
GAMESTATE_INVESTIGATION	= 3
GAMESTATE_POSTGAME		= 4

include("player_class/investigator.lua")
include("player_class/ghost.lua")

function UtilGetCurrentGameState()

	return GetGlobalInt("CurrentGameState")
end

function UtilCanHearByTalkie(InListener, InTalker)

	return InListener:HasWeapon("weapon_hi_talkie")
	and IsValid(InTalker:GetActiveWeapon()) and InTalker:GetActiveWeapon():GetClass() == "weapon_hi_talkie"
	and InListener:GetNWFloat("TalkieFrequency") == InTalker:GetNWFloat("TalkieFrequency")
end

function GM:CreateTeams()

	TEAM_INVESTIGATOR = 1
	team.SetUp(TEAM_INVESTIGATOR, "HI_Team.Investigators", Color(120, 255, 120))
	team.SetSpawnPoint(TEAM_INVESTIGATOR, {"info_investigator_respawn"})
	team.SetClass(TEAM_INVESTIGATOR, {"player_investigator"})

	TEAM_GHOST = 2
	team.SetUp(TEAM_GHOST, "HI_Team.Ghosts", Color(0, 255, 255))
	team.SetClass(TEAM_GHOST, {"player_ghost"})

	team.SetUp(TEAM_SPECTATOR, "HI_Team.Spectators", Color(255, 255, 255))
	team.SetSpawnPoint(TEAM_SPECTATOR, {"worldspawn"})
end

function GM:PlayerFootstep(InPlayer, InPos, InFootIndex, InSoundName, InVolume, InRecipientFilter)

	if not InPlayer:Alive() or InPlayer:Team() == TEAM_GHOST then

		return true
	end

	return false
end

function GM:ShouldCollide(InEntity1, InEntity2)

	--MsgN(InEntity1, InEntity2)

	if InEntity1:IsPlayer() and InEntity2:IsPlayer() then

		return false
	end

	--[[if InEntity2:IsPlayer() then

		InEntity1, InEntity2 = InEntity2, InEntity1
	end--]]

	if InEntity1:GetNWFloat("SpectralValue") > 0.0 and string.StartWith(InEntity2:GetClass(), "prop_") then

		return false
	end

	return true
end
