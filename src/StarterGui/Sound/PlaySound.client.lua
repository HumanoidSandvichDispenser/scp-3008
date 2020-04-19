local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerPlaySound = ReplicatedStorage:WaitForChild("ServerPlaySound")
local ServerPlaylistAction = ReplicatedStorage:WaitForChild("ServerPlaylistAction")
local TweenService = game:GetService("TweenService")

function PlayNextSound(playlist, index)
	if playlist then
		local playlistChildren = playlist:GetChildren()
		if index + 1 >= #playlistChildren then
			index = 1
		else
			index = index + 1
		end
		
		for i, v in pairs(playlistChildren) do
			if index + 1 == i and v:IsA("Sound") then
				playlist.CurrentSound.Value = v
				v:Play()
			end	
		end
	end
end

ServerPlaySound.OnClientEvent:Connect(function(soundInstance, loop)
	local newSoundInstance = soundInstance:Clone()
	newSoundInstance.Parent = script.Parent
	newSoundInstance:Play()
	newSoundInstance.Ended:Wait()
	newSoundInstance:Destroy()
end)

ServerPlaylistAction.OnClientEvent:Connect(function(playlistName, playlistAction, soundInstances)
	if playlistAction == "Play" then
		if script:FindFirstChild(playlistName) then
			delay(1, function()
				script[playlistName].CurrentSound.Value:Resume()
				script[playlistName].CurrentSound.Value.Volume = 0
				
				TweenService:Create(script[playlistName].CurrentSound.Value,
					TweenInfo.new(5, Enum.EasingStyle.Circular),
					{
						Volume = 1
					}
				):Play()
			end)
		else
			local playlist = Instance.new("Folder", script)
			local currentSound = Instance.new("ObjectValue", playlist)
			playlist.Name = playlistName
			currentSound.Name = "CurrentSound"
			
			for i, v in pairs(soundInstances) do
				local newSoundInstance = v:Clone()
				newSoundInstance.Parent = playlist
				newSoundInstance.Ended:Connect(function() PlayNextSound(playlist, i) end)
			end
			
			PlayNextSound(playlist, 0)
		end
	elseif playlistAction == "Pause" then
		if script:FindFirstChild(playlistName) then
			script[playlistName].CurrentSound.Value:Pause()
		end
	elseif playlistAction == "Stop" then
		if script:FindFirstChild(playlistName) then
			script[playlistName]:Destroy()
		end
	end
end)