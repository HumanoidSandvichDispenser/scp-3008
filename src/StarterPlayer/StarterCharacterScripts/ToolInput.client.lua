local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientLookingAt = ReplicatedStorage:WaitForChild("ClientLookingAt")
local ClientToolInput = ReplicatedStorage:WaitForChild("ClientToolInput")

function GetTool()
	return Player.Character:FindFirstChildWhichIsA("Tool")
end

Mouse.Button1Down:Connect(function()
	local tool = GetTool()
	if tool then
		ClientToolInput:FireServer("MouseButton1Down", tool, Player.Character.HumanoidRootPart.CFrame, workspace.Camera.CFrame.LookVector)
		ClientLookingAt:FireServer(workspace.Camera.CFrame, false)
	end
end)

Mouse.Button1Up:Connect(function()
	local tool = GetTool()
	if tool then
		ClientToolInput:FireServer("MouseButton1Up", tool)
	end
end)

Mouse.Button2Down:Connect(function()
	local tool = GetTool()
	if tool then
		print("MouseButton2Down")
		ClientToolInput:FireServer("MouseButton2Down", tool)
	end
end)

Mouse.Button2Up:Connect(function()
	local tool = GetTool()
	if tool then
		ClientToolInput:FireServer("MouseButton2Up", tool)
	end
end)

while wait(0.25) do
	ClientLookingAt:FireServer(workspace.Camera.CFrame, true)
end