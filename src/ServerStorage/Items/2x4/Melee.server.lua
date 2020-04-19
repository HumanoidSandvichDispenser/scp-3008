local Tool = script.Parent
local Animation = Tool.Attack
local Character = Tool.Parent.Parent.Character
local Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
local Humanoid = Tool.Parent.Parent.Character.Humanoid
local HitSound = Tool.Hit
local SwingSound = Tool.Swing
local RaycastHitbox = require(game.ServerScriptService.RaycastHitbox)
local ClientToolInput = game:GetService("ReplicatedStorage"):WaitForChild("ClientToolInput")

local Damage = 15
local MeleeSystem = require(game.ServerScriptService.MeleeSystem)
local MeleeWeapon = MeleeSystem.new(Tool, Player)

--RaycastHitbox:DebugMode(true)
local NewHitbox = RaycastHitbox:Initialize(Tool.Part, {Character, Tool.Part})
NewHitbox.OnHit:Connect(function(hit, humanoid)
	--- Do not put events on a loop, else you will memory leak and it will damage multiple times!!
	print(hit.Parent.Name)
	humanoid:TakeDamage(Damage)
	HitSound:Play()
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
		
		wait(0.25)
		if MeleeWeapon:HandleFeinting() then
			Humanoid:LoadAnimation(Animation):Stop()
			return
		end
		NewHitbox:HitStart()
		
		wait(0.35)
		NewHitbox:HitStop()
		MeleeWeapon.Attacking = false
		
		wait(0.2)
		Tool.Enabled = true
		Humanoid:LoadAnimation(Animation):Stop()
		SwingSound:Stop()
	end
end)
ClientToolInput.OnServerEvent:Connect(function(player, input, tool)
	MeleeWeapon:HandleClientToolInput(player, input, tool)
end)