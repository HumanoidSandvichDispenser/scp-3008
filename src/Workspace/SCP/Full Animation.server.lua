--[[Made by Jammer622 @[http://www.roblox.com/Advanced-Player-AI-item?id=59391730],
This is the ORIGINAL model, if you see others, they are stolen.
Scripts mixed from vanilla Animate, Health, and Sound,
with much custom content by myself, making them great AIs.
No help from Miked's scripts, I made my own joint script.
If you find any glitches, bugs, or just want to suggest an idea, please message me.
My team works hard on these AIs, please don't make attempts to steal them.
Your feedback is extremely appreciated!

	_---=CREDITS=---_
The Roblox Team		Without them, none of this would be possible.
	Vanilla Sound
	Vanilla Health
	Vanilla Animate
Jammer622				That's me, main programmer and weapon publisher.
	Main Developer
	Health GUI Script
	Animation Work
	Relationship Work
	Wandering
	Pathing (Map Generation)
	Weapon Usage
	Weapon (Re)Publishing
		Sonypony458
			McDonalds Drink
	Customization
	Teamwork AI
	Model Variables
	Setting Wiki [Below]
Macdeath					I owe it to him for keeping me on track during this.
	Feature Inspiration
	Problem Solving
	Suggestions
lah30303					Amazing pathing work goes to this fine sir.
	Pathing (Pathing Generation/System)

	_---=SETTINGS=---_
Inside this model's file, you'll find several values that can be changed.
	DropWeapon					-This sets whether or not the bot will drop any equipped weapon upon dying.
	Force_Pants					-This must be set through Spawners.
	Force_Shirt					-This must be set through Spawners.
	Force_Weapon				-This must be set through Spawners.
	Force_Hat					-This must be set through Spawners.
	IgnoreCombatFF				-This sets whether or not the bot will allow friendly fire during combat.
	IsAPlayer					-This is a tag to specify this bot's existance to other AIs.
	IsOnTeam						-This sets whether or not the bot is on a team.
		ShowTag					-This sets whether or not the bot's team color name shows up beside its own.
		Team						-This sets the bot's team color.
	PathTo						-This is an experimental pathfinding engine. Use at your own risk!
	PrintMap						-This prints maps generated when using PathTo. Use at your own risk!
	Respawn						-This sets whether the bot will respawn or not upon death.
	Custom_Name					-This must be set through Spawners.
	Wander						-This sets whether the bot is stationary or if it moves, but not if it uses weapons or not.
]]
print("Player Bot Loading")
Delay(0, function() --Vanilla Sound
	function waitForChild(parent, childName)
		local child = parent:findFirstChild(childName)
		if child then return child end
		while true do
			child = parent.ChildAdded:wait()
			if child.Name==childName then return child end
		end
	end
	function newSound(id)
		local sound = Instance.new("Sound")
		sound.SoundId = id
		sound.archivable = false
		sound.Parent = script.Parent.Head
		return sound
	end
	local sDied = newSound("rbxasset://sounds/uuhhh.wav")
	local sFallingDown = newSound("rbxasset://sounds/splat.wav")
	local sFreeFalling = newSound("rbxasset://sounds/swoosh.wav")
	local sGettingUp = newSound("rbxasset://sounds/hit.wav")
	local sJumping = newSound("rbxasset://sounds/button.wav")
	local sRunning = newSound("rbxasset://sounds/bfsl-minifigfoots1.mp3")
	sRunning.Looped = true
	local Figure = script.Parent
	local Head = waitForChild(Figure, "Head")
	local Humanoid = waitForChild(Figure, "Humanoid")
	function onDied()
		sDied:Play()
	end
	function onState(state, sound)
		if state then
			sound:Play()
		else
			sound:Pause()
		end
	end
	function onRunning(speed)
		if speed>0 then
			sRunning:Play()
		else
			sRunning:Pause()
		end
	end
	Humanoid.Died:connect(onDied)
	Humanoid.Running:connect(onRunning)
	Humanoid.Jumping:connect(function(state) onState(state, sJumping) end)
	Humanoid.GettingUp:connect(function(state) onState(state, sGettingUp) end)
	Humanoid.FreeFalling:connect(function(state) onState(state, sFreeFalling) end)
	Humanoid.FallingDown:connect(function(state) onState(state, sFallingDown) end)
end)
Delay(0, function() --Vanilla Health
	function waitForChild(parent, childName)
		local child = parent:findFirstChild(childName)
		if child then return child end
		while true do
			child = parent.ChildAdded:wait()
			if child.Name==childName then return child end
		end
	end
	local Figure = script.Parent
	local Humanoid = waitForChild(Figure, "Humanoid")
	local regening = false
	function regenHealth()
		if regening then return end
		regening = true
		while Humanoid.Health < Humanoid.MaxHealth do
			local s = wait(1)
			local health = Humanoid.Health
			if health > 0 and health < Humanoid.MaxHealth then
				local newHealthDelta = 0.01 * s * Humanoid.MaxHealth
				health = health + newHealthDelta
				Humanoid.Health = math.min(health,Humanoid.MaxHealth)
			end
		end
		if Humanoid.Health > Humanoid.MaxHealth then
			Humanoid.Health = Humanoid.MaxHealth
		end
		regening = false
	end
	Humanoid.HealthChanged:connect(regenHealth)
end)
Delay(0, function() --Vanilla Animate, Multiple Additions
	function waitForChild(parent, childName)
		local child = parent:findFirstChild(childName)
		if child then return child end
		while true do
			child = parent.ChildAdded:wait()
			if child.Name==childName then return child end
		end
	end
	local Figure = script.Parent
	local Clone = Figure:Clone()
	local Torso = waitForChild(Figure, "Torso")
	local Joints = Torso:GetChildren()
	for All = 1, #Joints do
		if Joints.className == "Motor" or Joints.className == "Motor6D" then
			Joints[All]:Remove()
		end
	end
	local RightShoulder = Instance.new("Motor")
	local LeftShoulder = Instance.new("Motor")
	local RightHip = Instance.new("Motor")
	local LeftHip = Instance.new("Motor")
	local Neck = Instance.new("Motor")
	local Humanoid = waitForChild(Figure, "Humanoid")
	ZStat = 1
	ZStat2 = 0
	local pose = "Standing"
	RightShoulder.Part0 = Torso
	RightShoulder.Part1 = Figure["Right Arm"]
	RightShoulder.MaxVelocity = 0.15
	RightShoulder.Name = "Right Shoulder"
	RightShoulder.C0 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
	RightShoulder.C1 = CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
	RightShoulder.Parent = Torso
	LeftShoulder.Part0 = Torso
	LeftShoulder.Part1 = Figure["Left Arm"]
	LeftShoulder.MaxVelocity = 0.15
	LeftShoulder.Name = "Left Shoulder"
	LeftShoulder.C0 = CFrame.new(-1, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
	LeftShoulder.C1 = CFrame.new(0.5, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
	LeftShoulder.Parent = Torso
	RightHip.Part0 = Torso
	RightHip.Part1 = Figure["Right Leg"]
	RightHip.MaxVelocity = 0.1
	RightHip.Name = "Right Hip"
	RightHip.C0 = CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
	RightHip.C1 = CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
	RightHip.Parent = Torso
	LeftHip.Part0 = Torso
	LeftHip.Part1 = Figure["Left Leg"]
	LeftHip.MaxVelocity = 0.1
	LeftHip.Name = "Left Hip"
	LeftHip.C0 = CFrame.new(-1, -1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
	LeftHip.C1 = CFrame.new(-0.5, 1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
	LeftHip.Parent = Torso
	Neck.Part0 = Torso
	Neck.Part1 = Figure["Head"]
	Neck.MaxVelocity = 0.1
	Neck.Name = "Neck"
	Neck.C0 = CFrame.new(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
	Neck.C1 = CFrame.new(0, -0.5, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
	Neck.Parent = Torso
	local toolAnim = "None"
	local toolAnimTime = 0
	SpawnModel = Instance.new("Model")
	function onRunning(speed)
		if speed>0 then
			pose = "Running"
		else
			pose = "Standing"
		end
	end
	function CheckTag(Tag)
		if script.Parent:FindFirstChild("IsLocalEnemy") == nil and script.Parent:FindFirstChild("IsAZombie") == nil and Tag.ClassName == "ObjectValue" and Tag.Value ~= nil and Tag.Value.ClassName == "Player" and Tag.Value.Character ~= nil then
			if Tag.Value.Character:FindFirstChild("IsLocalEnemy") == nil then
				if (script.Parent.IsOnTeam.Value == true and IsInCombat == false and script.Parent.IsOnTeam.Team.Value == Tag.Value.TeamColor) or script.Parent.IsOnTeam.Value == false then
					local Tag2 = Instance.new("CFrameValue", Tag.Value.Character)
					Tag2.Name = "IsLocalEnemy"
					print(Tag.Value.Character.Name .." Has Become An Outlaw")
				end
			end
			if Tag.Value.Character:FindFirstChild("Loc" ..script.Parent.Name) ~= nil then
				Tag.Value.Character:FindFirstChild("Loc" ..script.Parent.Name):Remove()
			end
			local Found = Instance.new("CFrameValue", Tag.Value.Character)
			Found.Name = "Loc" ..script.Parent.Name
			game:GetService("Debris"):AddItem(Found, 3)
		elseif script.Parent:FindFirstChild("IsLocalEnemy") == nil and script.Parent:FindFirstChild("IsAZombie") == nil and Tag.ClassName == "StringValue" and game.Players:FindFirstChild(Tag.Value) ~= nil and game.Players[Tag.Value].Character ~= nil then
			if game.Players[Tag.Value].Character:FindFirstChild("IsLocalEnemy") == nil then
				if (script.Parent.IsOnTeam.Value == true and IsInCombat == false and script.Parent.IsOnTeam.Team.Value == game.Players[Tag.Value].TeamColor) or script.Parent.IsOnTeam.Value == false then
					local Tag2 = Instance.new("CFrameValue", game.Players[Tag.Value].Character)
					Tag2.Name = "IsLocalEnemy"
					print(Tag.Value .." Has Become An Outlaw")
				end
			end
			if game.Players[Tag.Value].Character:FindFirstChild("Loc" ..script.Parent.Name) ~= nil then
				game.Players[Tag.Value].Character:FindFirstChild("Loc" ..script.Parent.Name):Remove()
			end
			local Found = Instance.new("CFrameValue", game.Players[Tag.Value].Character)
			Found.Name = "Loc" ..script.Parent.Name
			game:GetService("Debris"):AddItem(Found, 3)
		elseif script.Parent:FindFirstChild("IsLocalEnemy") == nil and script.Parent:FindFirstChild("IsAZombie") == nil and Tag.ClassName == "StringValue" and game.Workspace:FindFirstChild(Tag.Value) ~= nil then
			if game.Workspace[Tag.Value]:FindFirstChild("IsLocalEnemy") == nil then
				if (script.Parent.IsOnTeam.Value == true and IsInCombat == false and Workspace[Tag.Value].IsOnTeam.Value == true and script.Parent.IsOnTeam.Team.Value == Workspace[Tag.Value].IsOnTeam.Team.Value) or script.Parent.IsOnTeam.Value == false or Workspace[Tag.Value].IsOnTeam.Value == false then
					local Tag2 = Instance.new("CFrameValue", game.Workspace[Tag.Value])
					Tag2.Name = "IsLocalEnemy"
					print(Tag.Value .." Has Become An Outlaw")
				end
			end
			if game.Workspace[Tag.Value]:FindFirstChild("Loc" ..script.Parent.Name) ~= nil then
				game.Workspace[Tag.Value]:FindFirstChild("Loc" ..script.Parent.Name):Remove()
			end
			local Found = Instance.new("CFrameValue", game.Workspace[Tag.Value])
			Found.Name = "Loc" ..script.Parent.Name
			game:GetService("Debris"):AddItem(Found, 3)
		elseif (script.Parent:FindFirstChild("IsLocalEnemy") ~= nil or script.Parent:FindFirstChild("IsAZombie") ~= nil) and Tag.ClassName == "ObjectValue" and Tag.Value ~= nil and Tag.Value.ClassName == "Player" and Tag.Value.Character ~= nil then
			local Found = Instance.new("CFrameValue", Tag.Value.Character)
			Found.Name = "Loc" ..script.Parent.Name
			game:GetService("Debris"):AddItem(Found, 3)
		elseif (script.Parent:FindFirstChild("IsLocalEnemy") ~= nil or script.Parent:FindFirstChild("IsAZombie") ~= nil) and Tag.ClassName == "StringValue" and game.Workspace:FindFirstChild(Tag.Value) ~= nil then
			local Found = Instance.new("CFrameValue", game.Workspace[Tag.Value])
			Found.Name = "Loc" ..script.Parent.Name
			game:GetService("Debris"):AddItem(Found, 3)
		end
	end
	function CheckSpawns(Object)
		local Parts = Object:GetChildren()
		for Check = 1, #Parts do
			if Parts[Check].className == "SpawnLocation" then
				local I = Instance.new("Vector3Value", SpawnModel)
				I.Value = Parts[Check].Position
			end
			CheckSpawns(Parts[Check])
		end
	end
	function onDied()
		pose = "Dead"
		Delay(5, function()
			if script.Parent.Respawn.Value == true then
				CheckSpawns(Workspace)
				local Spawn = SpawnModel:GetChildren()
				Clone.Parent = game.Workspace
				if #Spawn > 0 then
					Spawn = Spawn[math.random(1, #Spawn)].Value
					Clone:MoveTo(Spawn)
				else
					Clone:MoveTo(Vector3.new(0, 50, 0))
				end
			end
			Figure:Remove()
			return
		end)
	end
	function onJumping()
		pose = "Jumping"
	end
	function onClimbing()
		pose = "Climbing"
	end
	function onGettingUp()
		pose = "GettingUp"
	end
	function onFreeFall()
		pose = "FreeFall"
	end
	function onFallingDown()
		pose = "FallingDown"
	end
	function onSeated()
		pose = "Seated"
	end
	function onPlatformStanding()
		pose = "PlatformStanding"
	end
	function moveJump()
		RightShoulder.MaxVelocity = 0.5
		LeftShoulder.MaxVelocity = 0.5
		RightShoulder.DesiredAngle = (3.14/ZStat)
		LeftShoulder.DesiredAngle = (-3.14/ZStat)
		RightHip.DesiredAngle = (0)
		LeftHip.DesiredAngle = (0)
	end
	function moveFreeFall()
		RightShoulder.MaxVelocity = 0.5
		LeftShoulder.MaxVelocity = 0.5
		RightShoulder.DesiredAngle = (3.14/ZStat)
		LeftShoulder.DesiredAngle = (-3.14/ZStat)
		RightHip.DesiredAngle = (0)
		LeftHip.DesiredAngle = (0)
	end
	function moveSit()
		RightShoulder.MaxVelocity = 0.15
		LeftShoulder.MaxVelocity = 0.15
		RightShoulder.DesiredAngle = (3.14 /2)
		LeftShoulder.DesiredAngle = (-3.14 /2)
		RightHip.DesiredAngle = (3.14 /2)
		LeftHip.DesiredAngle = (-3.14 /2)
	end
	function getTool()	
		for _, kid in ipairs(Figure:GetChildren()) do
			if kid.className == "Tool" then return kid end
		end
		return nil
	end
	function getToolAnim(tool)
		for _, c in ipairs(tool:GetChildren()) do
			if c.Name == "toolanim" and c.className == "StringValue" then
				return c
			end
		end
		return nil
	end
	function animateTool()
		if (toolAnim == "None") then
			RightShoulder.DesiredAngle = (1.57)
			return
		end
		if (toolAnim == "Slash") then
			RightShoulder.MaxVelocity = 0.5
			RightShoulder.DesiredAngle = (0)
			return
		end
		if (toolAnim == "Lunge") then
			RightShoulder.MaxVelocity = 0.5
			LeftShoulder.MaxVelocity = 0.5
			RightHip.MaxVelocity = 0.5
			LeftHip.MaxVelocity = 0.5
			RightShoulder.DesiredAngle = (1.57)
			LeftShoulder.DesiredAngle = (1.0)
			RightHip.DesiredAngle = (1.57)
			LeftHip.DesiredAngle = (1.0)
			return
		end
	end
	function move(time)
		local amplitude
		local frequency
		if (pose == "Jumping") then
			moveJump()
			return
		end
		if (pose == "FreeFall") then
			moveFreeFall()
			return
		end	 
		if (pose == "Seated") then
			moveSit()
			return
		end
		local climbFudge = 0
		if (pose == "Running") then
			RightShoulder.MaxVelocity = 0.15
			LeftShoulder.MaxVelocity = 0.15
			amplitude = 1
			frequency = 9
		elseif (pose == "Climbing") then
			RightShoulder.MaxVelocity = 0.5 
			LeftShoulder.MaxVelocity = 0.5
			amplitude = 1
			frequency = 9
			climbFudge = 3.14
		else
			amplitude = 0.1
			frequency = 1
		end
		desiredAngle = amplitude * math.sin(time*frequency)
		RightShoulder.DesiredAngle = (desiredAngle + climbFudge) + ZStat2
		LeftShoulder.DesiredAngle = (desiredAngle - climbFudge) -ZStat2
		RightHip.DesiredAngle = (-desiredAngle)
		LeftHip.DesiredAngle = (-desiredAngle)
		local tool = getTool()
		if tool then
			animStringValueObject = getToolAnim(tool)
			if animStringValueObject then
				toolAnim = animStringValueObject.Value
				animStringValueObject.Parent = nil
				toolAnimTime = time + .3
			end
			if time > toolAnimTime then
				toolAnimTime = 0
				toolAnim = "None"
			end
			animateTool()
		else
			toolAnim = "None"
			toolAnimTime = 0
		end
	end
	Humanoid.Died:connect(onDied)
	Humanoid.Running:connect(onRunning)
	Humanoid.Jumping:connect(onJumping)
	Humanoid.Climbing:connect(onClimbing)
	Humanoid.GettingUp:connect(onGettingUp)
	Humanoid.FreeFalling:connect(onFreeFall)
	Humanoid.FallingDown:connect(onFallingDown)
	Humanoid.Seated:connect(onSeated)
	Humanoid.PlatformStanding:connect(onPlatformStanding)
	Humanoid.ChildAdded:connect(CheckTag)
	OriginalTime = 0.1
	Time = OriginalTime
	while Figure.Parent~=nil do
		Time = Time + 0.1
		wait(OriginalTime)
		move(Time)
	end
end)
Delay(0, function() --lah30303's Pathing Script
	function CalcMoves(map, px, py, tx, ty) 
		if map[ty][tx] ~= 0 then
			return nil
		end
		local openlist, closedlist, listk, closedk, tempH, tempG, xsize, ysize, curbase = {}, {}, 1, 0, math.abs(px - tx) + math.abs(py - ty), 0, #map[1], #map, {}
		openlist[1] = {x = px, y = py, g = 0, h = tempH, f = 0 + tempH ,par = 1}
		local nodenumber = 0
		while listk > 0 do
			nodenumber = nodenumber + 1
			if nodenumber / ScanSkip == math.floor(nodenumber / ScanSkip) then
				wait()
				if DebugPathing == true then
					print("Node", nodenumber)
				end
			end
			closedk = closedk + 1
			table.insert(closedlist, closedk, openlist[1])
			curbase = closedlist[closedk]
			if closedlist[closedk].x == tx and closedlist[closedk].y == ty then
				return closedlist
			end
			openlist[1] = openlist[listk]
			table.remove(openlist, listk)
			listk = listk - 1
			local v = 1
			while true do
				local u = v
				if 2 * u + 1 <= listk then
					if openlist[u].f >= openlist[2 * u].f then
						v = 2 * u
					end
					if openlist[v].f >= openlist[2 * u + 1].f then
						v = 2 * u + 1
					end
				elseif 2 * u <= listk then
					if openlist[u].f >= openlist[2 * u].f then
						v = 2 * u
					end
				end
				if u ~= v then
					local temp = openlist[u]
					openlist[u] = openlist[v]
					openlist[v] = temp
				else
					break
				end
			end

			local tocheck = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}, {-1, -1}, {1, -1}, {-1, 1}, {1, 1}} --[1]Right, [2]Left, [3]Down, [4]Up, [5]UpLeft, [6]UpRight, [7]DownLeft, [8]DownRight
			if closedk > 0 then
				for k = 1, closedk do
					for i, v in pairs(tocheck) do
						if closedlist[k].x == curbase.x + v[1] and closedlist[k].y == curbase.y + v[2] then
							tocheck[i] = nil
						end
					end
				end
			end
			for i, v in pairs(tocheck) do
				local a = curbase.x + v[1]
				local b = curbase.y + v[2]
				if a > xsize or a < 1 or b > ysize or b < 1 then
					tocheck[i] = nil
				end
			end
			for i, v in pairs(tocheck) do
				local a, b = curbase.x + v[1], curbase.y + v[2]
				if a <= xsize and a >= 1 and b <= ysize and b >= 1 and map[b][a] ~= 0 then
					tocheck[i] = nil
				end
			end
			tempG = curbase.g + 1
			tempDiagG = curbase.g + 1.4
			for k = 1, listk do
				for i, v in pairs(tocheck) do
					if openlist[k].x == curbase.x + v[1] and openlist[k].y == curbase.y + 1 and openlist[k].g > tempG then
						tempH = math.abs((curbase.x + v[1])-tx) + math.abs((curbase.y + v[1])-ty)
						table.insert(openlist, k, {x = curbase.x + v[1], y = curbase.y + v[2], g = tempG, h = tempH, f = tempG + tempH, par = closedk})
						local m = k
						while m ~= 1 do
							if openlist[m].f <= openlist[math.floor(m/2)].f then
								temp = openlist[math.floor(m/2)]
								openlist[math.floor(m/2)] = openlist[m]
								openlist[m] = temp
								m = math.floor(m/2)
							else
								break
							end
							tocheck[i] = nil
						end
					end
				end
			end
			for i, v in pairs(tocheck) do
				listk = listk + 1
				tempH = math.abs((curbase.x + v[1]) - tx) + math.abs((curbase.y + v[2]) - ty)
				table.insert(openlist, listk, {x = curbase.x + v[1], y = curbase.y + v[2], g = tempG, h = tempH, f = tempG+tempH, par = closedk})
				m = listk
				while m ~= 1 do
					if openlist[m].f <= openlist[math.floor(m/2)].f then
						temp = openlist[math.floor(m/2)]
						openlist[math.floor(m/2)] = openlist[m]
						openlist[m] = temp
						m = math.floor(m/2)
					else
						break
					end
				end
			end
		end
		return nil
	end


	function CalcPath(closedlist)

		if closedlist == nil or table.getn(closedlist) == 1 then
			return nil
		end
		local path = {}
		local pathIndex = {}
		local last = table.getn(closedlist)
		table.insert(pathIndex,1,last)

		local i = 1
		while pathIndex[i] > 1 do
			i = i + 1
			table.insert(pathIndex, i, closedlist[pathIndex[i - 1]].par)
		end 

		for n = table.getn(pathIndex) - 1, 1, -1 do
			table.insert(path, {x = closedlist[pathIndex[n]].x, y = closedlist[pathIndex[n]].y})
		end

		closedlist = nil
		return path
	end
end)
Delay(0, function() --Main Artificial Intelligence Scripting/Path Grid Generator
	local Base
	if script.Parent:FindFirstChild("BASE") == nil then
		Base = Instance.new("Part")
		Base.Transparency = 1
		Base.TopSurface = "Smooth"
		Base.BottomSurface = "Smooth"
		Base.CanCollide = false
		Base.Anchored = true
		Base.Locked = true
		Base.BrickColor = BrickColor.new(0, 0, 0)
		Base.Name = "BASE"
		Base.CFrame = CFrame.new(Vector3.new(0, 0, 0))
		Base.Parent = script.Parent
	else
		Base = script.Parent.BASE
		Base.CFrame = CFrame.new(Vector3.new(0, 0, 0))
	end
	function Jump()
		script.Parent.Humanoid.Jump = true
	end
	function Check(Hit)
		if Hit ~= nil and Hit.Parent ~= nil and Hit.Parent.Parent ~= nil then
			if Hit.Parent:FindFirstChild("Humanoid") == nil and Hit.Parent.Parent:FindFirstChild("Humanoid") == nil then
				Jump()
			end
		end
	end
	script.Parent.Torso.Touched:connect(Check)
	function Prep(Target, Current, Attempts)
		if Attempts == nil then
			Attempts = 1000
		end
		local Hit = false
		local Tag = Base:Clone()
		Tag.Position = Target
		Tag.Parent = script.Parent
		local TagRay = Ray.new(Tag.CFrame.p, (CFrame.new(Tag.CFrame.p - Vector3.new(0, 3, 0)).p - Tag.CFrame.p).Unit * 40)
		local TRHit, TRPos = game.Workspace:FindPartOnRay(TagRay, script.Parent)
		if TRHit ~= nil then
			Hit = true
		end
		if Tag.Parent ~= nil then
			Tag:Remove()
		end
		if Hit == false and Attempts > 0 and script.Parent.Wander.Value == true then
			Prep(script.Parent.Torso.Position + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100)), Base, Attempts - 1)
		elseif script.Parent.Wander.Value == true then
			local TargetRay = Ray.new(script.Parent.Torso.CFrame.p, (CFrame.new(Target).p - script.Parent.Torso.CFrame.p).Unit * ((Target - script.Parent.Torso.Position).Magnitude - 3))
			local THit, TPos = game.Workspace:FindPartOnRay(TargetRay, script.Parent)
			local TrueTarget = script.Parent.Torso.Position
			if THit ~= nil then
				for HazardCheck = 1, math.floor((script.Parent.Torso.CFrame.p - TPos).Magnitude) do
					local TR2 = Ray.new(script.Parent.Torso.CFrame.p + (TPos - script.Parent.Torso.CFrame.p).Unit * HazardCheck, Vector3.new(0, -50, 0) + (TPos - script.Parent.Torso.CFrame.p).Unit * 3)
					local TH2, TP2 = game.Workspace:FindPartOnRay(TR2, script.Parent)
					if TH2 ~= nil and TH2.Name ~= "Lava" then
						TrueTarget = TP2
					else
						break
					end
				end
			else
				for HazardCheck = 1, math.floor((script.Parent.Torso.CFrame.p - Target).Magnitude) do
					local TR2 = Ray.new(script.Parent.Torso.CFrame.p + (Target - script.Parent.Torso.CFrame.p).Unit * HazardCheck, Vector3.new(0, -50, 0) + (TPos - script.Parent.Torso.CFrame.p).Unit * 3)
					local TH2, TP2 = game.Workspace:FindPartOnRay(TR2, script.Parent)
					if TH2 ~= nil and TH2.Name ~= "Lava" then
						TrueTarget = TP2
					else
						break
					end
				end
			end
			script.Parent.Humanoid:MoveTo(TrueTarget, Current)
		end
	end
	function ZHit(Part)
		if script.Parent:FindFirstChild("IsAZombie") ~= nil and script.Parent.Humanoid.Health > 0 and Part ~= nil and Part.Parent ~= nil and Part.Parent:FindFirstChild("Humanoid") ~= nil and Part.Parent:FindFirstChild("IsAZombie") == nil then
			Part.Parent.Humanoid:TakeDamage(2)
			script.Parent.Humanoid.MaxHealth = script.Parent.Humanoid.MaxHealth + 1
			script.Parent.Humanoid:TakeDamage(-1)
		end
	end
	script.Parent["Right Arm"].Touched:connect(ZHit)
	script.Parent["Left Arm"].Touched:connect(ZHit)
	CurrentMap = {}
	MapMask = {}
	MapVar = {0, 0, 0, 0, 0}
	BlockScanned = 0
	ScanSkip = 5
	DebugPathing = true
	function GenerateMap(PathPos)
		CurrentMap = {}
		MapMask = {}
		MapVar = {0, 0, 0, 0, 0}
		BlockScanned = 0
		MapVariables = ScanParts(Workspace, 1)
		for MapX = 1, math.max(-MapVariables[1], MapVariables[2]) * 2 + 1 do
			CurrentMap[MapX] = {}
			for MapY = 1, math.max(-MapVariables[3], MapVariables[4]) * 2 + 1 do
				CurrentMap[MapX][MapY] = 0
			end
		end
		for MaskX = 1, #CurrentMap do
			MapMask[MaskX] = {}
			for MaskY = 1, #CurrentMap[MaskX] do
				MapMask[MaskX][MaskY] = {MapVariables[1] + MaskX - 0.5, MapVariables[1] + MaskY - 0.5}
			end
		end
		ScanParts(Workspace, 2, MapVariables)
		wait(1)
		if script.Parent.PrintMap.Value == true then
			print("Printing Map...")
			for ClearPrint = 1, 250 do
				wait()
				print()
			end
			for PrintX = 1, #CurrentMap do
				local PrintZ = ""
				for PrintY = 1, #CurrentMap[PrintX] do
					PrintZ = PrintZ ..CurrentMap[PrintX][PrintY]
				end
				print(PrintZ)
				wait(0.1)
			end
		end
		local MapCoords = {0, 0, 0, 0}
		local Distance = math.huge
		for MPX = 1, #CurrentMap do
			for MPY = 1, #CurrentMap[MPX] do
				if (Vector3.new(MapMask[MPX][MPY][1], 0, MapMask[MPX][MPY][2]) - Vector3.new(script.Parent.Torso.Position.X, 0, script.Parent.Torso.Position.Z)).Magnitude < Distance then
					MapCoords = {MPX, MPY, 0, 0}
					Distance = (Vector3.new(MapMask[MPX][MPY][1], 0, MapMask[MPX][MPY][2]) - Vector3.new(script.Parent.Torso.Position.X, 0, script.Parent.Torso.Position.Z)).Magnitude
				end
			end
		end
		local Distance = math.huge
		for MPX = 1, #CurrentMap do
			for MPY = 1, #CurrentMap[MPX] do
				if (Vector3.new(MapMask[MPX][MPY][1], 0, MapMask[MPX][MPY][2]) - Vector3.new(script.Parent.PathTo.Value.X, 0, script.Parent.PathTo.Value.Z)).Magnitude < Distance then
					MapCoords = {MapCoords[1], MapCoords[2], math.min(MPX, #CurrentMap) - 1, math.min(MPY, #CurrentMap[1] - 1)}
					Distance = (Vector3.new(MapMask[MPX][MPY][1], 0, MapMask[MPX][MPY][2]) - Vector3.new(script.Parent.PathTo.Value.X, 0, script.Parent.PathTo.Value.Z)).Magnitude
				end
			end
		end
		for i, v in pairs(CalcPath(CalcMoves(CurrentMap, MapCoords[1], MapCoords[2], MapCoords[3], MapCoords[4]))) do
			local Timer = 20
			local pX = v["x"]
			local pY = v["y"]
			local pTo = Vector3.new(MapMask[pX][pY][1], 0, MapMask[pX][pY][2])
			pTo = pTo + (pTo - Vector3.new(script.Parent.Torso.Position.X, 0, script.Parent.Torso.Position.Z)).Unit
			while (Vector3.new(script.Parent.Torso.Position.X, 0, script.Parent.Torso.Position.Z) - pTo).Magnitude > 2.5 and Timer > 0 do
				script.Parent.Humanoid:MoveTo(pTo, Base)
				Timer = Timer - 1
				if Timer == 10 then
					script.Parent.Humanoid.Jump = true
				end
				wait(0.1)
			end
			if Timer == 0 then
				if (Vector3.new(script.Parent.Torso.Position.X, 0, script.Parent.Torso.Position.Z) - pTo).Magnitude <= 5 then
					script.Parent.Torso.CFrame = script.Parent.Torso.CFrame + (pTo - Vector3.new(script.Parent.Torso.Position.X, 0, script.Parent.Torso.Position.Z)).Unit * (pTo - Vector3.new(script.Parent.Torso.Position.X, 0, script.Parent.Torso.Position.Z)).Magnitude
				else
					break
				end
			end
		end
	end
	function ScanParts(CurrentModel, CurrentStage, Variables)
		local X = CurrentModel:GetChildren()
		for I = 1, #X do
			if #X[I]:GetChildren() > 0 then
				ScanParts(X[I], 1, Variables)
			end
			if X[I].ClassName == "Part" or X[I].ClassName == "WedgePart" or X[I].ClassName == "CornerWedgePart" or X[I].ClassName == "TrussPart" or X[I].ClassName == "SpawnLocation" or X[I].ClassName == "Seat" or X[I].ClassName == "VehicleSeat" or X[I].ClassName == "SkateboardPlatform" then
				BlockScanned = BlockScanned + 1
				if BlockScanned / ScanSkip == math.floor(BlockScanned / ScanSkip) then
					wait()
					if DebugPathing == true then
						print("Block", BlockScanned)
					end
				end
				if CurrentStage == 1 then
					MapVar[1] = math.min(math.ceil(X[I].Position.X - X[I].Size.X / 2), MapVar[1])
					MapVar[2] = math.max(math.floor(X[I].Position.X + X[I].Size.X / 2), MapVar[2])
					MapVar[3] = math.min(math.ceil(X[I].Position.Z - X[I].Size.Z / 2), MapVar[3])
					MapVar[4] = math.max(math.floor(X[I].Position.Z + X[I].Size.Z / 2), MapVar[4])
				elseif CurrentStage == 2 and ((X[I].Position.Y + X[I].Size.Y / 2 > script.Parent.Torso.Position.Y + 2 and X[I].Position.Y - X[I].Size.Y / 2 < script.Parent.Torso.Position.Y + 2) or X[I].Position.Y + X[I].Size.Y / 2 < script.Parent.Torso.Position.Y - 8) then
					local BlockStart = {X[I].Position.X - X[I].Size.X / 2, X[I].Position.Z - X[I].Size.Z / 2}
					local BlockEnd = {X[I].Position.X + X[I].Size.X / 2, X[I].Position.Z + X[I].Size.Z / 2}
					local BlockCoords = {0, 0, 0, 0}
					local Distance = math.huge
					for MPX = 1, #CurrentMap do
						for MPY = 1, #CurrentMap[MPX] do
							if (Vector3.new(MapMask[MPX][MPY][1], 0, MapMask[MPX][MPY][2]) - Vector3.new(BlockStart[1], 0, BlockStart[2])).Magnitude < Distance then
								BlockCoords = {MPX, MPY, 0, 0}
								Distance = (Vector3.new(MapMask[MPX][MPY][1], 0, MapMask[MPX][MPY][2]) - Vector3.new(BlockStart[1], 0, BlockStart[2])).Magnitude
							end
						end
					end
					local Distance = math.huge
					for MPX = 1, #CurrentMap do
						for MPY = 1, #CurrentMap[MPX] do
							if (Vector3.new(MapMask[MPX][MPY][1], 0, MapMask[MPX][MPY][2]) - Vector3.new(BlockEnd[1], 0, BlockEnd[2])).Magnitude < Distance then
								BlockCoords = {BlockCoords[1], BlockCoords[2], MPX, MPY}
								Distance = (Vector3.new(MapMask[MPX][MPY][1], 0, MapMask[MPX][MPY][2]) - Vector3.new(BlockEnd[1], 0, BlockEnd[2])).Magnitude
							end
						end
					end
					for XGrid = BlockCoords[2], BlockCoords[4] do
						for YGrid = BlockCoords[1], BlockCoords[3] do
							CurrentMap[XGrid][YGrid] = 1
						end
					end
				end
			end
		end
		if CurrentStage == 1 then
			MapVar[5] = {MapVar[1] + MapVar[2] / 2, MapVar[3] + MapVar[4] / 2}
			return MapVar
		end
	end
	IsInCombat = false
	while script.Parent.Humanoid.Health > 0 and script.Parent:FindFirstChild("IsAZombie") == nil do
		local Distance = 100
		local Target = nil
		IsInCombat = false
		local Players = Workspace:GetChildren()
		for Check = 1, #Players do
			if Players[Check] ~= script.Parent and ((Players[Check]:FindFirstChild("Humanoid") ~= nil and (Players[Check]:FindFirstChild("IsAZombie") ~= nil or Players[Check]:FindFirstChild("IsLocalEnemy") ~= nil or script.Parent:FindFirstChild("IsLocalEnemy") ~= nil or (script.Parent.IsOnTeam.Value == true and Players[Check]:FindFirstChild("IsOnTeam") ~= nil and Players[Check].IsOnTeam.Value == true and script.Parent.IsOnTeam.Team.Value ~= Players[Check].IsOnTeam.Team.Value) or (game.Players:GetPlayerFromCharacter(Players[Check]) ~= nil and script.Parent.IsOnTeam.Value == true and game.Players:GetPlayerFromCharacter(Players[Check]).Neutral == false and game.Players:GetPlayerFromCharacter(Players[Check]).TeamColor ~= script.Parent.IsOnTeam.Team.Value)) and Players[Check].Humanoid.Health > 0) or (Players[Check]:FindFirstChild("Zombie") ~= nil and Players[Check].Zombie.ClassName == "Humanoid" and Players[Check].Zombie.Health > 0)) and Players[Check]:FindFirstChild("Torso") ~= nil and (Players[Check].Torso.Position - script.Parent.Torso.Position).Magnitude <= 100 then
				local Ray = Ray.new(script.Parent.Torso.CFrame.p, (Players[Check].Torso.CFrame.p - script.Parent.Torso.CFrame.p).Unit * 100)
				local Hit, Position = game.Workspace:FindPartOnRay(Ray, script.Parent)
				if Hit ~= nil and Hit.Parent ~= nil and ((Hit.Parent:FindFirstChild("Humanoid") ~= nil and Hit.Parent == Players[Check]) or (Hit.Parent.Parent ~= nil and Hit.Parent.Parent:FindFirstChild("Humanoid") ~= nil and Hit.Parent.Parent == Players[Check])) then
					local TeamTag = nil
					local Parts = Players[Check]:GetChildren()
					for X = 1, #Parts do
						if Parts[X].Name == "TeamLoc" then
							if Parts[X].Value == script.Parent.IsOnTeam.Team.Value then
								TeamTag = Parts[X]
							end
						end
					end
					if Players[Check]:FindFirstChild("Loc" ..script.Parent.Name) ~= nil or Parts[X] ~= nil or (Players[Check].Torso.Position - (script.Parent.Torso.Position + script.Parent.Torso.CFrame.lookVector * 50)).Magnitude <= 52 then
						if script.Parent.IsOnTeam.Value == false then
							if Players[Check]:FindFirstChild("Loc" ..script.Parent.Name) ~= nil then
								Players[Check]:FindFirstChild("Loc" ..script.Parent.Name):Remove()
							end
							local Found = Instance.new("CFrameValue", Players[Check])
							Found.Name = "Loc" ..script.Parent.Name
							game:GetService("Debris"):AddItem(Found, 3)
						else
							if Parts[X] ~= nil then
								Parts[X]:Remove()
							end
							local Found = Instance.new("BrickColorValue", Players[Check])
							Found.Name = "TeamLoc"
							Found.Value = script.Parent.IsOnTeam.Team.Value
							game:GetService("Debris"):AddItem(Found, 3)
							if Players[Check]:FindFirstChild("Loc" ..script.Parent.Name) ~= nil then
								Players[Check]:FindFirstChild("Loc" ..script.Parent.Name):Remove()
							end
							local Found = Instance.new("CFrameValue", Players[Check])
							Found.Name = "Loc" ..script.Parent.Name
							game:GetService("Debris"):AddItem(Found, 3)
						end
					end
					if Players[Check]:FindFirstChild("Loc" ..script.Parent.Name) ~= nil and (Players[Check].Torso.Position - script.Parent.Torso.Position).Magnitude <= Distance then
						Target = Players[Check].Torso
						Distance = (Target.Position - script.Parent.Torso.Position).Magnitude
					end
				end
			end
		end
		if Target == nil then
			local HasTool = false
			local ToolCheck = script.Parent:GetChildren()
			for Check = 1, #ToolCheck do
				if ToolCheck[Check].ClassName == "Tool" then
					HasTool = true
				end
			end
			if HasTool == false then
				Distance = 100
				for Check = 1, #Players do
					if Players[Check].ClassName == "Tool" and Players[Check]:FindFirstChild("Handle") ~= nil and Players[Check]:FindFirstChild("Active") ~= nil and Players[Check]:FindFirstChild("TargetPos") ~= nil and Players[Check]:FindFirstChild("Type") ~= nil and (Players[Check].Handle.Position - script.Parent.Torso.Position).Magnitude <= Distance then
						local Ray = Ray.new(script.Parent.Torso.CFrame.p, (Players[Check].Handle.CFrame.p - script.Parent.Torso.CFrame.p).Unit * 100)
						local Hit, Position = game.Workspace:FindPartOnRay(Ray, script.Parent)
						if Hit ~= nil and Hit.Parent ~= nil and Hit.Parent == Players[Check] then
							Distance = (Players[Check].Handle.Position - script.Parent.Torso.Position).Magnitude
							Target = Players[Check]
						end
					end
				end
				if Target ~= nil and Target.ClassName == "Tool" then
					if Distance <= 5 and HasTool == false then
						Target.Parent = script.Parent
						HasTool = true
					else
						Prep(Target.Handle.Position, Base)
					end
				else
					for Check = 1, #Players do
						if Players[Check].Name == "Crate" and Players[Check]:FindFirstChild("OpenCrate") ~= nil and Players[Check].OpenCrate.Value == false and (Players[Check].Position - script.Parent.Torso.Position).Magnitude <= Distance then
							local Ray = Ray.new(script.Parent.Torso.CFrame.p, (Players[Check].CFrame.p - script.Parent.Torso.CFrame.p).Unit * 100)
							local Hit, Position = game.Workspace:FindPartOnRay(Ray, script.Parent)
							if Hit ~= nil and Hit == Players[Check] then
								Target = Players[Check]
								Distance = (Target.Position - script.Parent.Torso.Position).Magnitude
							end
						end
					end
					if Target ~= nil then
						script.Parent.Humanoid:MoveTo(Target.Position, Target)
						if (Target.Position - script.Parent.Torso.Position).Magnitude <= 10 then
							Target.OpenCrate.Value = true
						end
					else
						local HasHat = false
						local HatCheck = script.Parent:GetChildren()
						for Check = 1, #HatCheck do
							if ToolCheck[Check].ClassName == "Hat" then
								HasHat = true
							end
						end
						if HasHat == false then
							Distance = 100
							for Check = 1, #Players do
								if Players[Check].ClassName == "Hat" and Players[Check]:FindFirstChild("Handle") ~= nil and (Players[Check].Handle.Position - script.Parent.Torso.Position).Magnitude <= Distance then
									local Ray = Ray.new(script.Parent.Torso.CFrame.p, (Players[Check].Handle.CFrame.p - script.Parent.Torso.CFrame.p).Unit * 100)
									local Hit, Position = game.Workspace:FindPartOnRay(Ray, script.Parent)
									if Hit ~= nil and Hit.Parent ~= nil and Hit.Parent == Players[Check] then
										Distance = (Players[Check].Handle.Position - script.Parent.Torso.Position).Magnitude
										Target = Players[Check]
									end
								end
							end
							if Target ~= nil and Target.ClassName == "Hat" then
								if Distance <= 5 and HasHat == false then
									Target.Parent = script.Parent
									HasHat = true
								else
									Prep(Target.Handle.Position, Base)
								end
							else
								if script.Parent.Humanoid.PlatformStand == false and script.Parent.Humanoid.Sit == false then
									if script.Parent.PathTo.Value ~= Vector3.new(0, 0, 0) then
										GenerateMap(script.Parent.PathTo.Value)
										script.Parent.PathTo.Value = Vector3.new(0, 0, 0)
									elseif math.random(1, 10) == 1 and script.Parent.Wander.Value == true then
										Prep(script.Parent.Torso.Position + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100)), Base)
									end
								else
									Jump()
								end
							end
						end
					end
				end
			else
				if Target == nil then
					local Distance = 80
					local Players = Workspace:GetChildren()
					for Check = 1, #Players do
						if Players[Check]:FindFirstChild("Humanoid") ~= nil and Players[Check] ~= script.Parent and Players[Check]:FindFirstChild("IsLocalEnemy") == nil and Players[Check]:FindFirstChild("Leader") ~= nil and Players[Check].Humanoid.Health > 0 and Players[Check]:FindFirstChild("Torso") ~= nil and (Players[Check].Torso.Position - script.Parent.Torso.Position).Magnitude <= Distance then
							local Ray = Ray.new(script.Parent.Torso.CFrame.p, (Players[Check].Torso.CFrame.p - script.Parent.Torso.CFrame.p).Unit * 100)
							local Hit, Position = game.Workspace:FindPartOnRay(Ray, script.Parent)
							if Hit ~= nil and Hit.Parent ~= nil and ((Hit.Parent:FindFirstChild("Humanoid") ~= nil and Hit.Parent == Players[Check]) or (Hit.Parent.Parent ~= nil and Hit.Parent.Parent:FindFirstChild("Humanoid") ~= nil and Hit.Parent.Parent == Players[Check])) then
								Target = Players[Check].Torso
								Distance = (Target.Position - script.Parent.Torso.Position).Magnitude
							end
						end
					end
					if Target ~= nil then
						local Position = Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 10
						Prep(Position, Base)
					else
						if script.Parent.Humanoid.PlatformStand == false and script.Parent.Humanoid.Sit == false then
							if script.Parent.PathTo.Value ~= Vector3.new(0, 0, 0) then
								GenerateMap(script.Parent.PathTo.Value)
								script.Parent.PathTo.Value = Vector3.new(0, 0, 0)
							elseif math.random(1, 10) == 1 and script.Parent.Wander.Value == true then
								Prep(script.Parent.Torso.Position + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100)), Base)
							end
						else
							Jump()
						end
					end
				else
					if script.Parent.Humanoid.PlatformStand == false and script.Parent.Humanoid.Sit == false then
						if script.Parent.PathTo.Value ~= Vector3.new(0, 0, 0) then
							GenerateMap(script.Parent.PathTo.Value)
							script.Parent.PathTo.Value = Vector3.new(0, 0, 0)
						elseif math.random(1, 10) == 1 and script.Parent.Wander.Value == true then
							Prep(script.Parent.Torso.Position + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100)), Base)
						end
					else
						Jump()
					end
				end
			end
		else
			local Weapon = nil
			local ToolCheck = script.Parent:GetChildren()
			for Check = 1, #ToolCheck do
				if ToolCheck[Check].ClassName == "Tool" then
					Weapon = ToolCheck[Check]
				end
			end
			if Weapon ~= nil and Weapon:FindFirstChild("Active") ~= nil and Weapon:FindFirstChild("TargetPos") ~= nil and Weapon:FindFirstChild("Type") ~= nil then
				if Weapon.Type.Value == "Melee" then
					Prep(Target.Position + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3)), Target)
					if (Target.Position - script.Parent.Torso.Position).Magnitude <= 10 then
						Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
						Weapon.Active.Value = true
					end
				elseif Weapon.Type.Value == "Melee/Ranged" then
					if Distance <= 10 then
						Prep(Target.Position + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3)), Target)
						Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
						Weapon.Active.Value = true
					else
						Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 40, Base)
						if (Target.Position - script.Parent.Torso.Position).Magnitude <= 50 then
							Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
							Weapon.Active.Value = true
						end
					end
				elseif Weapon.Type.Value == "Melee/RangedMed" then
					if Distance <= 10 then
						Prep(Target.Position + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3)), Target)
						Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
						Weapon.Active.Value = true
					else
						Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 30, Base)
						if (Target.Position - script.Parent.Torso.Position).Magnitude <= 40 then
							Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
							Weapon.Active.Value = true
						end
					end
				elseif Weapon.Type.Value == "Melee/RangedClose" then
					if Distance <= 10 then
						Prep(Target.Position + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3)), Target)
						Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
						Weapon.Active.Value = true
					else
						Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 20, Base)
						if (Target.Position - script.Parent.Torso.Position).Magnitude <= 30 then
							Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
							Weapon.Active.Value = true
						end
					end
				elseif Weapon.Type.Value == "Ranged" then
					Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 80, Base)
					Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
					wait()
					Weapon.Active.Value = true
				elseif Weapon.Type.Value == "RangedMed" then
					Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 60, Base)
					if Distance <= 70 then
						Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
						wait()
						Weapon.Active.Value = true
					end
				elseif Weapon.Type.Value == "RangedClose" then
					Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 30, Base)
					if Distance <= 40 then
						Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
						wait()
						Weapon.Active.Value = true
					end
				elseif Weapon.Type.Value == "RangedAngle" and Distance <= 100 then
					local Position = Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * (script.Parent.Torso.Position - Target.Position).Magnitude + Target.Velocity
					script.Parent.Humanoid:MoveTo(Position, Base)
					Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
					wait()
					Weapon.Active.Value = true
				elseif Weapon.Type.Value == "RangedTactical" then
					if Distance <= 30 then
						local Position = Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 50
						Prep(Position, Base)
					elseif Distance >= 50 then
						Prep(Target.Position, Target)
					end
					if Distance <= 50 and Distance >= 30 then
						Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 40, Target.Parent.Torso)
					end
					if Distance <= 60 then
						Weapon.TargetPos.Value = Target.Position + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
						wait()
						Weapon.Active.Value = true
					end
				elseif Weapon.Type.Value == "Shuriken" then
					if Distance <= 15 then
						local Position = Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 20
						Prep(Position, Base)
					elseif Distance >= 30 then
						Prep(Target.Position, Target)
					end
					if Distance <= 30 and Distance >= 15 then
						Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 20, Target.Parent.Torso)
					end
					if Distance <= 50 then
						Weapon.TargetPos.Value = (Target.Position + Target.Velocity / 2) + Vector3.new(math.random(-2, 2), math.random(-2, 2) + ((Target.Position + Target.Velocity / 2) - script.Parent.Torso.Position).Magnitude / 8, math.random(-2, 2))
						wait()
						Weapon.Active.Value = true
					end
				elseif Weapon.Type.Value == "HealDrink" then
					local Position = Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 120
					Prep(Position, Base)
					if script.Parent.Humanoid.Health < script.Parent.Humanoid.MaxHealth then
						Weapon.Active.Value = true
					end
				elseif Weapon.Type.Value == "GrenadeDirect" then
					if Distance >= 80 and Distance <= 100 then
						Prep(Target.Position, Target)
						wait(0.5)
						Weapon.Active.Value = true
						wait(0.5)
						local Position = Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 100
						Prep(Position, Base)
					else
						local Position = Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 100
						Prep(Position, Base)
					end
				elseif Weapon.Type.Value == "Bomb" then
					if Distance > 10 then
						Prep(Target.Position, Target)
					elseif Distance <= 10 then
						Weapon.Active.Value = true
						wait(2)
						while Weapon ~= nil and Weapon:FindFirstChild("Handle") ~= nil and Weapon.Handle.Transparency == 1 do
							Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 80, Base)
							wait(0.5)
						end
					end
				elseif Weapon.Type.Value == "Backstab" then
					if Distance >= 10 then
						if (script.Parent.Torso.Position - (Target.Position + Target.CFrame.lookVector * 50)).Magnitude <= 52 then
							Prep(Target.Position, Target)
						else
							if (script.Parent.Torso.Position - (Target.Position - Target.CFrame.lookVector * 15)).Magnitude <= 5 then
								Prep(Target.Position, Base)
								local backstab_time = 20
								while backstab_time > 1 and (script.Parent.Torso.Position - Target.Position).Magnitude >= 4 do
									wait(0.1)
									backstab_time = backstab_time - 1
								end
								if (script.Parent.Torso.Position - Target.Position).Magnitude < 4 then
									Weapon.Active.Value = true
								end
							else
								Prep(Target.Position - Target.CFrame.lookVector * 15, Base)
							end
						end
					else
						Prep(Target.Position + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2)), Target)
						if Distance <= 5 then
							Weapon.Active.Value = true
						end
					end
				elseif Weapon.Type.Value == "Crossbow" then
					if Distance > 80 then
						Prep(Target.Position, Target)
					elseif Distance < 40 then
						Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 100, Base)
					elseif Distance <= 80 and Distance >= 40 then
						Prep(Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * ((script.Parent.Torso.Position - Target.Position).Magnitude - 5), Base)
						wait(0.2)
						Weapon.TargetPos.Value = Target.Position + Target.Velocity / 8 + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
						Weapon.Active.Value = true
					end
				end
				IsInCombat = true
			elseif Distance <= 100 then
				local Position = Target.Position + (script.Parent.Torso.Position - Target.Position).Unit * 120
				Prep(Position, Base)
			end
		end
		if IsInCombat == true then
			wait(0.2)
		else
			wait(0.6)
		end
	end
	local Weapon = nil
	local ToolCheck = script.Parent:GetChildren()
	for Check = 1, #ToolCheck do
		if ToolCheck[Check].ClassName == "Tool" then
			Weapon = ToolCheck[Check]
		end
	end
	if Weapon ~= nil and script.Parent.DropWeapon.Value == true then
		Weapon.Parent = Workspace
	elseif Weapon ~= nil then
		Weapon:Remove()
	end
	if script.Parent:FindFirstChild("IsAZombie") ~= nil then
		script.Parent.Name = "New Zombie"
		script.Parent.Humanoid.MaxHealth = script.Parent.Humanoid.MaxHealth + math.random(math.random(-50, -25), math.random(25, math.random(50, 100)))
		wait()
		script.Parent.Humanoid.Health = script.Parent.Humanoid.MaxHealth
		script.Parent.Humanoid.WalkSpeed = script.Parent.Humanoid.WalkSpeed + math.random(math.random(-200, 0), math.random(100, math.random(200, 300))) / 100
		ZStat = 2
		ZStat2 = 1.57
		Delay(1, function()
			while script.Parent:FindFirstChild("Humanoid") ~= nil and script.Parent.Humanoid.Health > 0 do
				script.Parent.Humanoid.MaxHealth = math.max(0, script.Parent.Humanoid.MaxHealth - 1)
				script.Parent.Humanoid.Health = math.min(script.Parent.Humanoid.Health, script.Parent.Humanoid.MaxHealth)
				wait(1)
			end
		end)
		while script.Parent.Humanoid.Health > 0 and script.Parent:FindFirstChild("IsAZombie") ~= nil do
			local Distance = 100
			local Target = nil
			local Players = Workspace:GetChildren()
			for Check = 1, #Players do
				if Players[Check]:FindFirstChild("Humanoid") ~= nil and Players[Check]:FindFirstChild("Torso") ~= nil and Players[Check]:FindFirstChild("IsAZombie") == nil and Players[Check].Humanoid.Health > 0 and (Players[Check].Torso.Position - script.Parent.Torso.Position).Magnitude <= 100 then
					local ZRay = Ray.new(script.Parent.Torso.CFrame.p, (Players[Check].Torso.CFrame.p - script.Parent.Torso.CFrame.p).Unit * 100)
					local ZHit, ZPos = Workspace:FindPartOnRay(ZRay, script.Parent)
					if Players[Check]:FindFirstChild("ZFound") ~= nil or (ZHit ~= nil and ZHit.Parent ~= nil and ZHit.Parent.Parent ~= nil and (ZHit.Parent == Players[Check] or ZHit.Parent.Parent == Players[Check])) then
						if ZHit ~= nil and ZHit.Parent ~= nil and ZHit.Parent.Parent ~= nil and (ZHit.Parent == Players[Check] or ZHit.Parent.Parent == Players[Check]) then
							if Players[Check]:FindFirstChild("ZFound") ~= nil then
								Players[Check].ZFound:Remove()
							end
							local ZTag = Instance.new("CFrameValue", Players[Check])
							ZTag.Name = "ZFound"
							game:GetService("Debris"):AddItem(ZTag, 5)
						end
						if (Players[Check].Torso.Position - script.Parent.Torso.Position).Magnitude <= Distance then
							Target = Players[Check].Torso
							Distance = (Target.Position - script.Parent.Torso.Position).Magnitude
						end
					end
				end
			end
			if Target == nil then
				if script.Parent.Humanoid.PlatformStand == false and script.Parent.Humanoid.Sit == false then
					if math.random(1, 10) == 1 and script.Parent.Wander.Value == true then
						Prep(script.Parent.Torso.Position + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100)), Base)
					end
				else
					Jump()
				end
			elseif script.Parent.Wander.Value == true then
				script.Parent.Humanoid:MoveTo(Target.Position + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2)), Target)
			end
			wait(0.8)
		end
	end
