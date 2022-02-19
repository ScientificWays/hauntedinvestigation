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

function GM:CreateTeams()

	TEAM_INVESTIGATOR = 1
	team.SetUp(TEAM_INVESTIGATOR, "HI_Team.Investigators", Color(0, 150, 255))
	team.SetSpawnPoint(TEAM_GUARD, {"info_investigator_respawn"})
	team.SetClass(TEAM_INVESTIGATOR, {"player_investigator"})

	TEAM_GHOST = 2
	team.SetUp(TEAM_GHOST, "HI_Team.Ghosts", Color(255, 150, 0))
	team.SetClass(TEAM_GHOST, {"player_ghost"})

	team.SetUp(TEAM_SPECTATOR, "HI_Role.Spectators", Color(255, 255, 255))
	team.SetSpawnPoint(TEAM_SPECTATOR, {"worldspawn"})
end
