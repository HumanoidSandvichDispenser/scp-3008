local Tool = script.Parent
local Animation = Tool.Attack
local Character = Tool.Parent.Parent.Character
local Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
local Humanoid = Tool.Parent.Parent.Character.Humanoid
local PlayersTouching = { }
local HitSound = Tool.Hit
local SwingSound = Tool.Swing
local RaycastHitbox = require(game.ServerScriptService.RaycastHitbox)
local ClientToolInput = game:GetService("ReplicatedStorage"):WaitForChild("ClientToolInput")

local MeleeSystem = require(game.ServerScriptService.MeleeSystem)
local MeleeWeapon = MeleeSystem.new(Tool, Player, 30, 15, 3, HitSound)

--RaycastHitbox:DebugMode(true)
local NewHitbox = RaycastHitbox:Initialize(Tool.Part, {Character, Tool.Part, Tool.SpearHead})
NewHitbox:PartMode(true)
NewHitbox.OnHit:Connect(function(hit, humanoid)
	MeleeWeapon:DamageObject(hit, humanoid)
end)

script.Parent.Equipped:Connect(function()
	Humanoid:LoadAnimation(Tool.Idle):Play()
end)

script.Parent.Unequipped:Connect(function()
	Humanoid:LoadAnimation(Tool.Idle):Stop()
end)

script.Parent.Activated:Connect(function()
	if Tool.Enabled then
		Tool.Enabled = false
		MeleeWeapon.Attacking = true
		Humanoid:LoadAnimation(Animation):Play()
		SwingSound:Play()
		
		wait(0.1)
		if MeleeWeapon:HandleFeinting() then
			Humanoid:LoadAnimation(Animation):Stop(0.25)
			return
		end
		NewHitbox:HitStart()
		
		wait(0.2)
		NewHitbox:HitStop()
		MeleeWeapon.Attacking = false
		
		wait(0.3)
		Tool.Enabled = true
		Humanoid:LoadAnimation(Animation):Stop()
		SwingSound:Stop()
	end
end)

ClientToolInput.OnServerEvent:Connect(function(player, input, tool)
	MeleeWeapon:HandleClientToolInput(player, input, tool)
end)