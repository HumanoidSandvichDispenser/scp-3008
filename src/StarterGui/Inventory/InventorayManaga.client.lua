game:GetService('StarterGui'):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientStackItem = ReplicatedStorage:WaitForChild("ClientStackItem")
local ClientDropItem = ReplicatedStorage:WaitForChild("ClientDropItem")

local Player = game:GetService("Players").LocalPlayer
while not Player.Character do end
local Character = Player.Character
local Backpack = Player.Backpack
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()

local Hotbar = script.Parent.HotbarFrame
local Inventory = script.Parent.Backpack.InventoryFrame
local SlotTemplate = script.Parent.Templates.SlotTemplate

local UnequippedTransparency = 0.7
local EquippedTransparency = 0.2
local EquippedBackgroundTransparency = 0.5

local InventorySlots = table.create(32, false) --{ false, false, false, false, false, false, false, false }

local LastEquippedItem = nil
local MouseDown = false
local Mouse2Down = false
local SelectedItem = nil
local SelectedItemImage = nil
local HoveredItem = nil

local LookVector = Vector3.new(0, 0, 0)

local InputKeys = {
    ["One"] = 1,
    ["Two"] = 2,
    ["Three"] = 3,
    ["Four"] = 4,
    ["Five"] = 5,
    ["Six"] = 6,
    ["Seven"] = 7,
    ["Eight"] = 8,
}

function SearchEmptySpots(array)
	for i, v in pairs(array) do
		if not v then
			return i
		end
	end
	return nil
end

function PlaceToolInEmptySpot(tool)
	local emptySpot = SearchEmptySpots(InventorySlots)
	if emptySpot then
		InventorySlots[emptySpot] = tool
		print(tool.Name .. " added to slot index " .. emptySpot)
	end
end

function SetIcons(i, v)
	if InventorySlots[i] then
		if InventorySlots[i]:IsA("Tool") and InventorySlots[i].TextureId ~= "" then
			v.Image = InventorySlots[i].TextureId
			v.SlotLabel.Text = ""
		elseif InventorySlots[i]:FindFirstChild("Icon") then
			v.Image = InventorySlots[i].Icon.Texture
			v.SlotLabel.Text = ""
		else
			v.Image = ""
			v.SlotLabel.Text = InventorySlots[i].Name
		end
		
		if InventorySlots[i]:FindFirstChild("Count") then
			v.SlotCount.Text = "x" .. InventorySlots[i].Count.Value
		elseif InventorySlots[i]:FindFirstChild("Ammo") then
			v.SlotCount.Text = InventorySlots[i].Ammo.Value
		else
			v.SlotCount.Text = ""
		end
	else
		v.Image = ""
		v.SlotLabel.Text = ""
		v.SlotCount.Text = ""
	end
end

function Update()
	for i, v in pairs(Hotbar:GetChildren()) do
		SetIcons(i, v)
	end
	
	for i, v in pairs(Inventory:GetChildren()) do
		SetIcons(i + 8, v)
	end
end

function Equip(index)
	if not index then return end
	
	local tool = InventorySlots[index]
	if tool then
		if tool.Parent == Character then
			Humanoid:UnequipTools()
			for i, v in pairs(Hotbar:GetChildren()) do
				v.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			end
			
		else
			Humanoid:EquipTool(tool)
			LastEquippedItem = tool
			for i, v in pairs(Hotbar:GetChildren()) do
				if i == index then
					v.BackgroundColor3 = Color3.fromRGB(24, 151, 255)
				else
					v.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				end
			end
		end
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	local keyName = input.KeyCode.Name
	
	if not gameProcessed then
		if InputKeys[keyName] and not script.Parent.Backpack.Visible then
		
			Equip(InputKeys[keyName])
			
		elseif keyName == "G" then
			
			local item = Character:FindFirstChildWhichIsA("Tool")
			
			if item then
				if ClientDropItem:InvokeServer(item, 1) then
					LastEquippedItem = nil
					Humanoid:UnequipTools()
					for i, v in pairs(Hotbar:GetChildren()) do
						v.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					end
				end
			end
			
		elseif input.KeyCode == Enum.KeyCode.Tab then
			
			script.Parent.Backpack.Visible = not script.Parent.Backpack.Visible
			script.Parent.Backpack.LocalScript.Disabled = not script.Parent.Backpack.Visible
			--script.Parent.ImageButton.Visible = script.Parent.Backpack.Visible
			if script.Parent.Backpack.Visible then
				LookVector = workspace.CurrentCamera.CFrame.LookVector
				workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
			else
				workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
			end
			
			if script.Parent.Backpack.Visible then
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			else
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
			end
		
		elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
			--MouseButton3Down()
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if input.UserInputType == Enum.UserInputType.MouseButton3 then
			--MouseButton3Up()
		end
	end
end)

Backpack.ChildAdded:Connect(function(child)
	print(child.Name .. " has been added to backpack")

	if child ~= LastEquippedItem and child:IsA("Tool") then
		if child:FindFirstChild("Count") and child.PickUpMethod.Value == "Stack" then
			if child.PickUpMethod.Value == "Stack" then
				local foundDuplicate = false
				
				-- Add its value to duplicate items then destroy itself
				for i, v in pairs(Backpack:GetChildren()) do
					if v.Name == child.Name and v ~= child then
						local duplicateIndex = table.find(InventorySlots, v)
						foundDuplicate = ClientStackItem:InvokeServer(child, v)
						if foundDuplicate then
							InventorySlots[duplicateIndex] = child -- Replace original object's slot with the new object with new value
							break
						end
					end
				end
				
				if not foundDuplicate then
					PlaceToolInEmptySpot(child)
				end
			elseif child.PickUpMethod.Value == "Default" then
				PlaceToolInEmptySpot(child)
			end
			--child.PickUpMethod.Value = "Default"
		elseif not child:FindFirstChild("Count") then
			PlaceToolInEmptySpot(child)
		end
	end
	Update()
end)

