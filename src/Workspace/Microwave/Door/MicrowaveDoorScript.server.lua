local doorOpen = script.Parent.Parent.DoorOpen
local changingState = false
local running = script.Parent.Parent.Running

for i, v in pairs(script.Parent:GetChildren()) do
	if v:FindFirstChild("ClickDetector") then
		v.ClickDetector.MouseClick:Connect(function()
			if doorOpen.Value == true and changingState == false then
				changingState = true
				for i = 1, 18 do
					script.Parent:SetPrimaryPartCFrame(script.Parent.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(7), 0))
					wait()
				end
				changingState = false
				doorOpen.Value = false
			elseif changingState == false then
				doorOpen.Value = true
				running.Value = false
				changingState = true
				for i = 1, 18 do
					script.Parent:SetPrimaryPartCFrame(script.Parent.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-7), 0))
					wait()
				end
				changingState = false
			end
		end)
	end
end