end)
Delay(0, function() --Random Tool Usage Script
	while true do
		wait(math.random(40, 70 + math.random(30, 120)) / 10)
		local Weapon = nil
		local ToolCheck = script.Parent:GetChildren()
		for Check = 1, #ToolCheck do
			if ToolCheck[Check].ClassName == "Tool" then
				Weapon = ToolCheck[Check]
			end
		end
		if Weapon ~= nil and Weapon:FindFirstChild("Active") ~= nil and Weapon:FindFirstChild("TargetPos") ~= nil and Weapon:FindFirstChild("Type") ~= nil then
			if Weapon.Type.Value == "HealDrink" then
				Weapon.Active.Value = true
			end
		end
	end
end)
Delay(1, function() --Player Customization Script
	if script.Parent["Custom_Name"].Value == "" then
		script.Parent.Name = "Player" ..math.random(1, 999)
	else
		script.Parent.Name = script.Parent["Custom_Name"].Value
	end
	BColors = {3, 5, 12, 18, 108, 128, 138, 224, 224, 226, 226}
	SColors = {145, 146, 147, 148, 149, 150, 168, 176, 178, 179, 200}
	PColors = {190, 191, 193, 1024, 1025, 1026, 1027, 1028, 1029, 1030}
	BColor = BrickColor.new(BColors[math.random(1, #BColors)])
	SColor = BrickColor.new(SColors[math.random(1, #SColors)])
	PColor = BrickColor.new(PColors[math.random(1, #PColors)])
	if script.Parent.IsOnTeam.Value == true then
		SColor = script.Parent.IsOnTeam.Team.Value
		PColor = SColor
		if script.Parent.IsOnTeam.ShowTag.Value == true then
			script.Parent.Name = script.Parent.Name .." [" ..script.Parent.IsOnTeam.Team.Value.Name .."]"
		end
	end
	if script.Parent["Body Colors"].ForceColors.Value ~= true then
		script.Parent["Body Colors"].HeadColor = BColor
		script.Parent["Body Colors"].LeftArmColor = BColor
		script.Parent["Body Colors"].LeftLegColor = PColor
		script.Parent["Body Colors"].RightArmColor = BColor
		script.Parent["Body Colors"].RightLegColor = PColor
		script.Parent["Body Colors"].TorsoColor = SColor
	end
	script.Parent.Head.BrickColor = script.Parent["Body Colors"].HeadColor
	script.Parent["Left Arm"].BrickColor = script.Parent["Body Colors"].LeftArmColor
	script.Parent["Left Leg"].BrickColor = script.Parent["Body Colors"].LeftLegColor
	script.Parent["Right Arm"].BrickColor = script.Parent["Body Colors"].RightArmColor
	script.Parent["Right Leg"].BrickColor = script.Parent["Body Colors"].RightLegColor
	script.Parent.Torso.BrickColor = script.Parent["Body Colors"].TorsoColor
	if script.Parent["Force_Weapon"].Value ~= 0 then
		local x = game:GetService("InsertService"):LoadAsset(script.Parent["Force_Weapon"].Value)
		local c = x:GetChildren()
		for i = 1, #c do
			if c[i].ClassName == "Tool" and c[i]:FindFirstChild("AIProgram") ~= nil and c[i]:FindFirstChild("Active") ~= nil and c[i]:FindFirstChild("TargetPos") ~= nil and c[i]:FindFirstChild("Type") ~= nil and c[i]:FindFirstChild("Handle") ~= nil then
				c[i].Parent = script.Parent
				script.Parent.DropWeapon.Value = false
			end
		end
	end
	if script.Parent["Force_Hat"].Value ~= 0 then
		local x = game:GetService("InsertService"):LoadAsset(script.Parent["Force_Hat"].Value)
		local c = x:GetChildren()
		for i = 1, #c do
			if c[i].ClassName == "Hat" and c[i]:FindFirstChild("Handle") ~= nil then
				c[i].Parent = script.Parent
			end
		end
	end
	if script.Parent["Force_Shirt"].Value ~= 0 then
		local x = game:GetService("InsertService"):LoadAsset(script.Parent["Force_Shirt"].Value)
		local c = x:GetChildren()
		for i = 1, #c do
			if c[i].ClassName == "Shirt" then
				c[i].Parent = script.Parent
			end
		end
	end
	if script.Parent["Force_Pants"].Value ~= 0 then
		local x = game:GetService("InsertService"):LoadAsset(script.Parent["Force_Pants"].Value)
		local c = x:GetChildren()
		for i = 1, #c do
			if c[i].ClassName == "Pants" then
				c[i].Parent = script.Parent
			end
		end
	end
end)
wait()
print("Player Bot Loaded")