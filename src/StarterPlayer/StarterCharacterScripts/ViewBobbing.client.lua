local RunService = game:GetService("RunService")

local Character = script.Parent
local Humanoid = Character:WaitForChild("Humanoid")

RunService.RenderStepped:Connect(function()
	local currTime = tick()
	if Humanoid.MoveDirection.Magnitude > 0 then
		local x = math.cos(currTime * 9) * Humanoid.RootPart.Velocity.Magnitude / 48
		local y = math.abs(math.sin(currTime * 8)) * Humanoid.RootPart.Velocity.Magnitude / 36
		local viewBobbing = Vector3.new(x, y, 0)
		Humanoid.CameraOffset = Humanoid.CameraOffset:Lerp(viewBobbing, .25)
	else 
		Humanoid.CameraOffset = Humanoid.CameraOffset * .5
	end
end)

--[[
repeat wait() until game.Players.LocalPlayer.Character

camera = game.Workspace.CurrentCamera
character = game.Players.LocalPlayer.Character

Z = 0

damping = character.Humanoid.WalkSpeed / 2

PI = 3.1415926

tick = PI / 2

running = false
strafing = false

character.Humanoid.Strafing:connect(function(bool)
	strafing = bool
end)

character.Humanoid.Jumping:connect(function()
	running = false
end)

character.Humanoid.Swimming:connect(function()
	running = false
end)

character.Humanoid.Running:connect(function(speed)
	if speed > 0.1 then
		running = true
	else
		running = false
	end
end)

function mix(par1, par2, factor)
	return par2 + (par1 - par2) * factor
end

while true do
	game:GetService("RunService").RenderStepped:wait()
	
	fps = (camera.CoordinateFrame.p - character.Head.Position).Magnitude
	
	if fps < 0.52 then
		Z = 1
	else
		Z = 0
	end
	
	if running == true and strafing == false then
		tick = tick + character.Humanoid.WalkSpeed / 92 --Calculate Bobbing speed.
	else
		if tick > 0 and tick < PI / 2 then
			tick = mix(tick, PI / 2, 0.9)
		end
		if tick > PI / 2 and tick < PI then
			tick = mix(tick, PI / 2, 0.9)
		end
		if tick > PI and tick < PI * 1.5 then
			tick = mix(tick, PI * 1.5, 0.9)
		end
		if tick > PI * 1.5 and tick < PI * 2 then
			tick = mix(tick, PI * 1.5, 0.9)
		end
	end
	
	if tick >= PI * 2 then
		tick = 0
	end	
	
	camera.CoordinateFrame = camera.CoordinateFrame * 
		CFrame.new(math.cos(tick) / damping, math.sin(tick * 2) / (damping * 2), Z) * 
		CFrame.Angles(0, 0, math.sin(tick - PI * 1.5) / (damping * 20)) --Set camera CFrame
end
]]