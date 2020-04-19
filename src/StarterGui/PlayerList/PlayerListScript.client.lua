local Players = game:GetService("Players")
local Frame = script.parent.Frame
local Slots = Frame.Slots
local Template = Frame.Template

local playerTable = {}

local function cleanup(slot)
	repeat
		wait()
	until slot.Position.X.Offset == 400
	slot:Destroy()
end


local function AddPlayer()
	local chil = Players:GetChildren()
	for c = 1, #chil do
		if not playerTable[chil[c].Name] then
			playerTable[chil[c].Name] = 1
			local slot = Template:clone()
			slot.Name = chil[c].Name
			slot.Text = slot.Name
			slot.Parent = Slots
		end
	end
end

local function RemovePlayer(playerName)
	if playerName then
		local slot = Slots:FindFirstChild(playerName)
		slot:TweenPosition(UDim2.new(0, 400, 0, slot.Position.Y.Offset), "Out", "Quad", 0.5, true)
		local cor = coroutine.wrap(cleanup)
		cor(slot)
	end
end

local function Update(playerName)
	AddPlayer()
	RemovePlayer(playerName)
	
	local count = 0
	for key, value in pairs(playerTable) do
		count = count + 1
		local slot = Slots:FindFirstChild(key)
		local y = 30 + (count - 1) * 27
		slot:TweenPosition(UDim2.new(0, 0, 0, y), "Out", "Quad", 0.5, true)
	end
end

Players.PlayerAdded:connect(function(player)
	Update()
end)

Players.PlayerRemoving:connect(function(player)
	Update(player.Name)
end)

wait()
Update()
