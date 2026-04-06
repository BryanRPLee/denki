local Vec3 = require("src.core.vec3")
local AABB = require("src.physics.aabb")

local Rigidbody = {}
Rigidbody.__index = Rigidbody

local GRAVITY = -20.0

function Rigidbody.new(options)
    local self = setmetatable({}, Rigidbody)

    options = options or {}
    self.entity = nil
    self.velocity = Vec3.zero()
    self.mass = options.mass or 1.0
    self.useGravity = options.useGravity ~= false
    self.isStatic = options.isStatic or false
    self.isGrounded = false
    self.restitution = options.restitution or 0.0

    return self
end

function Rigidbody:getAABB()
    return AABB.fromTransform(self.entity.transform)
end

function Rigidbody:applyForce(x, y, z)
    if self.isStatic then
        return
    end
    self.velocity.x = self.velocity.x + (x / self.mass)
    self.velocity.y = self.velocity.y + (y / self.mass)
    self.velocity.z = self.velocity.z + (z / self.mass)
end

function Rigidbody:update(dt)
    if self.isStatic then
        return
    end

    if self.useGravity and not self.isGrounded then
        self.velocity.y = self.velocity.y + GRAVITY * dt
    end

    local t = self.entity.transform
    t.position.x = t.position.x + self.velocity.x * dt
    t.position.y = t.position.y + self.velocity.y * dt
    t.position.z = t.position.z + self.velocity.z * dt
end

return Rigidbody
