local CanAttack = true

script.Parent.Activated:Connect(function()
	--local attack = script.Parent.Parent.Humanoid:LoadAnimation(script.Swing1)

	if CanAttack then
		CanAttack = false
		script.Parent.CanDamage.Value = true
		wait(1)
		CanAttack = true
	end
end)