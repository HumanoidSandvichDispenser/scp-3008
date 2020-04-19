local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientGenerateChunk = ReplicatedStorage:WaitForChild("ClientGenerateChunk")

ClientGenerateChunk:FireServer(game:GetService("Players").LocalPlayer)
while wait(4) do
	ClientGenerateChunk:FireServer(game:GetService("Players").LocalPlayer)
end