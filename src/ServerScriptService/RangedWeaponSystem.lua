local RangedWeapon = { }
local PropDamage = require(script.Parent.PropDamage)
local FastCast = require(script.Parent.FastCastRedux)
local Debris = game:GetService("Debris")
RangedWeapon.__index = RangedWeapon

function RangedWeapon.new(player, tool, configuration) -- tool, player, damage, propDmg, power, hitsound, speed, fireDelay, cosmeticBullet, reloadAnimation, reloadTime
	local newRangedWeapon = { }
	setmetatable(newRangedWeapon, RangedWeapon)
	newRangedWeapon.Firing = false
	
	newRangedWeapon.Player = player
	newRangedWeapon.Tool = tool
	newRangedWeapon.Damage = configuration.Damage or 20
	newRangedWeapon.PropDamage = configuration.PropDamage or 1
	newRangedWeapon.Power = configuration.Power or 1
	newRangedWeapon.HitSound = configuration.HitSound
	newRangedWeapon.Speed = configuration.Speed or 500
	newRangedWeapon.FireDelay = configuration.FireDelay or 1
	newRangedWeapon.CosmeticBullet = configuration.CosmeticBullet
	newRangedWeapon.ReloadAnimation = configuration.ReloadAnimation
	newRangedWeapon.ReloadTime = configuration.ReloadTime or 3
	newRangedWeapon.AmmoOffset = configuration.AmmoOffset or CFrame.Angles(0, 0, 0)
	newRangedWeapon.Deviation = configuration.Deviation or 0
	
	newRangedWeapon.Caster = FastCast.new()
	newRangedWeapon.Caster.RayHit:Connect(function(hitPart, hitPoint, normal, material, cosmeticBulletObject)
		
		if hitPart then
			newRangedWeapon:DamageObject(hitPart)
			cosmeticBulletObject.Position = hitPoint
			local weld = Instance.new("WeldConstraint", cosmeticBulletObject)
			weld.Part0 = hitPart
			weld.Part1 = cosmeticBulletObject
			cosmeticBulletObject.CanCollide = false
			Debris:AddItem(cosmeticBulletObject, 20)
			MakeParticleFX(hitPart, hitPoint, normal)
		else
			cosmeticBulletObject:Destroy() -- Destroy the cosmetic bullet.
		end
	end)
	
	newRangedWeapon.Caster.LengthChanged:Connect(function(castOrigin, segmentOrigin, segmentDirection, length, cosmeticBulletObject)
	-- Whenever the caster steps forward by one unit, this function is called.
	-- The bullet argument is the same object passed into the fire function.
		local bulletLength = cosmeticBulletObject.Size.Z / 2 -- This is used to move the bullet to the right spot based on a CFrame offset
		local baseCFrame = CFrame.new(segmentOrigin, segmentOrigin + segmentDirection)
		cosmeticBulletObject.CFrame = baseCFrame * CFrame.new(0, 0, -(length - bulletLength)) * newRangedWeapon.AmmoOffset
	end)
		
	return newRangedWeapon
end


function RangedWeapon:DamageObject(hit, humanoid)
	if humanoid then
		humanoid:TakeDamage(self.Damage)
		--self.HitSound:Play()
	else
		humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			if hit.Name == "Head" then
				humanoid:TakeDamage(self.Damage * 1.5)
			else
				humanoid:TakeDamage(self.Damage)
			end
		elseif hit.Parent:IsA("Accessory") and hit.Parent.Parent:FindFirstChild("Humanoid") then
			hit.Parent.Parent.Humanoid:TakeDamage(self.Damage * 1.5)
			--self.HitSound:Play()
		elseif hit.Parent:IsA("Model") and hit.Parent:FindFirstChild("Health") then
			PropDamage.DamageProp(hit.Parent, self.PropDamage, self.Player)
		end
	end
end

function RangedWeapon:Fire(origin, direction)
	if (origin.Position - self.Player.Character.HumanoidRootPart.CFrame.Position).Magnitude < 8 then
		local random = Random.new(tick())
		local deviation = self.Deviation / 2
		local x, y, z = random:NextNumber(-deviation, deviation),
			random:NextNumber(-deviation, deviation), random:NextNumber(-deviation, deviation)
			
		local newAngle = CFrame.new(Vector3.new(0, 0, 0), direction) * CFrame.Angles(math.rad(x), math.rad(y), math.rad(z))
		direction = newAngle.LookVector
		
		local bullet = self.CosmeticBullet:Clone()
		bullet.CFrame = CFrame.new(origin.Position, origin.Position + direction)
		bullet.Parent = workspace
		
		self.Caster:Fire(origin.Position, direction * 1000, self.Speed, bullet, self.Tool.Parent, false, Vector3.new(0, -40, 0), CanRayPierce)
	end
end

function RangedWeapon:HandleClientToolInput(player, input, tool, origin, direction)
	--print(self.Player.Name .. self.Tool.Name .. input .. tool.Name)
	if self.Player.Name == player.Name and self.Tool == tool and self.Tool.Parent == self.Player.Character then
		if input == "MouseButton1Down" then
			if not self.Firing and self.Tool.Ammo.Value > 0 then
				self.Firing = true
				self.Tool.Ammo.Value = self.Tool.Ammo.Value - 1
				
				if self.Tool:FindFirstChild("Fire") then
					self.Tool.Fire:Play()
				end
				
				self:Fire(origin * CFrame.new(0, 1, 0), direction)
				
				print(self.Tool.Ammo.Value)
				wait(self.FireDelay)
				if self.Tool.Ammo.Value == 0 then
					print("Reloading!")
					
					if self.Tool:FindFirstChild("ReloadAnimation") then
						self.ReloadAnimation:Play()
					end
					
					if self.Tool:FindFirstChild("Reload") then
						self.Tool.Reload:Play()
					end
					
					wait(self.ReloadTime)
					self.Tool.Ammo.Value = self.Tool.MaxAmmo.Value
					self.Firing = false
				else
					self.Firing = false
				end
			end
		end
	end
end

function CanRayPierce(hitPart, hitPoint, normal, material)
	-- This function shows off the piercing feature. Pass this function as the last argument (after bulletAcceleration) and it will run this every time the ray runs into an object.
	if material == Enum.Material.Plastic or material == Enum.Material.Ice or material == Enum.Material.Glass or material == Enum.Material.SmoothPlastic then
		-- Hit glass, plastic, or ice...
		if hitPart.Transparency >= 0.5 then
			-- And it's >= half transparent...
			return true -- Yes! We can pierce.
		end
	end
	return false -- No, we can't pierce.
end

function MakeParticleFX(part, position, normal)
	-- This is a trick I do with attachments all the time.
	-- Parent attachments to the Terrain - It counts as a part, and setting position/rotation/etc. of it will be in world space.
	-- UPD 11 JUNE 2019 - Attachments now have a "WorldPosition" value, but despite this, I still see it fit to parent attachments to terrain since its position never changes.
	local attachment = Instance.new("Attachment")
	attachment.CFrame = CFrame.new(position, position + normal)
	attachment.Parent = workspace.Terrain
	local particle = script.ImpactParticle:Clone()
	if part.Parent:FindFirstChild("Humanoid") then
		particle.Color = ColorSequence.new(Color3.fromRGB(155, 2, 5))
	else
		particle.Color = ColorSequence.new(part.Color)
	end
	particle.Parent = attachment
	Debris:AddItem(attachment, particle.Lifetime.Max) -- Automatically delete the particle effect after its maximum lifetime.
	particle:Emit(8)
end

return RangedWeapon