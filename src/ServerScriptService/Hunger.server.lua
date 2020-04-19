game.Players.PlayerAdded:Connect(function(player)
	local Info = Instance.new('Folder', player)
	local Hunger = Instance.new('IntValue', Info)
	Info.Name = 'Info'
	Hunger.Name = 'Hunger'
	Hunger.Value = 100
end)