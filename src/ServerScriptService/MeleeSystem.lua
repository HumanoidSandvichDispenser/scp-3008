local MeleeWeapon = { }
local PropDamage = require(script.Parent.PropDamage)
local RaycastHitbox = require(game.ServerScriptService.RaycastHitbox)

MeleeWeapon.__index = MeleeWeapon

function MeleeWeapon.new(tool, player, config)
	local newMeleeWeapon = { }
	setmetatable(newMeleeWeapon, MeleeWeapon)
	newMeleeWeapon.Feinting = false
	newMeleeWeapon.Attacking = false
	newMeleeWeapon.Blocking = false
	
	newMeleeWeapon.Tool = tool
	newMeleeWeapon.Player = player
	newMeleeWeapon.Damage = config.Damage or 10
	newMeleeWeapon.PropDamage = config.PropDamage or 5
	newMeleeWeapon.Power = config.Power or 1
	newMeleeWeapon.HitSound = config.HitSound
	newMeleeWeapon.DmgPointSource = config.DmgPointSource
	return newMeleeWeapon
end


function MeleeWeapon:DamageObject(hit, humanoid)
	if humanoid then
		humanoid:TakeDamage(self.Damage)
		self.HitSound:Play()
	else
		humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			if hit.Name == "Head" then
				humanoid:TakeDamage(self.Damage * 2.5)
			else
				humanoid:TakeDamage(self.Damage)
			end
			self.HitSound:Play()
		elseif hit.Parent:IsA("Model") and hit.Parent:FindFirstChild("Health") then
			PropDamage.DamageProp(hit.Parent, self.PropDamage, self.Player)
		end
	end
end


function MeleeWeapon:HandleFeinting()
	if self.Feinting then
		self.Feinting = false
		self.Attacking = false
		self.Tool.Enabled = true
		return true
	end
	return false
end

function MeleeWeapon:HandleClientToolInput(player, input, tool)
	--print(self.Player.Name .. self.Tool.Name .. input .. tool.Name)
	if self.Player.Name == player.Name and self.Tool == tool then
		if input == "MouseButton2Down" then
			if self.Attacking then -- Only feint if user is currently attacking
				self.Feinting = true
			else
				self.Blocking = true
			end
		elseif input == "MouseButton2Up" then
			if not self.Attacking then
				self.Blocking = false
			end
		end
	end
end

function MeleeWeapon:UpdatePlayer(player)
	self.Player = player
	RaycastHitbox:Deinitialize(self.DmgPointSource) -- Remove last raycast hitbox to initialize a new one
	self.Raycast = RaycastHitbox:Initialize(self.DmgPointSource, {player.Character, self.Tool})
	self.Raycast:PartMode(true)
	
	self.Raycast.OnHit:Connect(function(hit, humanoid)
		self:DamageObject(hit, humanoid)
	end)
end
--[[
script.UpdatePlayer.Event:Connect(function(meleeWeapon, player)
	
end)
]]

return MeleeWeapon