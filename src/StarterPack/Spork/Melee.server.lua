local Tool = script.Parent
local Animation = Tool.Attack
local Character = Tool.Parent.Parent.Character
local Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
local Humanoid = Tool.Parent.Parent.Character.Humanoid
local HitSound = Tool.Hit
local SwingSound = Tool.Swing
local ClientToolInput = game:GetService("ReplicatedStorage"):WaitForChild("ClientToolInput")

local MeleeSystem = require(game.ServerScriptService.MeleeSystem)

local Configuration = {
	Damage = 12,
	PropDamage = 2,
	Power = 1,
	HitSound = Tool.Hit,
	DmgPointSource = Tool.Part
}

local MeleeWeapon = MeleeSystem.new(Tool, Player, Configuration)

Tool.Activated:Connect(function()
	if Tool.Enabled then
		Tool.Enabled = false
		MeleeWeapon.Attacking = true
		Humanoid:LoadAnimation(Animation):Play()
		SwingSound:Play()
		
		wait(0.25)
		if MeleeWeapon:HandleFeinting() then
			Humanoid:LoadAnimation(Animation):Stop(0.25)
			return
		end
		MeleeWeapon.Raycast:HitStart()
		
		wait(0.35)
		MeleeWeapon.Raycast:HitStop()
		MeleeWeapon.Attacking = false
		
		wait(0.2)
		Tool.Enabled = true
		Humanoid:LoadAnimation(Animation):Stop()
		SwingSound:Stop()
	end
end)

Tool.Equipped:Connect(function()
	MeleeWeapon:UpdatePlayer(game:GetService("Players"):GetPlayerFromCharacter(Tool.Parent))
	Humanoid:LoadAnimation(Tool.Idle):Play()
end)

Tool.Unequipped:Connect(function()
	Humanoid:LoadAnimation(Tool.Idle):Stop()
end)

ClientToolInput.OnServerEvent:Connect(function(player, input, tool)
	MeleeWeapon:HandleClientToolInput(player, input, tool)
end)