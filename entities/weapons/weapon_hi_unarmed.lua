---- Roleplay: Prison

AddCSLuaFile()

if CLIENT then

	SWEP.PrintName			= UtilLocalizable("HI_Weapon.Unarmed")
	
	SWEP.Purpose			= UtilLocalizable("HI_Weapon.Unarmed.Purpose")

	SWEP.Author				= "zana"
end

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.Base                   = "weapon_base"

SWEP.Spawnable				= false

SWEP.ViewModel				= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel				= "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFOV			= 10
SWEP.UseHands				= false

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AllowDelete			= false
SWEP.AllowDrop				= false

function SWEP:Initialize()

	self:SetHoldType("normal")
end

function SWEP:GetClass()

	return "weapon_hi_unarmed"
end

function SWEP:OnDrop()

	self:Remove()
end

function SWEP:ShouldDropOnDie()

	return false
end

function SWEP:PrimaryAttack()


end

function SWEP:SecondaryAttack()
	

end

function SWEP:Reload()
	

end

function SWEP:Deploy()

	local PlayerOwner = self:GetOwner()

	if SERVER and IsValid(PlayerOwner) then

		PlayerOwner:DrawViewModel(false)

		--MsgN("DrawViewModel(false)")
	end

	self:DrawShadow(false)

	return true
end

function SWEP:Holster()

	return true
end

function SWEP:DrawWorldModel()


end

function SWEP:DrawWorldModelTranslucent()


end
