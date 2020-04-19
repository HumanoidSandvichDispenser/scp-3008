local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerPlaySound = ReplicatedStorage:WaitForChild("ServerPlaySound")
local ServerPlaylistAction = ReplicatedStorage:WaitForChild("ServerPlaylistAction")

local Playlist = {
	--[[
	ReplicatedStorage.Monday,
	ReplicatedStorage.Wednesday,
	ReplicatedStorage.Thursday,
	ReplicatedStorage.Friday,
	ReplicatedStorage.Saturday,
	ReplicatedStorage.Sunday,
	]]
	ReplicatedStorage["We're Finally Landing"],
	ReplicatedStorage["Synthwave at Dawn"]
}

local NightPlaylist = {
	ReplicatedStorage["Night"]
}

local TestPlaylist = {
	ReplicatedStorage.Test1,
	ReplicatedStorage.Test2
}

local Days = 0

game:GetService("Players").PlayerAdded:Connect(function(player)
	if math.fmod((Lighting:GetMinutesAfterMidnight() / 720), 2) == 0 then
		ServerPlaylistAction:FireAllClients(player, "Music", "Pause", Playlist)
		ServerPlaylistAction:FireAllClients(player, "Night", "Play", NightPlaylist)
	end
	
	if math.fmod((Lighting:GetMinutesAfterMidnight() / 720), 2) == 1 then
		ServerPlaylistAction:FireAllClients("Music", "Play", Playlist)
		ServerPlaylistAction:FireAllClients("Night", "Pause", NightPlaylist)
	end
end)

while wait(300) do
	Lighting:SetMinutesAfterMidnight(Lighting:GetMinutesAfterMidnight() + 720)
	
	print(math.fmod((Lighting:GetMinutesAfterMidnight() / 720), 2))
	
	if math.fmod((Lighting:GetMinutesAfterMidnight() / 720), 2) == 0 then
		Lighting.FogColor = Color3.fromRGB(0, 0, 0)
		Lighting.Brightness = 0
		ServerPlaySound:FireAllClients(ReplicatedStorage.LightsOff)
		ServerPlaylistAction:FireAllClients("Music", "Pause", Playlist)
		ServerPlaylistAction:FireAllClients("Night", "Play", NightPlaylist)
	end
	
	if math.fmod((Lighting:GetMinutesAfterMidnight() / 720), 2) == 1 then
		Lighting.FogColor = Color3.fromRGB(199, 199, 199)
		Lighting.Brightness = 2
		ServerPlaySound:FireAllClients(ReplicatedStorage.LightsOn)
		ServerPlaylistAction:FireAllClients("Music", "Play", Playlist)
		ServerPlaylistAction:FireAllClients("Night", "Pause", NightPlaylist)
	end
	
end


--[[
while x == 1 do
	ServerPlaySound:FireAllClients(ReplicatedStorage.Monday)
	wait (34)
	ServerPlaySound:FireAllClients(ReplicatedStorage.Saturday)
	wait (189) 
	ServerPlaySound:FireAllClients(ReplicatedStorage.Sunday)
	wait (69)
	ServerPlaySound:FireAllClients(ReplicatedStorage.Thursday)
	wait (27)
	ServerPlaySound:FireAllClients(ReplicatedStorage.Wednesday)
	wait (54)
	ServerPlaySound:FireAllClients(ReplicatedStorage.Friday)
	wait (127)	
end
]]
