local maxX = 500
local minX = -500
local maxZ = 500
local minZ = -500
local y = 200

math.randomseed(tick())
while wait(.5) do
	local x = math.random(minX,maxX)
	local z = math.random(minZ,maxZ)
	script.Parent.CFrame = CFrame.new(x,y,z)
end