function BackpackChildRemoved(child)
	print(child.Name .. " has been removed from the backpack")
	
	if child and child.Parent ~= Character and child.Parent ~= Backpack then
		for i, v in pairs(InventorySlots) do
			if v == child then
				InventorySlots[i] = false
			end
		end
		Update()
	end
end

Backpack.ChildRemoved:Connect(BackpackChildRemoved)
Character.ChildRemoved:Connect(BackpackChildRemoved)

Mouse.Button1Down:Connect(function()
	if not Mouse2Down then
		MouseDown = true
	end
end)

Mouse.Button1Up:Connect(function()
	if SelectedItem and MouseDown then
		local selectedItemIndex = table.find(InventorySlots, SelectedItem)
		
		if HoveredItem and HoveredItem:IsA("ImageLabel") then
			local hoveredItemIndex = tonumber(string.sub(HoveredItem.Name, 6))
			print("Swapping items at " .. selectedItemIndex .. " and " .. hoveredItemIndex)
			if InventorySlots[hoveredItemIndex] and InventorySlots[selectedItemIndex] and 
				InventorySlots[hoveredItemIndex].Name == InventorySlots[selectedItemIndex].Name and
				InventorySlots[hoveredItemIndex] ~= InventorySlots[selectedItemIndex] then
				ClientStackItem:InvokeServer(InventorySlots[hoveredItemIndex], InventorySlots[selectedItemIndex])
			else
				local temp = InventorySlots[hoveredItemIndex]
				InventorySlots[hoveredItemIndex] = InventorySlots[selectedItemIndex]
				InventorySlots[selectedItemIndex] = temp
			end
		else
			local item = InventorySlots[selectedItemIndex]
			if item then
				ClientDropItem:InvokeServer(item)
			end
		end
		
		SelectedItem = nil
		SelectedItemImage:Destroy()
		SelectedItemImage = nil
		Update()
	end
	MouseDown = false
end)

Mouse.Button2Down:Connect(function()
	if not MouseDown then
		Mouse2Down = true
	end
end)

Mouse.Button2Up:Connect(function()
	if SelectedItem and Mouse2Down then
		local selectedItemIndex = table.find(InventorySlots, SelectedItem)
		
		if HoveredItem and HoveredItem:IsA("ImageLabel") then
			local hoveredItemIndex = tonumber(string.sub(HoveredItem.Name, 6))
			if not InventorySlots[hoveredItemIndex] and InventorySlots[selectedItemIndex]:FindFirstChild("Count") then
				local splitItem = ClientStackItem:InvokeServer(InventorySlots[selectedItemIndex], nil, true)
				if splitItem then 
					local oldIndex = table.find(InventorySlots, splitItem)
					if oldIndex then
						InventorySlots[oldIndex] = false
					end
					InventorySlots[hoveredItemIndex] = splitItem
				end
			end			
		else
			local item = InventorySlots[selectedItemIndex]
			if item then
				local splitItem = ClientStackItem:InvokeServer(InventorySlots[selectedItemIndex], nil, true)
				if splitItem then ClientDropItem:InvokeServer(splitItem) end
			end
		end
		
		SelectedItem = nil
		SelectedItemImage:Destroy()
		SelectedItemImage = nil
		Update()
	end
	Mouse2Down = false
end)

RunService.RenderStepped:Connect(function()
	if SelectedItemImage then
		SelectedItemImage.Position = UDim2.new(0, Mouse.X - 37, 0, Mouse.Y - 37)
	end
	
	if workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable and Player.Character then
		local position = Player.Character.Head.CFrame.Position-- + Vector3.new(0, 1.5, 0)
		workspace.CurrentCamera.CFrame = CFrame.new(position, position + LookVector)
	end
end)

for y = 1, 4 do
	for x = 1, 8 do
		local i = (((y - 1) * 8) + x)
		
		local newSlot = SlotTemplate:Clone()
		newSlot.Name = "Slot_" .. i
		newSlot.Visible = true
		
		if y == 1 then
			newSlot.Position = UDim2.new(0, (x - 1) * 80, 0, 0)
			newSlot.Parent = Hotbar
		else
			newSlot.Position = UDim2.new(0, (x - 1) * 80, 0, (y - 2) * 80)
			newSlot.Parent = script.Parent.Backpack.InventoryFrame
		end
		
		newSlot.MouseEnter:Connect(function()
			HoveredItem = newSlot
		end)
			
		newSlot.MouseLeave:Connect(function()
			if HoveredItem == newSlot then 
				HoveredItem = nil
			end
				
			if (MouseDown or Mouse2Down) and InventorySlots[i] and not SelectedItem then
				SelectedItem = InventorySlots[i]
				SelectedItemImage = newSlot:Clone()
				SelectedItemImage.SlotCount.Visible = false
				SelectedItemImage.ImageTransparency = 0.5
				SelectedItemImage.BackgroundTransparency = 1
				SelectedItemImage.Parent = script.Parent
			end
		end)
	end
end

local backpack = Player:WaitForChild("Backpack")
for i, v in pairs(backpack:GetChildren()) do
	if v and v:IsA("Tool") then
		PlaceToolInEmptySpot(v)
	end
end

while wait() do
	Update()
end
--game.ReplicatedStorage.ClientDropItem:InvokeServer(game.Players.LocalPlayer.Backpack["Flare Gun"])