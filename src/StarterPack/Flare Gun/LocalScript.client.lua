local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientLookingAt = ReplicatedStorage:WaitForChild("ClientLookingAt")

local Tool = script.Parent

Tool.Activated:Connect(function()
	ClientLookingAt:FireServer(workspace.CurrentCamera.CFrame)
end)