wait()

for i, v in pairs(game:GetService("ServerStorage"):GetChildren()) do
	if v:IsA("Part") then
		for j, w in pairs(v:GetChildren()) do
			if w:IsA("Model") and w.PrimaryPart then
				local cframeValue = Instance.new("CFrameValue", v)
				cframeValue.Value = w.PrimaryPart.CFrame - Vector3.new(-216, 0.125, -216)
				cframeValue.Name = w.Name
				w:Destroy()
			end
		end
	end
end

--script:Destroy()