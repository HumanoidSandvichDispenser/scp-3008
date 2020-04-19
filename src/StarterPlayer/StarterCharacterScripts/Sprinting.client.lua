local Chat = game:GetService("Chat")
local UIS = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Character = Player.Character

local WalkingForward = false
local HoldingShift = false
local Anim2 = Instance.new("Animation")
Anim2.AnimationId = "rbxassetid://4871312239"
local Anim = Instance.new("Animation")
Anim.AnimationId = "rbxassetid://4797034721"
PlayAnim = Character.Humanoid:LoadAnimation(Anim)
PlayAnim2 = Character.Humanoid:LoadAnimation(Anim2)

function Sprint()
	PlayAnim2:Stop()
	PlayAnim:Play()
	Character.Humanoid.WalkSpeed = 30
end

function Walk()
	PlayAnim:Stop()
	PlayAnim2:Play()
	Character.Humanoid.WalkSpeed = 12
end

function Footstep()
	local footstepSound = script.Footstep:Clone()
	footstepSound.Parent = Character.HumanoidRootPart
	footstepSound:Play()
	footstepSound.Ended:Connect(function()
		footstepSound:Destroy()
	end)
end

UIS.InputBegan:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		HoldingShift = true
		if WalkingForward then
			Sprint()
		end
	elseif input.KeyCode == Enum.KeyCode.W then
		WalkingForward = true
		Walk()
		if HoldingShift then
			Sprint()
		end
	end
end)

UIS.InputEnded:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		Walk()
		HoldingShift = false
	elseif input.KeyCode == Enum.KeyCode.W then
		Walk()
		WalkingForward = false
		PlayAnim2:Stop()
	end
end)

PlayAnim:GetMarkerReachedSignal("Footstep"):Connect(function()
	Footstep()
end)

PlayAnim2:GetMarkerReachedSignal("Footstep"):Connect(function()
	Footstep()
end)

--[[ 	IMPORTANT: what the fu is all this crap below							IMPORTANT: what the fu is all this crap below
UIS.InputBegan:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		HoldingShift = true
		if WalkingForward then
			Sprint()
		end
	elseif input.KeyCode == Enum.KeyCode.A then
		WalkingForward = true
		Walk()
		if HoldingShift then
			Sprint()
		end
	end
end)

UIS.InputEnded:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		Walk()
		HoldingShift = false
	elseif input.KeyCode == Enum.KeyCode.A then
		Walk()
		WalkingForward = false
		PlayAnim2:Stop()
	end
end)
UIS.InputBegan:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		HoldingShift = true
		if WalkingForward then
			Sprint()
		end
	elseif input.KeyCode == Enum.KeyCode.D then
		WalkingForward = true
		Walk()
		if HoldingShift then
			Sprint()
		end
	end
end)

UIS.InputEnded:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		Walk()
		HoldingShift = false
	elseif input.KeyCode == Enum.KeyCode.D then
		Walk()
		WalkingForward = false
		PlayAnim2:Stop()
	end
end)

UIS.InputBegan:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		HoldingShift = true
		if WalkingForward then
			Sprint()
		end
	elseif input.KeyCode == Enum.KeyCode.S then
		WalkingForward = true
		Walk()
		if HoldingShift then
			Sprint()
		end
	end
end)

UIS.InputEnded:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		Walk()
		HoldingShift = false
	elseif input.KeyCode == Enum.KeyCode.S then
		Walk()
		WalkingForward = false
		PlayAnim2:Stop()
	end
end)
]]