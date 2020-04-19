local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientLookingAt = ReplicatedStorage:WaitForChild("ClientLookingAt")

ClientLookingAt.OnServerEvent:Connect(function(player, cframe, lerp)
	local character = player.Character
	local neck = character:FindFirstChild("Neck")
	local rootCFrame = character.HumanoidRootPart.CFrame
	local rotationOffset = (rootCFrame - rootCFrame.p):inverse()
	local angles = cframe - cframe.p
	--local angles = CFrame.Angles(x, y, 0) --  * ((y > 90 or y < -90) and 1 or -1)
	--print(math.deg(x) .. " y: " .. math.deg(y))
	--local playerAngles = CFrame

	local tool = player.Character:FindFirstChildWhichIsA("Tool")
	
	if lerp then
		if neck then
			TweenService:Create(neck, TweenInfo.new(0.25), { C0 = angles }):Play()
		end
		
		
		if tool then -- * angles * CFrame.new(1, 0.5, 0)
			TweenService:Create(character.RightUpperArm.RightShoulder, TweenInfo.new(0.25), { C0 = rotationOffset * angles *  CFrame.new(1, 0.5, 0) }):Play()
			TweenService:Create(character.LeftUpperArm.LeftShoulder, TweenInfo.new(0.25), { C0 = rotationOffset * angles *  CFrame.new(-1, 0.5, 0) }):Play()
		else
			TweenService:Create(character.RightUpperArm.RightShoulder, TweenInfo.new(0.25), { C0 = CFrame.new(1, 0.5, 0) }):Play()
			TweenService:Create(character.LeftUpperArm.LeftShoulder, TweenInfo.new(0.25), { C0 = CFrame.new(-1, 0.5, 0) }):Play()
		end
	else
		if neck then
			neck.C0 = angles
		end
		
		if tool then
			character.RightUpperArm.RightShoulder.C0 = rotationOffset * angles * CFrame.new(1, 0.5, 0)
			character.LeftUpperArm.LeftShoulder.C0 = rotationOffset * angles * CFrame.new(-1, 0.5, 0)
		end
	end
	
	
end)