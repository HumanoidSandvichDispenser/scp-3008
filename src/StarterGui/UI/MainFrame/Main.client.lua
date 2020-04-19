local playButton = script.Parent.ButtonFrame.PlayButton
local updateLogButton = script.Parent.ButtonFrame.UpdateLogButton
local quitGameButton = script.Parent.ButtonFrame.QuitGameButton
local mainFrame = script.Parent
local updateLogFrame = script.Parent.UpdateLog
local soundEffect = script.Parent.SoundEffects
local player = game.Players.LocalPlayer
local RemoteEvent = game.ReplicatedStorage.ChangeTeam
local HealthGui = script.Parent.Parent.Parent.Health

print("UI Loaded")

playButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	soundEffect.MainMenuSong:Stop()
	RemoteEvent:FireServer(BrickColor.new("Really red"))
	
	HealthGui.Enabled = true
	print("HealthGui enabled")
end)

quitGameButton.MouseButton1Click:Connect(function()
	game.Players.LocalPlayer:Kick("Why do you even need a reason")
end)

updateLogButton.MouseButton1Click:Connect(function()
	updateLogFrame.Visible = true
end)

for i,v in pairs(script.Parent.ButtonFrame:GetChildren()) do
	if v.ClassName == "TextButton" then
		v.MouseButton1Click:Connect(function()
			soundEffect.Click:Play()
		end)
	end
end

if mainFrame.Visible then
soundEffect.MainMenuSong:Play()

	
end
