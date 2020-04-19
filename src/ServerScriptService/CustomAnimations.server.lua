----------------------------------------
-- Script Made By UndiscoveredLimited --
--          Change IDs Below          --
----------------------------------------

idle1Enabled = true -- Idle animation 1 enabled - true/false
idleId1 = "000000000" -- Idle animation 1
idle2Enabled = true -- Idle animation 2 enabled - true/false
idleId2 = "000000000" -- Idle animation 2
walkEnabled = true -- Walk animation enabled - true/false
walkId = "000000000" -- Walk animation
runEnabled = true -- Run animation enabled - true/false
runId = "000000000" -- Run animation
jumpEnabled = true -- Jump animation enabled - true/false
jumpId = "000000000" -- Jump animation
climbEnabled = true -- Climb animation enabled - true/false
climbId = "000000000" -- Climb animation
fallEnabled = true -- Fall animation enabled - true/false
fallId = "000000000" -- Fall animation
toolnoneEnabled = true -- No tool animation enabled - true/false
toolnoneId = "000000000" -- No tool animation

game.Players.PlayerAdded:connect(function(plr)
	while not plr.Character do
		wait()
	end
	local char = plr.Character
	local animations = char.Animate
	if idle1Enabled == true then
		animations.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id="..idleId1
	end
	if idle2Enabled == true then
		animations.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id="..idleId2
	end
	if walkEnabled == true then
		animations.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=04871312239"..walkId
	end
	if runEnabled == true then
		animations.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=4797034721"..runId
	end
	if jumpEnabled == true then
		animations.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id="..jumpId
	end
	if climbEnabled == true then
		animations.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id="..climbId
	end
	if fallEnabled == true then
		animations.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id="..fallId
	end
	if toolnoneEnabled == true then
		animations.toolnone.ToolNoneAnim.AnimationId = "http://www.roblox.com/asset/?id="..toolnoneId
	end
end)