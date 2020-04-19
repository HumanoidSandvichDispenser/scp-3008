local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientRequestBlueprints = ReplicatedStorage:WaitForChild("ClientRequestBlueprints")
local ClientCraftItem = ReplicatedStorage:WaitForChild("ClientCraftItem")

local PlayersCrafting = { }

local Blueprints = {
	["2x4"] = {
		Time = 0.5,
		Ingredients = {
			["Wood"] = 1
		}
	},
	
	["Scrap Metal"] = {
		Time = 2,
		Count = 50,
		Ingredients = {
			["Wood"] = 1
		}
	},
	
	["Clothes Hanger"] = {
		Time = 8,
		Count = 1,
		Ingredients = {
			["Wood"] = 3,
			["Scrap Metal"] = 1
		}
	}
}

ClientRequestBlueprints.OnServerInvoke = function()
	return Blueprints
end

ClientCraftItem.OnServerInvoke = function(player, item)
	if Blueprints[item] and not PlayersCrafting[player] then
		PlayersCrafting[player] = true
		local ingredientsFound = { }
		
		for i, v in pairs(Blueprints[item].Ingredients) do -- i = ingredient name, v = ingredient count
			ingredientsFound[i] = false -- nil elements will not be iterated, so use false instead of nil
			
			for j, w in pairs(player.Backpack:GetChildren()) do -- w = current item/tool being iterated
				if w.Name == i and w:FindFirstChild("Count") and w.Count.Value >= v then
					ingredientsFound[i] = w -- set it to the tool so it can be referred to later on
				end
			end
		end
		
		if table.find(ingredientsFound, false) then
			return false -- one ingredient was not matched; do not craft
		end
		
		for i, v in pairs(ingredientsFound) do
			if ingredientsFound then
				v.Count.Value = v.Count.Value - Blueprints[item].Ingredients[i]
				if v.Count.Value == 0 then
					v:Destroy()
				end
			end
		end
		
		wait(Blueprints[item].Time)
		
		local newItem = ServerStorage.Items[item]:Clone()
		if Blueprints[item].Count then
			newItem.PickUpMethod.Value = "Stack"
			newItem.Count.Value = Blueprints[item].Count
		end
		newItem.Parent = player.Backpack
		
		PlayersCrafting[player] = nil
		return true
	end
	
	return false
end

local IconFolder = Instance.new("Folder", ReplicatedStorage)
IconFolder.Name = "Icons"

for i, v in pairs(Blueprints) do
	if ServerStorage.Items:FindFirstChild(i) and ServerStorage.Items[i].TextureId ~= "" then
		print("Icon found")
		local icon = Instance.new("Decal")
		icon.Texture = ServerStorage.Items[i].TextureId
		icon.Name = i
		icon.Parent = IconFolder
	end
end