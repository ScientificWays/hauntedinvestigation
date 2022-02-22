---- Haunted Investigation

AddCSLuaFile()

DEFINE_BASECLASS("player_default")

local PLAYER = {}
 
PLAYER.DisplayName          = "Ghost Class"

PLAYER.SlowWalkSpeed        = 200		-- How fast to move when slow-walking (+WALK)
PLAYER.WalkSpeed            = 200		-- How fast to move when not running
PLAYER.RunSpeed             = 200		-- How fast to move when running
PLAYER.CrouchedWalkSpeed    = 0.5		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed            = 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed          = 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower            = 200       -- How powerful our jump should be
PLAYER.CanUseFlashlight     = false		-- Can we use the flashlight
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

local GhostPlayerModels = {
	"zombie",
	"zombiefast",
	"zombine",
	"gman",
	"skeleton",
	"charple",
	"stripped"
}

function PLAYER:SetModel()
	
	local SampleGhostModel = table.Random(GhostPlayerModels)

	local ModelName = player_manager.TranslatePlayerModel(SampleGhostModel)

	util.PrecacheModel(ModelName)

	self.Player:SetModel(ModelName)

	self.Player:SetMaterial("!GhostMaterial")
end

function PLAYER:Spawn()

	self.Player:SetNWBool("bRenderLight", true)

	self.Player:SetNWVector("GhostAreaMin", Vector())

	self.Player:SetNWVector("GhostAreaMax", Vector())

	self.Player:SetNWFloat("SpectralValue", 1.0)

	self.Player:SetNWFloat("EnergyValue", 0.0)
		
	if UtilGetCurrentGameState() == GAMESTATE_VEHICLEINTRO then

		self.Player:Spectate(OBS_MODE_CHASE)

		local AllInvestigators = team.GetPlayers(TEAM_INVESTIGATOR)

		local SpectateInvestigator = table.Random(AllInvestigators)
		
		self.Player:SpectateEntity(SpectateInvestigator)

	elseif UtilGetCurrentGameState() == GAMESTATE_INVESTIGATION then
		
		self.Player:SetNWInt("GhostSpecialSoundCountdown", math.random(30.0, 60.0))

		PickAreaForGhost(self.Player)
	end
end

function PLAYER:Loadout()
 
	self.Player:RemoveAllItems()
 
	
end

player_manager.RegisterClass("player_ghost", PLAYER, "player_default")
