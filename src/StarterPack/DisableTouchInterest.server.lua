wait()

if script.Parent.Name == "Handle" then
	script.Parent.ChildAdded:Connect(function(child)
		if child.Name == "TouchInterest" or child:IsA("TouchTransmitter") then
			wait()
			child:Destroy()
		end
	end)
elseif script.Parent:IsA("StarterPack") or script.Parent.Name == "Items" or script.Parent.Name == "Backpack" then
	for i, v in pairs(script.Parent:GetChildren()) do
		if v:IsA("Tool") and v:FindFirstChild("Handle") then
			local clone = script:Clone()
			clone.Parent = v.Handle
		end
	end
	
	wait()
	script:Destroy()
end