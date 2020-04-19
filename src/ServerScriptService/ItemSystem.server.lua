local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientStackItem = ReplicatedStorage:WaitForChild("ClientStackItem")
local ClientDropItem = ReplicatedStorage:WaitForChild("ClientDropItem")

ClientStackItem.OnServerInvoke = function(player, item1, item2, split)
	if split then
		if not item2 then
			local splitValue = math.ceil(item1.Count.Value / 2)
			if splitValue > 0 then
				item2 = item1:Clone()
				item2:WaitForChild("PickUpMethod").Value = "NewPosition"
				item2.Parent = item1.Parent
				item2.Count.Value = splitValue
				item1.Count.Value = item1.Count.Value - splitValue
				return item2
			else
				return nil
			end
		else
			assert("item2 must be nil to split")
		end
	else
		if item1.Name == item2.Name and item1 ~= item2 and item1:FindFirstChild("Count") then
			item1.Count.Value = item1.Count.Value + item2.Count.Value
			item2:Destroy()
			return true
		end
	end
	return false
end

ClientDropItem.OnServerInvoke = function(player, item, count)
	if item:FindFirstChild("Count") then
		if not count or item.Count.Value == count then
			item.PickUpMethod.Value = "Stack"
			item.Parent = workspace.Items
			item.Handle.CFrame = player.Character.Head.CFrame * CFrame.new(0, 0, -3)
			for i, v in pairs(item:GetChildren()) do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
			--item.Velocity = player.Character.Head.CFrame.lookVector * 5
			return true
		elseif item.Count.Value < count then
			local newItem = item:Clone()
			newItem.Count.Value = count
			newItem.Parent = workspace.Items
			newItem.Handle.CFrame = player.Head.Character.Head.CFrame * CFrame.new(0, 0, -3)
			for i, v in pairs(newItem:GetChildren()) do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
			--newItem.Handle.Velocity = player.Head.Character.Head.CFrame.lookVector * 5
			return true
		end
	else
		item.Parent = workspace.Items
		item.Handle.CFrame = player.Character.Head.CFrame * CFrame.new(0, 0, -3)
		for i, v in pairs(item:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
		return true
		--item.Handle.Velocity = player.Character.Head.CFrame.lookVector * 5
	end
	return false
end
-- game.ReplicatedStorage.ClientDropItem:InvokeServer(game.Players.LocalPlayer.Backpack["Flare Gun"])

script.ServerDropItem.Event:Connect(function(player, item)
	local random = Random.new()
	item.Parent = workspace.Items
	item.Handle.CFrame = player.Character.Head.CFrame * CFrame.new(random:NextInteger(-1, 1), 1, random:NextNumber(-1, 1))
	for i, v in pairs(item:GetChildren()) do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end
end)