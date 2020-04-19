local PropDamage = { }
local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local PropInfo = {
	Pallet = {
		DebrisMaterial = Enum.Material.Wood,
		DebrisColor = Color3.fromRGB(232, 202, 167),
		Drop = ServerStorage.Items["Wood"],
		Count = 16
	},
	
	Ladder = {
		DebrisMaterial = Enum.Material.Metal,
		DebrisColor = Color3.fromRGB(125, 125, 125),
		Drop = ServerStorage.Items["Scrap Metal"],
		Count = 12
	},
	
	["Gray Kallax"] = {
		DebrisMaterial = Enum.Material.Wood,
		DebrisColor = Color3.fromRGB(128, 128, 128),
		Drop = ServerStorage.Items["Wood"],
		Count = 2
	},
	
	["Black Kallax"] = {
		DebrisMaterial = Enum.Material.Wood,
		DebrisColor = Color3.fromRGB(12, 12, 12),
		Drop = ServerStorage.Items["Wood"],
		Count = 2
	},
	
	["White Kallax"] = {
		DebrisMaterial = Enum.Material.Wood,
		DebrisColor = Color3.fromRGB(255, 255, 255),
		Drop = ServerStorage.Items["Wood"],
		Count = 2
	},
	
	["White Chair"] = {
		DebrisMaterial = Enum.Material.Wood,
		DebrisColor = Color3.fromRGB(255, 255, 255),
		Drop = ServerStorage.Items["Wood"],
		Count = 2
	},
	
	["Coffee Table"] = {
		DebrisMaterial = Enum.Material.Wood,
		DebrisColor = Color3.fromRGB(107, 78, 55),
		Drop = ServerStorage.Items["Wood"],
		Count = 4
	},
}

function PropDamage.DamageProp(prop, damage, attacker)
	local health = prop:FindFirstChild("Health")
	local maxHealth = prop:FindFirstChild("MaxHealth")
	if health then
		health.Value = health.Value - damage
		
		if prop.PrimaryPart:FindFirstChild("DamageParticle") then
			prop.PrimaryPart.DamageParticle:Emit(16)
		end
		
		if health.Value <= 0 then
			
			prop.PrimaryPart.Anchored = false
			local breakSound = prop:FindFirstChild("Break")
			breakSound.Parent = attacker
			breakSound:Play()
			breakSound.Ended:Connect(function() breakSound:Destroy() end)
			
			local propSize = prop:GetExtentsSize()
			local random = Random.new()
			
			local drop = PropInfo[prop.Name].Drop:Clone()
			drop.Handle.CFrame = prop.PrimaryPart.CFrame
			drop.Parent = workspace.Items
			drop:FindFirstChild("Count").Value = PropInfo[prop.Name].Count
			
			for i = 1, 10 do
				local debrisPart = Instance.new("Part", workspace)
				local offset = Vector3.new(random:NextNumber(-propSize.X / 2, propSize.X / 2),
					0, random:NextNumber(-propSize.Z / 2, propSize.Z / 2))
				
				PhysicsService:SetPartCollisionGroup(debrisPart, "Debris")
				
				debrisPart.Name = "Debris"
				debrisPart.Material = PropInfo[prop.Name].DebrisMaterial
				debrisPart.Color = PropInfo[prop.Name].DebrisColor
				debrisPart.Size = Vector3.new(random:NextNumber(0.1, 2), random:NextNumber(0.1, 2), random:NextNumber(0.1, 2))
				debrisPart.CFrame = prop.PrimaryPart.CFrame * CFrame.Angles(random:NextNumber(0, math.pi),
					random:NextNumber(0, math.pi), random:NextNumber(0, math.pi)) + offset
				debrisPart.Velocity = Vector3.new(random:NextNumber(-25, 25), random:NextNumber(2, 25), random:NextNumber(-25, 25))
				
				TweenService:Create(
					debrisPart,
					TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 1, false, 1.5),
					{ Transparency = 1 }
				):Play()
				
				Debris:AddItem(debrisPart, 3)
			end
			
			if prop then
				prop:Destroy()
			end
			
		elseif health.Value <= math.ceil(maxHealth.Value / 5) then
			--prop.PrimaryPart.Anchored = false
		end
	end
end

return PropDamage