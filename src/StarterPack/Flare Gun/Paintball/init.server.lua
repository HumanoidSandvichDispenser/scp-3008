--rbxsig%leIitay5G0xoc8QCL8LmFwhHlFf0gaAxhRmYajmRNYlypcjE9UWOAafcMqsgQJluLLp7bYlhQuW0emM+jY9aaT3p9IzaMnvGt32VUo6nPwB75YmXE7Lhb3U9VVlti1RSAtjqVlW8El5KbJ+0aruJll3DbbiU8RTnVR7dv/TQycY=%
--rbxassetid%1014541%

ball = script.Parent
damage = 20
local Filter = { }


function onTouched(hit)
	script.Parent.Velocity = script.Parent.Velocity * .2
	script.Parent.Force.force = Vector3.new(0,0,0)
	local humanoid = hit.Parent:findFirstChild("Humanoid")	
	if humanoid then
		if not Filter[humanoid] then
			Filter[humanoid] = true
			humanoid:TakeDamage(damage)
		end
		tagHumanoid(humanoid)
		local torso = humanoid.Parent:FindFirstChild("Torso") and humanoid.Parent.Torso or humanoid.Parent.UpperTorso
		if torso:FindFirstChild("FlareFire") then
			torso.FlareFire.Burner.Timer.Value = 5
		else
			local fiery = script.FlareFire:clone()
			fiery.Parent = torso
			fiery.Enabled = true
			fiery.Burner.Disabled = false
		end
		
		wait(2)
		untagHumanoid(humanoid)
	end
end

function tagHumanoid(humanoid)
	-- todo: make tag expire
	local tag = ball:findFirstChild("creator")
	if tag ~= nil then
		local new_tag = tag:clone()
		new_tag.Parent = humanoid
	end
end


function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:findFirstChild("creator")
		if tag ~= nil then
			tag.Parent = nil
		end
	end
end

connection = ball.Touched:connect(onTouched)