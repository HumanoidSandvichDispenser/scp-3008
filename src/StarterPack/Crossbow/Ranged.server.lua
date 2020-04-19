local Tool = script.Parent
repeat wait() until Tool.Parent.Parent.Character
local Character = Tool.Parent.Parent.Character
local Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
local Humanoid = Tool.Parent.Parent.Character.Humanoid
local ClientToolInput = game:GetService("ReplicatedStorage"):WaitForChild("ClientToolInput")
local TweenService = game:GetService("TweenService")
local IdleAnimation
local ReloadAnimation

local Configuration = {
	Damage = 50, 		-- Damage dealt to players and NPCs
	PropDamage = 10, 	-- Damage dealt to props
	Power = 2, 			-- Determines what props the weapon can damage
	Speed = 400, 		-- Speed of rounds in studs per second
	FireDelay = 0, 		-- Time it takes for the weapon to fire again
	ReloadTime = 3,		-- Time it takes for the weapon to reload
	CosmeticBullet = script.Ammo,
	ReloadAnimation = Humanoid:LoadAnimation(Tool.ReloadAnimation)
}

local RangedWeaponSystem = require(game.ServerScriptService.RangedWeaponSystem)
local RangedWeapon = RangedWeaponSystem.new(Player, Tool, Configuration)

Tool.Equipped:Connect(function()
	IdleAnimation:Play()
end)

Tool.Unequipped:Connect(function()
	IdleAnimation:Stop()
end)

Tool.AncestryChanged:Connect(function(_, parent)
	if parent:IsA("Model") then
		Humanoid = parent.Humanoid
	elseif parent.Name == "Backpack" then
		Humanoid = parent.Parent.Character.Humanoid
	end
	
	ReloadAnimation = Humanoid:LoadAnimation(Tool.ReloadAnimation)
	RangedWeapon.ReloadAnimation = ReloadAnimation
	IdleAnimation = Humanoid:LoadAnimation(Tool.Hold)
	
	RangedWeapon.ReloadAnimation:GetMarkerReachedSignal("Init"):Connect(function()
		Tool.StringPart.StringPoint.Position = Vector3.new(0, 0, -1)--Tool.StringPart.Position + Vector3.new(0, 1, 0)
	end)
	
	RangedWeapon.ReloadAnimation:GetMarkerReachedSignal("Reloading"):Connect(function()
		TweenService:Create(Tool.StringPart.StringPoint, TweenInfo.new(0.1), { Position = Vector3.new(0, 0, 0) }):Play()
	end)
end)

ClientToolInput.OnServerEvent:Connect(function(player, input, tool, origin, direction)
	RangedWeapon:HandleClientToolInput(player, input, tool, origin, direction)
	print("Handling client tool input")
end)