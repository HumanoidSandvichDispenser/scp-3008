-- Latest update 24 November 2019 - Upgrade to redux.

local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local ClientToolInput = game:GetService("ReplicatedStorage"):WaitForChild("ClientToolInput")
local FirePointObject = Handle:WaitForChild("GunFirePoint")
local FastCast = require(game:GetService("ServerScriptService").FastCastRedux)
local FireSound = Handle:WaitForChild("Fire")
local ImpactParticle = Handle:WaitForChild("ImpactParticle")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- REMEMBER: THERE'S RESOURCES TO HELP YOU AT https://github.com/XanTheDragon/FastCastAPIDocs/wiki/API
local RNG = Random.new()							-- Set up a randomizer.
local DEBUG_VISUALIZE = false						-- If true, individual sub-rays will be shown with black cones.
local BULLET_SPEED = 500							-- Studs/second - the speed of the bullet
local BULLET_MAXDIST = 1000							-- The furthest distance the bullet can travel 
local BULLET_GRAVITY = Vector3.new(0, 0, 0)		-- The amount of gravity applied to the bullet in world space (so yes, you can have sideways gravity)
local MIN_BULLET_SPREAD_ANGLE = 0					-- THIS VALUE IS VERY SENSITIVE. Try to keep changes to it small. The least accurate the bullet can be. This angle value is in degrees. A value of 0 means straight forward. Generally you want to keep this at 0 so there's at least some chance of a 100% accurate shot.
local MAX_BULLET_SPREAD_ANGLE = 0.5					-- THIS VALUE IS VERY SENSITIVE. Try to keep changes to it small. The most accurate the bullet can be. This angle value is in degrees. A value of 0 means straight forward. This cannot be less than the value above. A value of 90 will allow the gun to shoot sideways at most, and a value of 180 will allow the gun to shoot backwards at most. Exceeding 180 will not add any more angular varience.
local FIRE_DELAY = 0.1								-- The amount of time that must pass after firing the gun before we can fire again.
local TAU = math.pi * 2							-- Set up mathematical constant Tau (pi * 2)
local PIERCE_DEMO = true							-- True if the pierce demo should be used. See the CanRayPierce function for more info.

local CanFire = true								-- Used for a cooldown.

-- Now we set the caster values.
local Caster = FastCast.new() --Create a new caster object.

-- Make a base cosmetic bullet object. This will be cloned every time we fire off a ray.
local CosmeticBullet = Instance.new("Part")
CosmeticBullet.Material = Enum.Material.Neon
CosmeticBullet.Color = Color3.fromRGB(0, 196, 255)
CosmeticBullet.CanCollide = false
CosmeticBullet.Anchored = true
CosmeticBullet.Size = Vector3.new(0.4, 0.4, 2.4)

-- Bonus points: If you're going to be slinging a ton of bullets in a short period of time, you may see it fit to use PartCache.
-- https://devforum.roblox.com/t/partcache-for-all-your-quick-part-creation-needs/246641 

-- And a function to play fire sounds.
function PlayFireSound()
	local NewSound = FireSound:Clone()
	NewSound.Parent = Handle
	NewSound:Play()
	Debris:AddItem(NewSound, NewSound.TimeLength)
end

function VisualizeSegment(castStartCFrame, castLength)
	local adornment = Instance.new("ConeHandleAdornment")
	adornment.Adornee = workspace.Terrain
	adornment.CFrame = castStartCFrame
	adornment.Height = castLength
	adornment.Color3 = Color3.new()
	adornment.Radius = 0.25
	adornment.Transparency = 0.5
	adornment.Parent = workspace.Terrain
end

-- Create the spark effect for the bullet impact
function MakeParticleFX(position, normal)
	-- This is a trick I do with attachments all the time.
	-- Parent attachments to the Terrain - It counts as a part, and setting position/rotation/etc. of it will be in world space.
	-- UPD 11 JUNE 2019 - Attachments now have a "WorldPosition" value, but despite this, I still see it fit to parent attachments to terrain since its position never changes.
	local attachment = Instance.new("Attachment")
	attachment.CFrame = CFrame.new(position, position + normal)
	attachment.Parent = workspace.Terrain
	local particle = ImpactParticle:Clone()
	particle.Parent = attachment
	Debris:AddItem(attachment, particle.Lifetime.Max) -- Automatically delete the particle effect after its maximum lifetime.
	
	-- A potentially better option in favor of this would be to use the Emit method (Particle:Emit(numParticles)) though I prefer this since it adds some natural spacing between the particles.
	particle.Enabled = true
	wait(0.05)
	particle.Enabled = false
end
	
function CanRayPierce(hitPart, hitPoint, normal, material)
	-- This function shows off the piercing feature. Pass this function as the last argument (after bulletAcceleration) and it will run this every time the ray runs into an object.
	if material == Enum.Material.Plastic or material == Enum.Material.Ice or material == Enum.Material.Glass or material == Enum.Material.SmoothPlastic then
		-- Hit glass, plastic, or ice...
		if hitPart.Transparency >= 0.5 then
			-- And it's >= half transparent...
			return true -- Yes! We can pierce.
		end
	end
	return false -- No, we can't pierce.
end

