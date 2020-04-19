local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientRequestBlueprints = ReplicatedStorage:WaitForChild("ClientRequestBlueprints")
local ClientCraftItem = ReplicatedStorage:WaitForChild("ClientCraftItem")

local Blueprints = ClientRequestBlueprints:InvokeServer()
local CraftingQueue = { }
local CurrentlyCrafting = nil

function Update()
	for i, v in pairs(script.Parent.Backpack.CraftingQueue:GetChildren()) do
		v:Destroy()
	end
	
	print("- Queue -")
	
	if CurrentlyCrafting then
		print(CurrentlyCrafting)
		local currentlyCraftingSlot = script.Parent.Templates.QueueSlotTemplate:Clone()
		currentlyCraftingSlot.Visible = true
		
		if ReplicatedStorage.Icons:FindFirstChild(CurrentlyCrafting) then
			currentlyCraftingSlot.Image = ReplicatedStorage.Icons[CurrentlyCrafting].Texture
		else
			currentlyCraftingSlot.SlotLabel.Text = CurrentlyCrafting
		end
		
		currentlyCraftingSlot.BackgroundColor3 = Color3.fromRGB(184, 204, 38)
		currentlyCraftingSlot.Position = UDim2.new(0, 0, 0, 0)
		currentlyCraftingSlot.Parent = script.Parent.Backpack.CraftingQueue
	end
	
	for i, v in pairs(CraftingQueue) do
		local queueSlot = script.Parent.Templates.QueueSlotTemplate:Clone()
		queueSlot.Visible = true
		
		if ReplicatedStorage.Icons:FindFirstChild(v) then
			queueSlot.Image = ReplicatedStorage.Icons[v].Texture
		else
			queueSlot.SlotLabel.Text = v
		end
		
		queueSlot.Position = UDim2.new(0, (55 * i), 0, 0)
		queueSlot.Parent = script.Parent.Backpack.CraftingQueue
		
		queueSlot.MouseButton1Click:Connect(function()
			table.remove(CraftingQueue, i)
			Update()
		end)
	end
end

function CraftItem(item)
	if CurrentlyCrafting then
		table.insert(CraftingQueue, #CraftingQueue + 1, item)
		Update()
	else
		CurrentlyCrafting = item
		Update()
		
		if ClientCraftItem:InvokeServer(item) then
			script.Craft:Play()	
		end

		CurrentlyCrafting = nil
		Update()
		
		if CraftingQueue[1] then
			CraftItem(table.remove(CraftingQueue, 1))
		end
	end
end

local index = 0
for i, v in pairs(Blueprints) do -- i = item name, v = item info
	index = index + 1
	
	local craftingItem = script.Parent.Templates.CraftingTemplate:Clone()
	local recipe = ""
	
	local ingredientIndex = 1
	for j, w in pairs(v.Ingredients) do -- j = ingredient name, w = ingredient count
		recipe = recipe .. (ingredientIndex == 1 and "" or ", ") .. w .. " " .. j
		ingredientIndex = ingredientIndex + 1
	end
	
	if ReplicatedStorage.Icons:FindFirstChild(i) then
		craftingItem.Icon.Image = ReplicatedStorage.Icons[i].Texture
	else
		craftingItem.ItemName.Text = i
	end
	
	craftingItem.ItemName.Text = i
	craftingItem.ItemRecipe.Text = recipe
	craftingItem.Visible = true
	craftingItem.Parent = script.Parent.Backpack.CraftingFrame
	
	craftingItem.Position = UDim2.new(0, 0, 0, index * 80)
	craftingItem.MouseButton1Click:Connect(function()
		CraftItem(i)
	end)
end