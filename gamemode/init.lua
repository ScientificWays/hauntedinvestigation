---- Haunted Investigation

AddCSLuaFile("sh_util.lua")
AddCSLuaFile("sh_props.lua")
AddCSLuaFile("sh_spectator.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_util.lua")

AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_guide.lua")
AddCSLuaFile("cl_props.lua")
AddCSLuaFile("cl_render.lua")
AddCSLuaFile("cl_keypad.lua")
AddCSLuaFile("cl_spectator.lua")

include("sh_util.lua")
include("sh_props.lua")
include("sh_spectator.lua")

include("sv_util.lua")

include("sv_map.lua")
include("sv_props.lua")
include("sv_intro.lua")
include("sv_ghost.lua")
include("sv_voice.lua")
include("sv_sound.lua")
include("sv_energy.lua")
include("sv_player.lua")
include("sv_interact.lua")
include("sv_commands.lua")
include("sv_spectator.lua")
include("sv_sabotages.lua")
include("sv_investigation.lua")

util.AddNetworkString("ClientOpenGuide")
util.AddNetworkString("ClientOpenKeypad")
util.AddNetworkString("ClientOpenSoundInterface")

util.AddNetworkString("SendTryUseKeypadCode")
util.AddNetworkString("SendChatMessageToClients")
util.AddNetworkString("SendTryPlaySpectatorSound")

function GM:Initialize()

	MsgN("Server Initialize()")

	net.Receive("SendTryUseKeypadCode", ServerReceiveTryUseKeypadCode)

	net.Receive("SendTryPlaySpectatorSound", ServerReceiveTryPlaySpectatorSound)

	RunConsoleCommand("mp_show_voice_icons", "0")

	self.BaseClass:Initialize()
end

function GM:InitPostEntity()

	MsgN("Server InitPostEntity()")

	self.BaseClass:InitPostEntity()

	SetGlobalInt("CurrentGameState", GAMESTATE_PREGAME)

	--timer.Simple(0.0, function()

		InitMap()
	--end)

	--[[timer.Simple(1.0, function()

		local DebugInvestigator = player.CreateNextBot("Саня")

		GAMEMODE:PlayerJoinTeam(DebugInvestigator, TEAM_INVESTIGATOR)

		local DebugGhost = player.CreateNextBot("Дима")

		GAMEMODE:PlayerJoinTeam(DebugGhost, TEAM_GHOST)

		local DebugGhost2 = player.CreateNextBot("Дима2")

		GAMEMODE:PlayerJoinTeam(DebugGhost2, TEAM_GHOST)

		local DebugGhost3 = player.CreateNextBot("Дима3")

		GAMEMODE:PlayerJoinTeam(DebugGhost3, TEAM_GHOST)
	end)--]]
end

--[[function GM:Tick()


end]]

--Больше функций для призраков
--Более понятные цели маппинга
