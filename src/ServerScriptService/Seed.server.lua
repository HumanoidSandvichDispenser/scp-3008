wait(2)

local Hash = require(game:GetService("ServerScriptService").Hash)

local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage") 
local Players = game:GetService("Players")
local ClientGenerateChunk = ReplicatedStorage:WaitForChild("ClientGenerateChunk")
local FurnitureArea = ServerStorage:WaitForChild("FurnitureArea")
local PalletArea = ServerStorage:WaitForChild("PalletArea")
local LivingRoomArea = ServerStorage:WaitForChild("LivingRoomArea")
local KitchenArea = ServerStorage:WaitForChild("KitchenArea")

local Seed = Hash.sha1(tick() .. "cool")

local Chunks = { Chunk_0_0 = "" }
local ChunksExplored = { Chunk_0_0 = "Explored" }

local HighestPlayerHeight = 0

function GenerateSeed(x, z)
	local seed = table.create(64, 0)
	local random = Random.new(tick())
	for i = 1, 64 do
		seed[i] = random:NextInteger(1, 64)
	end
	return seed
end

Chunks["Chunk_0_0"] = GenerateSeed(0, 0)

function GenerateArea(x, z)
	local seed = Chunks["Chunk_" .. x .. "_" .. z]
	local point = (x - 1) * 8 + z
	return string.sub(Seed .. Seed, point, point)
end

function GenerateProp(newChunk, area, cframeValue)
	if cframeValue:IsA("CFrameValue") and ServerStorage:FindFirstChild(cframeValue.Name) then
		local prop = ServerStorage[cframeValue.Name]:Clone()
		prop.PrimaryPart.Anchored = false
		prop.PrimaryPart.CFrame = cframeValue.Value + area.CFrame.Position
		prop.PrimaryPart.Anchored = true
		prop.Parent = newChunk
	elseif cframeValue:IsA("Part") then
		--cframeValue.Anchored = true
	end
end

function GenerateChunk(x, z)
	local newChunk = game:GetService("Workspace").Infinite["Chunk_0_0"]:Clone()
	local newColumn = game:GetService("Workspace").Infinite["Column_0_0"]:Clone()
	
	newChunk.CFrame = CFrame.new(x * 512, -10, z * 512)
	newChunk.Name = "Chunk_" .. x .. "_" .. z
	newChunk.Parent = game:GetService("Workspace").Infinite
		
	newColumn.CFrame = CFrame.new(x * 512, (HighestPlayerHeight + 300) / 2, z * 512) -- 29
	newColumn.Name = "Column_" .. x .. "_" .. z
	newColumn.Parent = game:GetService("Workspace").Infinite
	newColumn.Front.ColumnLabel.Text = x .. ", " .. z

	if not Chunks[newChunk.Name] then
		Chunks[newChunk.Name] = GenerateSeed()
	end
	ChunksExplored[newChunk.Name] = "Generated"
	
	if x == 0 and z == 0 then
		return
	end
	
	for areaX = 1, 8 do
		for areaZ = 1, 8 do
			local newCFrame = CFrame.new(x * 512 - 256 - 32 + 64 * areaX, .125,
				z * 512 - 256 - 32 + 64 * areaZ)
			local newArea = Chunks[newChunk.Name][(areaX - 1) * 8 + areaZ]
			
			if newArea <= 3 then
				--print("Generating pallet area...")
				local palletArea = PalletArea:Clone()
				
				palletArea.CFrame = newCFrame
				palletArea.Parent = newChunk
				palletArea.Anchored = true
				palletArea.Name = "PalletArea_" .. x .. "_" .. z .. "_" .. areaX .. "_" .. areaZ
				
				for i, v in pairs(PalletArea:GetChildren()) do
					GenerateProp(newChunk, palletArea, v)
				end
				
			elseif newArea <= 5 then	
				local livingRoomArea = LivingRoomArea:Clone()
				
				livingRoomArea.CFrame = newCFrame
				livingRoomArea.Parent = newChunk
				livingRoomArea.Anchored = true
				livingRoomArea.Name = "LivingRoomArea_" .. x .. "_" .. z .. "_" .. areaX .. "_" .. areaZ
				
				for i, v in pairs(LivingRoomArea:GetChildren()) do
					GenerateProp(newChunk, livingRoomArea, v)
				end
			elseif newArea <= 6 then	
				local kitchenArea = KitchenArea:Clone()
				
				kitchenArea.CFrame = newCFrame
				kitchenArea.Parent = newChunk
				kitchenArea.Anchored = true
				kitchenArea.Name = "KitchenArea_" .. x .. "_" .. z .. "_" .. areaX .. "_" .. areaZ
				
				for i, v in pairs(KitchenArea:GetChildren()) do
					GenerateProp(newChunk, kitchenArea, v)
				end
			else
				--print("Generating furniture area...")
				local furnitureArea = FurnitureArea:Clone()
				furnitureArea.CFrame = newCFrame
				furnitureArea.Parent = newChunk
				furnitureArea.Anchored = true
				furnitureArea.Name = "FurnitureArea_" .. x .. "_" .. z .. "_" .. areaX .. "_" .. areaZ
			end
		end
		game:GetService("RunService").Stepped:Wait() -- Reduce server load by delaying before generating more parts of a chunk
	end
	
	delay(5, function()
		if ChunksExplored[newChunk.Name] ~= "Explored" then
			local destroyChunk
			while wait(10) do
				if ChunksExplored[newChunk.Name] == "Explored" then
					break -- Skip entire process and stop repeatedly checking after it has been explored
				end
				
				destroyChunk = true
				for i, v in pairs(Players:GetPlayers()) do
					if v.Character then
						local playerPos = v.Character.HumanoidRootPart.Position
						local chunkPos = Vector3.new(math.floor((playerPos.X + 256)/512),
							0, math.floor((playerPos.Z + 256)/512))
							
						if math.abs(chunkPos.X - x) <= 1 and math.abs(chunkPos.Z - z) <= 1 then
							destroyChunk = false -- Do not destroy chunk if player is near chunk
						end
					end
				end
				
				if destroyChunk then
					print("Ungenerated " .. newChunk.Name)
					newChunk:Destroy()
					ChunksExplored[newChunk.Name] = nil
				end
			end
		end
	end)
	--print("Generated chunk at " .. tostring(newChunk.Position) .. " or chunkposition " .. x .. ", " .. z)
