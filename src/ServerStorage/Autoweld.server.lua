prop = script.Parent
if prop:IsA("Model") then
	for i, v in pairs(prop:GetChildren()) do
		for j, w in pairs(v:GetChildren()) do
			if w:IsA("Weld") then
				w:Destroy()
			end
		end
		if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
			v.Anchored = true
			if v ~= prop.PrimaryPart then
				local w = Instance.new("WeldConstraint", v)
		        w.Part0 = v
		        w.Part1 = prop.PrimaryPart
			end
			v.CanCollide = true
		end
		if v == prop.PrimaryPart then
			--v.Anchored = true
		end
	end
elseif prop:IsA("Part") or prop.Name == "Props" then
	for i, v in pairs(prop:GetChildren()) do
		if not v:FindFirstChild("Autoweld") then -- Autoweld script does not exist
			local scriptClone = script:Clone() -- Replicate itself
			scriptClone.Parent = v
		end
	end
end

wait()
script:Destroy()