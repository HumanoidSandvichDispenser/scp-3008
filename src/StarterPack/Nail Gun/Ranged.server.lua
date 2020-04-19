local Tool = script.Parent
repeat wait() until Tool.Parent.Parent.Character
local Character = Tool.Parent.Parent.Character
local Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
local Humanoid = Tool.Parent.Parent.Character.Humanoid
local ClientToolInput = game:GetService("ReplicatedStorage"):WaitForChild("ClientToolInput")
local TweenService = game:GetService("TweenService")
local ReloadAnimation = Humanoid:LoadAnimation(Tool.ReloadAnimation)

local Configuration = {
	Damage = 25, 		-- Damage dealt to players and NPCs
	PropDamage = 5, 	-- Damage dealt to props
	Power = 2, 			-- Determines what props the weapon can damage
	Speed = 800, 		-- Speed of rounds in studs per second
	FireDelay = 0.25, 	-- Time it takes for the weapon to fire again
	ReloadTime = 4,		-- Time it takes for the weapon to reload
	Deviation = 2,  	-- Determins the maximum angles the projectile can deviate
	CosmeticBullet = script.Ammo,
	ReloadAnimation = Humanoid:LoadAnimation(Tool.ReloadAnimation),
	AmmoOffset = CFrame.Angles(math.rad(-90), 0, math.rad(-90)),
	
}

local RangedWeaponSystem = require(game.ServerScriptService.RangedWeaponSystem)
local RangedWeapon = RangedWeaponSystem.new(Player, Tool, Configuration)

script.Parent.Equipped:Connect(function()
	Humanoid:LoadAnimation(Tool.Hold):Play()
end)

script.Parent.Unequipped:Connect(function()
	Humanoid:LoadAnimation(Tool.Hold):Stop()
end)

ClientToolInput.OnServerEvent:Connect(function(player, input, tool, origin, direction)
	RangedWeapon:HandleClientToolInput(player, input, tool, origin, direction)
	print("Handling client tool input")
end)

ReloadAnimation:GetMarkerReachedSignal("Init"):Connect(function()
	print("Fired!!!!")
end)

ReloadAnimation:GetMarkerReachedSignal("Reloading"):Connect(function()
	print("Reloading!!!")
end)