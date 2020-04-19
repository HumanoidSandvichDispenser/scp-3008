local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientPickUpProp = ReplicatedStorage:WaitForChild("ClientPickUpProp")
local ClientPlaceProp = ReplicatedStorage:WaitForChild("ClientPlaceProp")
local ClientAnchorProp = ReplicatedStorage:WaitForChild("ClientAnchorProp")
local ClientPickUpItem = ReplicatedStorage:WaitForChild("ClientPickUpItem")
local ServerPlaySound = ReplicatedStorage:WaitForChild("ServerPlaySound")
local AnchorSound = ReplicatedStorage:WaitForChild("Anchor")

ClientPickUpProp.OnServerInvoke = function(Player, prop)
	if not Player.Character or not prop then
		return false
	end
	
	local magnitude = (Player.Character.HumanoidRootPart.Position - prop.PrimaryPart.Position).magnitude

	if magnitude < 8 then
		prop.PrimaryPart.CFrame = (CFrame.new(0, -50, 0)) -- Place prop in temporary space while client places the position preview
		
		for i, v in pairs(prop:GetChildren()) do
			if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
				v.Anchored = true
				v.CanCollide = false
				v.Transparency = .8
			end
		end
		return true
	end
	return false
end

ClientPlaceProp.OnServerInvoke = function(Player, prop, positionPreviewCFrame, anchor)
	print("Attempting to place " .. prop.Name .. " at " .. tostring(positionPreviewCFrame))
	
	if not Player.Character then
		print("Can not place, player's character does not exist")
		return false
	end
	
	local Character = Player.Character
	
	if anchor then
		local pos = Character.HumanoidRootPart.Position
		print("Attempting to anchor " .. prop.Name)
		for i = 1, 20 do
			if Character:WaitForChild("Head").Velocity.magnitude > 4 then -- If the player moves faster than 4 studs per second, anchoring is cancelled
				print("Cancelled anchoring " .. prop.Name)
				return false
			end
			wait(0.1)
		end
	end
	
	if (Character.HumanoidRootPart.Position - positionPreviewCFrame.Position).magnitude <= 8 then
		
		for i, v in pairs(prop:GetChildren()) do
			if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
				v.Anchored = false
				v.CanCollide = true
				v.Transparency = 0
			end
		end
		
		wait() -- Props stuck in other objects will not move or push players on it
		prop.PrimaryPart.CFrame = positionPreviewCFrame
		prop.PrimaryPart.Anchored = anchor
		prop.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
		
		if anchor then
			local sound = AnchorSound:Clone()
			sound.Parent = Character.HumanoidRootPart
			sound:Play()
			sound.Ended:Connect(function() sound:Destroy() end)
		end
		
		return true
	end
	
	print("Can not place, player is too far " .. tostring(Character.HumanoidRootPart.Position))
	return false
end

ClientPickUpItem.OnServerInvoke = function(player, item)
	if not player.Backpack then
		return false
	end

	local magnitude = (player.Character.HumanoidRootPart.Position - item.Handle.Position).magnitude
	local itemCount = 0
	for i, v in pairs(player.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			itemCount = itemCount + 1
		end
	end
	
	if magnitude < 8 and itemCount < 32 then
		if item:FindFirstChild("Count") then
			item.PickUpMethod.Value = "Stack"
			for i, v in pairs(item:GetChildren()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
		item.Parent = player.Backpack
		return true
	end
	
	return false
end