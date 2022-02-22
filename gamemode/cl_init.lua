---- Haunted Investigation

include("sh_util.lua")

include("cl_util.lua")

include("cl_hud.lua")
include("cl_render.lua")

surface.CreateFont("HUDText", {font = "Tahoma",
									size = 32,
									weight = 600})
surface.CreateFont("HUDTextSmall", {font = "Tahoma",
									size = 18,
									weight = 500})

function GM:Initialize()

	MsgN("Client Initialize()")

	net.Receive("SendChatMessageToClients", UtilClientReceiveChatMessage)
	
	self.BaseClass:Initialize()
end

function GM:InitPostEntity()

	MsgN("Client InitPostEntity()")

	self.BaseClass:InitPostEntity()
end
