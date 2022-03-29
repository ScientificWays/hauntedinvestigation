---- Haunted Investigation

AddCSLuaFile("sh_util.lua")
AddCSLuaFile("sh_spectator.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_util.lua")

AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_render.lua")
AddCSLuaFile("cl_spectator.lua")

include("sh_util.lua")
include("sh_spectator.lua")

include("sv_util.lua")

include("sv_map.lua")
include("sv_intro.lua")
include("sv_ghost.lua")
include("sv_voice.lua")
include("sv_sound.lua")
include("sv_energy.lua")
include("sv_player.lua")
include("sv_commands.lua")
include("sv_spectator.lua")
include("sv_sabotages.lua")
include("sv_investigation.lua")

util.AddNetworkString("ClientOpenSoundInterface")

util.AddNetworkString("SendChatMessageToClients")
util.AddNetworkString("SendTryPlaySpectatorSound")

function GM:Initialize()

	MsgN("Server Initialize()")

	net.Receive("SendTryPlaySpectatorSound", ServerReceiveTryPlaySpectatorSound)

	RunConsoleCommand("mp_show_voice_icons", "0")

	self.BaseClass:Initialize()
end

function GM:InitPostEntity()

	MsgN("Server InitPostEntity()")

	self.BaseClass:InitPostEntity()

	SetGlobalInt("CurrentGameState", GAMESTATE_PREGAME)

	InitMap()

	timer.Simple(1.0, function()

		local DebugInvestigator = player.CreateNextBot("Саня")

		GAMEMODE:PlayerJoinTeam(DebugInvestigator, TEAM_INVESTIGATOR)

		DebugInvestigator:Spawn()

		local DebugGhost = player.CreateNextBot("Дима")

		GAMEMODE:PlayerJoinTeam(DebugGhost, TEAM_GHOST)

		DebugGhost:Spawn()
	end)
end

--[[function GM:Tick()


end]]
