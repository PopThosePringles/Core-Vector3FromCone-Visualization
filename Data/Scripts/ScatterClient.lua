local ROOT = script.parent

local RAYS = ROOT:GetCustomProperty("Rays")
local HORIZONTAL_HALF_ANGLE = ROOT:GetCustomProperty("HorizontalHalfAngle") or 60
local VERTICAL_HALF_ANGLE = ROOT:GetCustomProperty("VerticalHalfAngle") or 60
local POWER = ROOT:GetCustomProperty("Power")
local RAY_LENGTH = ROOT:GetCustomProperty("RayLength")
local PAUSE_DELAY = ROOT:GetCustomProperty("PauseDelay")

local SUPPORTED = script:GetCustomProperty("Supported"):WaitForObject()
local NOT_SUPPORTED = script:GetCustomProperty("NotSupported"):WaitForObject()

NOT_SUPPORTED:Destroy()

local meshes = SUPPORTED:FindDescendantsByType("StaticMesh")
local RNG = RandomStream.New()

for _, mesh in ipairs(meshes) do
	mesh.collision = Collision.FORCE_ON
	mesh.cameraCollision = Collision.FORCE_OFF
	mesh.isSimulatingDebrisPhysics = true

	if mesh.isSimulatingDebrisPhysics then
		mesh:SetVelocity(RNG:GetVector3FromCone(Vector3.UP, HORIZONTAL_HALF_ANGLE, VERTICAL_HALF_ANGLE) * POWER)

		Task.Spawn(function()
			mesh.isSimulatingDebrisPhysics = false
		end, PAUSE_DELAY)
	else
		mesh:Destroy()
	end
end

local pos = script:GetWorldPosition()

for i = 1, RAYS do
	local vec1 = RNG:GetVector3FromCone(Vector3.UP, math.min(i, HORIZONTAL_HALF_ANGLE), 1) * RAY_LENGTH
	local vec2 = RNG:GetVector3FromCone(Vector3.UP, math.min(i, 1), VERTICAL_HALF_ANGLE) * RAY_LENGTH

	CoreDebug.DrawLine(pos, pos + vec1, { duration = 60 })
	CoreDebug.DrawLine(pos, pos + vec2, { duration = 60, color = Color.BLUE })
end