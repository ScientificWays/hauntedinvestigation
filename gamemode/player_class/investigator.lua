---- Haunted Investigation

AddCSLuaFile()

DEFINE_BASECLASS("player_default")
 
local PLAYER = {} 
 
PLAYER.DisplayName          = "Investigator Class"

PLAYER.SlowWalkSpeed        = 100		-- How fast to move when slow-walking (+WALK)
PLAYER.WalkSpeed            = 150		-- How fast to move when not running
PLAYER.RunSpeed             = 240		-- How fast to move when running
PLAYER.CrouchedWalkSpeed    = 0.5		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed            = 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed          = 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower            = 200       -- How powerful our jump should be
PLAYER.CanUseFlashlight     = true		-- Can we use the flashlight
PLAYER.MaxHealth            = 100		-- Max health we can have
PLAYER.MaxArmor             = 100		-- Max armor we can have
PLAYER.StartHealth          = 100		-- How much health we start with
PLAYER.StartArmor           = 0			-- How much armour we start with
PLAYER.DropWeaponOnDie      = false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide    = false		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers         = true		-- Automatically swerves around other players
PLAYER.UseVMHands           = true		-- Uses viewmodel hands

function PLAYER:Init()
	

end

function PLAYER:SetModel()
	
	BaseClass.SetModel(self)

	local PlayerSkin = self.Player:GetInfoNum("cl_playerskin", 0)

	self.Player:SetSkin(PlayerSkin)

	local PlayerBodyGroups = self.Player:GetInfo("cl_playerbodygroups") or ""

	local PlayerBodyGroups = string.Explode(" ", PlayerBodyGroups)

	for SampleIndex = 0, self.Player:GetNumBodyGroups() - 1 do

		self.Player:SetBodygroup(SampleIndex, tonumber(PlayerBodyGroups[SampleIndex + 1]) or 0)
	end

	self.Player:SetMaterial("")

	self.Player:DrawShadow(true)
end

function PLAYER:Spawn()

	--MsgN(Format("%s Spawn()", self.Player))

	self.Player:AllowFlashlight(true)

	self.Player:SetNWBool("bRenderLight", UtilGetCurrentGameState() ~= GAMESTATE_INVESTIGATION)

	self.Player:SetNWFloat("EnergyValue", 1.0)

	self.Player:SetNWFloat("SpectralValue", 0.0)

	if UtilGetCurrentGameState() == GAMESTATE_VEHICLEINTRO then

		PickSeatForInvestigator(self.Player)
	end
end

function PLAYER:Loadout()
 
	self.Player:RemoveAllItems()
 
	self.Player:Give("weapon_hi_unarmed")
	self.Player:Give("weapon_hi_fists")
	self.Player:Give("weapon_hi_talkie")

	self.Player:Give("weapon_crowbar")
end
 
player_manager.RegisterClass("player_investigator", PLAYER, "player_default")
