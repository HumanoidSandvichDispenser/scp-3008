local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local WalkingSpeed = 12
local SprintingSpeed = 20

local JumpPower = 35
local Jumped = false

local function Jump(chr)
	Jumped = true
	chr.Humanoid.JumpPower = JumpPower
	wait()
	chr.Humanoid.JumpPower = 0
	wait(2)
	Jumped = false
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
	local plr = game.Players.LocalPlayer
	local chr = plr.Character
	
	if not chr or not chr.Humanoid then
		return
	end
	
	if input.KeyCode == Enum.KeyCode.LeftShift then
		
		repeat
			--Workspace.Camera.FieldOfView = Workspace.Camera.FieldOfView + 0.25
			chr.Humanoid.WalkSpeed = chr.Humanoid.WalkSpeed + 1
			wait()
		until chr.Humanoid.WalkSpeed == SprintingSpeed
		
	elseif input.KeyCode == Enum.KeyCode.Space and not Jumped then
	
		local Jump = coroutine.wrap(Jump)
		Jump(chr)
		
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	local plr = game.Players.LocalPlayer
	local chr = plr.Character
	
	if not chr or not chr.Humanoid then
		return
	end
	
	if input.KeyCode == Enum.KeyCode.LeftShift then
		
		repeat
			--Workspace.Camera.FieldOfView = Workspace.Camera.FieldOfView - 0.25
			chr.Humanoid.WalkSpeed = chr.Humanoid.WalkSpeed - 1
			wait()
		until chr.Humanoid.WalkSpeed == WalkingSpeed
		
	end
end)

game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = WalkingSpeed