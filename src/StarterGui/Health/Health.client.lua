local HealthBar = script.Parent:WaitForChild("HealthBarFrame")
local HealthBarHolder = HealthBar:WaitForChild("Holder")

local HungerBar = script.Parent:WaitForChild("HungerBarFrame")
local HungerBarHolder = HungerBar:WaitForChild("Holder")

local Player = game.Players.LocalPlayer
local Character = Player.Character

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Reverb = SoundService.Environment.ReverbSoundEffect
local Echo = SoundService.Environment.EchoSoundEffect

Player.CharacterAdded:Connect(function(character)
	Character = character
	Humanoid = Character:WaitForChild("Humanoid")
	
	HealthBarHolder.Size = UDim2.new(1, 0, 1, 0)
	HealthBarHolder.Center.BackgroundColor3 = Color3.fromRGB(163, 190, 140)
	
	script.Parent.BloodyScreen.BackgroundTransparency = 1
	script.Parent.BloodyScreen.ImageLabel.ImageTransparency = 1
	
	Reverb.DryLevel = -10
	Echo.Enabled = false
	
	
	Humanoid.Changed:Connect(function(Property)
		if Property == "Health" then
			print("Health changed")
			local maxHealth = Humanoid.MaxHealth
			local health = Humanoid.Health
			if health <= 100 then
			
				HealthBarHolder:TweenSize(UDim2.new(health/maxHealth, 0, 1, 0),Enum.EasingDirection.Out,Enum.EasingStyle.Bounce, .5, true)
				local color = Color3.fromRGB(191, 97, 106):Lerp(Color3.fromRGB(163, 190, 140), math.min(100, health + 10) / maxHealth)
				HealthBarHolder.Center.BackgroundColor3 = color
			
				script.Parent.BloodyScreen.BackgroundTransparency = (math.min(100, health + 50) / maxHealth)
				script.Parent.BloodyScreen.ImageLabel.ImageTransparency = (math.min(100, health + 50) / maxHealth)
		
				if health < maxHealth / 2 then
					Reverb.DryLevel = health - 60
					Echo.Enabled = true
					Echo.Feedback = (50 - health) / 100 + .25
				else
					Reverb.DryLevel = - 10
					Echo.Enabled = false
				end
			end
		end
	end)
		
	Player:WaitForChild("Info").Hunger.Changed:Connect(function()
		local hunger = Player:WaitForChild("Info").Hunger.Value
		HungerBarHolder:TweenSize(UDim2.new(hunger/100, 0, 1, 0),Enum.EasingDirection.Out,Enum.EasingStyle.Bounce, .5, true)
	end)
end)

Player.Character:WaitForChild("Humanoid").Died:Connect(function()
	script.Parent.DeathFrame.Visible = true
	script.Parent.HealthBarFrame.Visible = false
	game.StarterPlayer.StarterCharacterScripts.ViewBobbing.Disabled = true
end)