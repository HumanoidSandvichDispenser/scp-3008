local PunchSound = script.Parent.UpperTorso["Heavy Punch Hit"]
local Damaged = false

function onTouched(hit)
	local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if humanoid and not Damaged then
		humanoid.Health = humanoid.Health - 12
		Damaged = true
		PunchSound:Play()
		wait(2)
		Damaged = false
    end
end
script.Parent.UpperTorso.Touched:connect(onTouched)