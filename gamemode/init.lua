---- Haunted Investigation

AddCSLuaFile("sh_util.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_util.lua")

AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_render.lua")

include("sh_util.lua")

include("sv_util.lua")

include("sv_map.lua")
include("sv_intro.lua")
include("sv_ghost.lua")
include("sv_voice.lua")
include("sv_sound.lua")
include("sv_energy.lua")
include("sv_player.lua")
include("sv_commands.lua")

util.AddNetworkString("SendChatMessageToClients")

function GM:Initialize()

	MsgN("Server Initialize()")
	
	SetGlobalInt("CurrentGameState", GAMESTATE_PREGAME)
	
	RunConsoleCommand("mp_show_voice_icons", "0")

	self.BaseClass:Initialize()
end

function GM:InitPostEntity()

	MsgN("Server InitPostEntity()")

	--InitMapAreas()

	self.BaseClass:InitPostEntity()

	timer.Simple(1.0, function()

		local DebugInvestigator = player.CreateNextBot("Саня")

		GAMEMODE:PlayerJoinTeam(DebugInvestigator, TEAM_INVESTIGATOR)

		DebugInvestigator:Spawn()

		local DebugGhost = player.CreateNextBot("Дима")

		GAMEMODE:PlayerJoinTeam(DebugGhost, TEAM_GHOST)

		DebugGhost:Spawn()
	end)
end

function GM:PlayerNoClip(InPlayer, bDesiredNoClipState)
	
	return InPlayer:Alive()
end

--[[function GM:Tick()


end]]

--Редкий пушок света на месте нематериализованного призрака
--Интерфейс активации ближайшего spooky триггера наблюдателей
--саботажи призраков (закрытие дверей и т.д.)
--голосовое взаимодействие с призраками
