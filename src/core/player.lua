local Entity = require("src.core.entity")
local Rigidbody = require("src.physics.rigidbody")

local JUMP_FORCE = 8.0
local EYE_HEIGHT = 1.7
local FOOTSTEP_INTERVAL = 0.45

---@class Player
---@field entity Entity
---@field rb Rigidbody
---@field _footstepTimer number
---@field _wasGrounded boolean
---@field _isMoving boolean
local Player = {}
Player.__index = Player

---@param physics any
---@return Player
function Player.new(physics)
    local self = setmetatable({}, Player)

    self.entity = Entity.new("Player")
    self.entity.transform:setPosition(0, 2, -5)
    self.entity.transform:setScale(0.8, 1.8, 0.8)
    self.entity:addTag("player")

    self.rb = Rigidbody.new({ mass = 80.0, useGravity = true })
    self.entity:addComponent("rigidbody", self.rb)
    physics:register(self.rb)

    self._footstepTimer = 0
    self._wasGrounded = false
    self._isMoving = false

    return self
end

---@param input any
---@param camera any
---@param dt number
function Player:update(input, camera, dt)
    local rb = self.rb
    local t = self.entity.transform

    local speed = 8.0
    local yawRad = math.rad(camera.yaw)

    rb.velocity.x = 0.0
    rb.velocity.z = 0.0

    self._isMoving = false

    if input:isActionDown("MOVE_FORWARD") then
        rb.velocity.x = rb.velocity.x + math.sin(yawRad) * speed
        rb.velocity.z = rb.velocity.z + math.cos(yawRad) * speed
        self._isMoving = true
    end

    if input:isActionDown("MOVE_BACK") then
        rb.velocity.x = rb.velocity.x - math.sin(yawRad) * speed
        rb.velocity.z = rb.velocity.z - math.cos(yawRad) * speed
        self._isMoving = true
    end

    if input:isActionDown("STRAFE_LEFT") then
        rb.velocity.x = rb.velocity.x + math.cos(yawRad) * speed
        rb.velocity.z = rb.velocity.z - math.sin(yawRad) * speed
        self._isMoving = true
    end

    if input:isActionDown("STRAFE_RIGHT") then
        rb.velocity.x = rb.velocity.x - math.cos(yawRad) * speed
        rb.velocity.z = rb.velocity.z + math.sin(yawRad) * speed
        self._isMoving = true
    end

    if input:isActionPressed("JUMP") and rb.isGrounded then
        rb.velocity.y = JUMP_FORCE
        rb.isGrounded = false
    end

    if rb.isGrounded and self._isMoving then
        self._footstepTimer = self._footstepTimer + dt
        if self._footstepTimer >= FOOTSTEP_INTERVAL then
            self._footstepTimer = self._footstepTimer - FOOTSTEP_INTERVAL
        end
    else
        self._footstepTimer = 0
    end

    self._wasGrounded = rb.isGrounded

    camera.x = t.position.x
    camera.y = t.position.y + EYE_HEIGHT
    camera.z = t.position.z
end

return Player
