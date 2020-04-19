repeat wait() until script.Parent:IsA("Model")
local Character = script.Parent
local Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
local id = "rbxassetid://717720348"

local Humanoid = Character.Humanoid

Humanoid.Died:Connect(function()
	local random = Random.new(tick())
	local equippedTool = Character:FindFirstChildWhichIsA("Tool")
	
	local sound = Instance.new("Sound")
	sound.Parent = Character.Head
	sound.SoundId = id
	sound.Volume = 0.5
	sound:Play()
	
	if equippedTool then
		game:GetService("ServerScriptService").ItemSystem.ServerDropItem:Fire(Player, equippedTool)
	end
	
	for i, v in pairs(Player.Backpack:GetChildren()) do
		game:GetService("ServerScriptService").ItemSystem.ServerDropItem:Fire(Player, v)
	end
end)