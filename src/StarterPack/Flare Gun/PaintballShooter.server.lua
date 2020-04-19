local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientLookingAt = ReplicatedStorage:WaitForChild("ClientLookingAt")

local Tool = script.Parent
local Player = Tool.Parent.Parent
local Character = Player.Character

while not Character.Parent do
	Character.AncestryChanged:wait()
end

local Humanoid = Character.Humanoid
local CameraAngles
local holdAnim = Humanoid:LoadAnimation(script.Parent.Hold)

colors = {21}

function fire(v)
	Tool.Handle.Fire:play()

	local player = game.Players:playerFromCharacter(Character)
	local flare = Instance.new("Part")
	
	flare.Position = Character.PrimaryPart.Position + (v * 4)
	flare.Size = Vector3.new(.5, .5, .5)
	flare.Velocity = v * 300
	flare.Color = Color3.fromRGB(255, 20, 40)
	flare.Shape = 0
	flare.BottomSurface = 0
	flare.TopSurface = 0
	flare.Name = "Flare"
	flare.Elasticity = 0
	flare.Reflectance = 0
	flare.Friction = .9
	flare.Material = "Neon"
	
	local fire = script.Fire:Clone()
	fire.Parent = flare
	fire.Enabled = true
	
	local light = script.Light:Clone()
	light.Parent = flare
	light.Enabled = true
	
	local smoke = script.Smoke:Clone()
	smoke.Parent = flare
	smoke.Enabled = true

	local force = Instance.new("BodyForce")
	force.Name = "Force"
	force.force = Vector3.new(0,2,0)
	force.Parent = flare
	
	game:GetService("Debris"):AddItem(flare, 5)

	local newScript = script.Parent.Paintball:Clone()
	newScript.Disabled = false
	newScript.Parent = flare

	local creatorTag = Instance.new("ObjectValue")
	creatorTag.Value = player
	creatorTag.Name = "creator"
	creatorTag.Parent = flare
	
	flare.Parent = game.Workspace
end

Tool.Activated:Connect(function()

	if not Tool.Enabled then
		return
	end

	Tool.Enabled = false

	print(script:GetFullName())

	local targetPos = Humanoid.TargetPoint

	fire(CameraAngles)
	wait(4)
	Tool.Enabled = true
end)

ClientLookingAt.OnServerEvent:Connect(function(plr, cframe)
	if (plr == Player) then
		CameraAngles = cframe.lookVector
	end
end)

Tool.Equipped:Connect(function()
	holdAnim.Looped = true
	holdAnim:Play()
end)

Tool.Unequipped:Connect(function()
	holdAnim:Stop()
end)

Tool.Enabled = true