function Fire(direction)
	-- Called when we want to fire the gun.
	if Tool.Parent:IsA("Backpack") then return end -- Can't fire if it's not equipped.
	-- Note: Above isn't in the event as it will prevent the CanFire value from being set as needed.
	
	-- UPD. 11 JUNE 2019 - Add support for random angles.
	local directionalCF = CFrame.new(Vector3.new(), direction)
	-- Now, we can use CFrame orientation to our advantage.
	-- Overwrite the existing Direction value.
	local direction = (directionalCF * CFrame.fromOrientation(0, 0, RNG:NextNumber(0, TAU)) * CFrame.fromOrientation(math.rad(RNG:NextNumber(MIN_BULLET_SPREAD_ANGLE, MAX_BULLET_SPREAD_ANGLE)), 0, 0)).LookVector
	
	-- UPDATE V6: Proper bullet velocity!
	-- IF YOU DON'T WANT YOUR BULLETS MOVING WITH YOUR CHARACTER, REMOVE THE THREE LINES OF CODE BELOW THIS COMMENT.
	-- Requested by https://www.roblox.com/users/898618/profile/
	-- We need to make sure the bullet inherits the velocity of the gun as it fires, just like in real life.
	local humanoidRootPart = Tool.Parent:WaitForChild("HumanoidRootPart", 1)	-- Add a timeout to this.
	local myMovementSpeed = humanoidRootPart.Velocity							-- To do: It may be better to get this value on the clientside since the server will see this value differently due to ping and such.
	local modifiedBulletSpeed = (direction * BULLET_SPEED) + myMovementSpeed	-- We multiply our direction unit by the bullet speed. This creates a Vector3 version of the bullet's velocity at the given speed. We then add MyMovementSpeed to add our body's motion to the velocity.
	
	-- Prepare a new cosmetic bullet
	local bullet = CosmeticBullet:Clone()
	bullet.CFrame = CFrame.new(FirePointObject.WorldPosition, FirePointObject.WorldPosition + direction)
	bullet.Parent = workspace
	
	-- NOTE: It may be a good idea to make a Folder in your workspace named "CosmeticBullets" (or something of that nature) and use FireWithBlacklist on the descendants of this folder!
	-- Quickly firing bullets in rapid succession can cause the caster to hit other casts' bullets from the same gun (The caster only ignores the bullet of that specific shot, not other bullets).
	-- Do note that if you do this, you will need to remove the Equipped connection that sets IgnoreDescendantsInstance, as this property is not used with FireWithBlacklist
	
	-- Fire the caster
	if PIERCE_DEMO then
		Caster:Fire(humanoidRootPart.Position, direction * BULLET_MAXDIST, modifiedBulletSpeed, bullet, Tool.Parent, false, BULLET_GRAVITY, CanRayPierce)
	else
		Caster:Fire(FirePointObject.WorldPosition, direction * BULLET_MAXDIST, modifiedBulletSpeed, bullet, Tool.Parent, false, BULLET_GRAVITY)
	end
	
	-- Play the sound
	PlayFireSound()
end

function OnRayHit(hitPart, hitPoint, normal, material, cosmeticBulletObject)
	-- This function will be connected to the Caster's "RayHit" event.
	cosmeticBulletObject:Destroy() -- Destroy the cosmetic bullet.
	if hitPart and hitPart.Parent then -- Test if we hit something
		local humanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid") -- Is there a humanoid?
		if humanoid then
			humanoid:TakeDamage(10) -- Damage.
		end
		MakeParticleFX(hitPoint, normal) -- Particle FX
	end
end

function OnRayUpdated(castOrigin, segmentOrigin, segmentDirection, length, cosmeticBulletObject)
	-- Whenever the caster steps forward by one unit, this function is called.
	-- The bullet argument is the same object passed into the fire function.
	local bulletLength = cosmeticBulletObject.Size.Z / 2 -- This is used to move the bullet to the right spot based on a CFrame offset
	local baseCFrame = CFrame.new(segmentOrigin, segmentOrigin + segmentDirection)
	cosmeticBulletObject.CFrame = baseCFrame * CFrame.new(0, 0, -(length - bulletLength))
	
	if DEBUG_VISUALIZE then VisualizeSegment(baseCFrame, length) end
end
	
-- Before I make the connections, I will check for proper values. In production scripts that you are writing that you know you will write properly, you should not do this.
-- This is included exclusively as a result of this being an example script, and users may tweak the values incorrectly.
assert(MAX_BULLET_SPREAD_ANGLE >= MIN_BULLET_SPREAD_ANGLE, "Error: MAX_BULLET_SPREAD_ANGLE cannot be less than MIN_BULLET_SPREAD_ANGLE!")
if (MAX_BULLET_SPREAD_ANGLE > 180) then
	warn("Warning: MAX_BULLET_SPREAD_ANGLE is over 180! This will not pose any extra angular randomization. The value has been changed to 180 as a result of this.")
	MAX_BULLET_SPREAD_ANGLE = 180
end

ClientToolInput.OnServerEvent:Connect(function(player, input, tool, origin, direction)
	if input == "MouseButton1Down" then
		print("Fired")
		
		if not CanFire or tool ~= Tool then
			return
		end
		
		CanFire = false
		Fire(direction)
		wait(FIRE_DELAY)
		CanFire = true
	end
end)

Caster.LengthChanged:Connect(OnRayUpdated)
Caster.RayHit:Connect(OnRayHit)