local looping = true
while looping do
	if script.Timer.Value >= 1 then
		script.Parent.Parent.Parent.Humanoid:TakeDamage(4)
		script.Timer.Value = script.Timer.Value - 1
	else
		looping = false
	end
	wait(1.5)
end

script.Parent:Destroy()