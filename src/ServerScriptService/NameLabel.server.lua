local BillboardGui = game:GetService("ServerStorage"):WaitForChild("BillboardGui")

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		local clonegui = BillboardGui:Clone()
		clonegui.TextLabel.Text = player.Name
		clonegui.Parent = character.Head
		if player.Name == "InspectorSchmidt" or player.Name == "InspectorSchultz" then
			clonegui.TextLabel.TextColor3 = Color3.fromRGB(250, 195, 35)
		end
	end)
end)