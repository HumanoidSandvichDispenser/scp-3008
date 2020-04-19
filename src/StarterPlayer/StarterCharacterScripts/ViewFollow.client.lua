local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientLookingAt = ReplicatedStorage:WaitForChild("ClientLookingAt")

local CFNew, CFAng = CFrame.new, CFrame.Angles
local asin = math.asin

local Camera = workspace.CurrentCamera
local Player = game:GetService("Players").LocalPlayer
repeat wait() until Player.Character
local Character = Player.Character
local Root = Character:WaitForChild("HumanoidRootPart")
local Neck = Character:FindFirstChild("Neck", true)
local YOffset = Neck.C0.Y
local Mouse = Player:GetMouse()

game:GetService("RunService"):BindToRenderStep("ViewFollow", Enum.RenderPriority.First.Value, function()
--game:GetService("RunService").RenderStepped:Connect(function()
	local CameraDirection = Root.CFrame:ToObjectSpace(Camera.CFrame).lookVector.unit
	if Neck then
		Neck.C0 = CFNew(0,YOffset,0)*CFAng(0,-asin(CameraDirection.x),0)*CFAng(asin(CameraDirection.y),0,0)
	end
	
	if Character.RightUpperArm:FindFirstChild("RightShoulder") then
	Character.RightUpperArm.RightShoulder.C0 = CFrame.Angles(-math.asin((Mouse.Origin.p - Mouse.Hit.p).unit.y), 0, 0) * CFrame.new(1, 0.5, 0)
	Character.LeftUpperArm.LeftShoulder.C0 = CFrame.Angles(-math.asin((Mouse.Origin.p - Mouse.Hit.p).unit.y), 0, 0) * CFrame.new(-1, 0.5, 0)
	end
	
	if Character:FindFirstChildWhichIsA("Tool") then
		for i, v in pairs(Character:GetChildren()) do
			if string.find(v.Name, "Hand") or string.find(v.Name, "Arm") then
				v.LocalTransparencyModifier = 0
			end
		end
	else
		for i, v in pairs(Character:GetChildren()) do
			if string.find(v.Name, "Hand") or string.find(v.Name, "Arm") then
				v.LocalTransparencyModifier = 1
			end
		end
	end
end)