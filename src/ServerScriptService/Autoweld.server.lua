for i, v in pairs(game:GetService("Workspace").Autoweld:GetChildren()) do
	if v:IsA("Model") and v.PrimaryPart then
		for j, w in pairs(v:GetChildren()) do
			for k, x in pairs(w:GetChildren()) do
				if x:IsA("Weld") then
					x:Destroy()
				end
			end
			if w:IsA("BasePart") then
				if w ~= v.PrimaryPart then
					local weld = Instance.new("WeldConstraint", w)
					weld.Part0 = w
					weld.Part1 = v.PrimaryPart
				end
				w.Anchored = false
				w.CanCollide = true
			end
		end
		if game:GetService("ReplicatedStorage"):FindFirstChild(v.Name) then
			game:GetService("ReplicatedStorage"):FindFirstChild(v.Name):Destroy()
		end
		v.Parent = game:GetService("ReplicatedStorage")
	end
end