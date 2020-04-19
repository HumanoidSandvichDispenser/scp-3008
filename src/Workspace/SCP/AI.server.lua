local PathfindingService = game:GetService("PathfindingService")

local Zombie = script.Parent
local Humanoid = Zombie.Humanoid
local Destination
local Waypoints
local voice = math.random (1,3)

local Path = PathfindingService:CreatePath(
	{
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true
	}
)

local Attacking = false

function SearchForPlayers()
	local minDistance = 512
	local closestPlayer
	for i, v in pairs(game:GetService("Players"):GetChildren()) do
		if v.Character and v.Character.Humanoid.Health > 0 then
			local currentDistance = (Zombie.Head.Position - v.Character.Head.Position).Magnitude
			if currentDistance <= minDistance then
				minDistance = currentDistance
				closestPlayer = v.Character
			end
		end
	end
	return closestPlayer
end

function Chase()
	Destination = SearchForPlayers()
	
	if Destination then
		Humanoid.WalkSpeed = 30
		
		local lastDestinationPosition = Destination.Head.Position
		Path:ComputeAsync(Zombie.Head.Position, Destination.Head.Position)
		local waypoints = Path:GetWaypoints()
		
		if #waypoints > 0 then
			for _, waypoint in pairs(waypoints) do
				local random = Random.new()
				
				Humanoid:MoveTo(waypoint.Position)
				Humanoid.MoveToFinished:Wait(10)
				if waypoint.Action == Enum.PathWaypointAction.Jump then
					Humanoid.Jump = true
				end
				
				if random:NextInteger(1, 80) == 5 then
					script.Parent.Sound:Play()
				end
				
				if (lastDestinationPosition - Destination.Head.Position).Magnitude > 12 or SearchForPlayers() ~= Destination then
					break -- Recalculate if destination has moved far or there is another nearer target
				end
			end
		else
			Humanoid:MoveTo(Destination.Head.Position)
			wait(2)
		end
	else
		Humanoid.WalkSpeed = 12
		
		wait(2)
	end
end
 
while true do
	Chase()
end