end

ClientGenerateChunk.OnServerEvent:Connect(function(player)
	--print(player.Name .. " requested chunk generation")
	if not player.Character then
		return
	end
	
	local playerPos = player.Character.HumanoidRootPart.Position
	local chunkPos = Vector3.new(math.floor((playerPos.X + 256)/512),
		0, math.floor((playerPos.Z + 256)/512))
	
	-- 
	if HighestPlayerHeight < playerPos.Y then
		HighestPlayerHeight = playerPos.Y
		for i, v in pairs(game:GetService("Workspace").Infinite:GetChildren()) do
			if v.Name:sub(1, 6) == "Column" then
				v.Size = Vector3.new(40, HighestPlayerHeight + 512, 40)
				v.CFrame = CFrame.new(v.Position.X,
					(HighestPlayerHeight + 512) / 2,
					v.Position.Z)
			end
		end
	end
	
	print("Explored " .. "Chunk_" .. (chunkPos.X) .. "_" .. (chunkPos.Z))
	
	for x = -1, 1 do
		for z = -1, 1 do
			local chunkStatus = ChunksExplored["Chunk_" .. (chunkPos.X + x) .. "_" .. (chunkPos.Z + z)]
			if not chunkStatus then
				GenerateChunk(chunkPos.X + x, chunkPos.Z + z)
			end
		end
	end
	
	-- Parent all props in theto "Props" folder to be fully interacted with
	for i, v in pairs(workspace.Infinite["Chunk_" .. (chunkPos.X) .. "_" .. (chunkPos.Z)]:GetChildren()) do
		if v:IsA("Model") then
			v.Parent = workspace.Props
		end
	end
	
	ChunksExplored["Chunk_" .. (chunkPos.X) .. "_" .. (chunkPos.Z)] = "Explored"
end)

--[[
print(Seed)
print(Hash.sha1(Seed))
print(GenerateSeed(1, 0))
print(GenerateSeed(1, 1))
print(GenerateSeed(25, 40))
--[[
	GenerateSeed(x, y)
	@param x - x of chunk
	@param y - y of chunk
	@return hashed seed
]]
