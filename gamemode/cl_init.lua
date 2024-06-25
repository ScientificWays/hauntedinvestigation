---- Haunted Investigation

include("sh_util.lua")
include("sh_props.lua")
include("sh_spectator.lua")

include("cl_util.lua")

include("cl_hud.lua")
include("cl_guide.lua")
include("cl_props.lua")
include("cl_render.lua")
include("cl_keypad.lua")
include("cl_spectator.lua")

surface.CreateFont("HUDText", {font = "Tahoma",
									size = 32,
									weight = 600})
surface.CreateFont("HUDTextSmall", {font = "Tahoma",
									size = 22,
									weight = 500})

function GM:Initialize()

	MsgN("Client Initialize()")

	net.Receive("ClientOpenGuide", function(InMessageLength, InPlayer)

		ShowGuide(net.ReadInt(32))
	end)

	net.Receive("ClientOpenKeypad", function(InMessageLength, InPlayer)

		ShowKeypad()
	end)

	net.Receive("ClientOpenSoundInterface", function(InMessageLength, InPlayer)

		ShowSoundInterface()
	end)

	net.Receive("SendChatMessageToClients", UtilClientReceiveChatMessage)
	
	self.BaseClass:Initialize()
end

function GM:InitPostEntity()

	MsgN("Client InitPostEntity()")

	self.BaseClass:InitPostEntity()

	CreatePropSpawnPreviewModel()
end
