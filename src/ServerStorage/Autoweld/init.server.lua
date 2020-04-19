for i, v in pairs(script.Parent:GetChildren()) do
	if v:IsA("Model") then -- Autoweld script does not exist
		local perfectionWeldClone = script.qPerfectionWeld:Clone() -- Replicate itself
		perfectionWeldClone.Parent = v
		perfectionWeldClone.Disabled = false
		print("Perfection Weld scri")
	end
end