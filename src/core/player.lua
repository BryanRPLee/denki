local Entity = require("src.core.entity")
local Rigidbody = require("src.physics.rigidbody")
local Vec3 = require("src.core.vec3")

local JUMP_FORCE = 8.0
local EYE_HEIGHT = 1.7

local Player = {}
Player.__index = Player

function Player.new(physics)
    local self = setmetatable({}, Player)

    self.entity = Entity.new("Player")
    self.entity.transform:setPosition(0, 2, -5)
    self.entity.transform:setScale(0.8, 1.8, 0.8)
    self.entity:addTag("player")

    self.rb = Rigidbody.new({ mass = 80.0, useGravity = true })
    self.entity:addComponent("rigidbody", self.rb)
    physics:register(self.rb)

    return self
end

function Player:update(input, camera, dt)
    local rb = self.rb
    local t = self.entity.transform

    local speed = 8.0
    local yawRad = math.rad(camera.yaw)

    rb.velocity.x = 0.0
    rb.velocity.z = 0.0

    if input:isKeyDown("W") then
        rb.velocity.x = rb.velocity.x + math.sin(yawRad) * speed
        rb.velocity.z = rb.velocity.z + math.cos(yawRad) * speed
    end

    if input:isKeyDown("S") then
        rb.velocity.x = rb.velocity.x - math.sin(yawRad) * speed
        rb.velocity.z = rb.velocity.z - math.cos(yawRad) * speed
    end

    if input:isKeyDown("A") then
        rb.velocity.x = rb.velocity.x + math.cos(yawRad) * speed
        rb.velocity.z = rb.velocity.z - math.sin(yawRad) * speed
    end

    if input:isKeyDown("D") then
        rb.velocity.x = rb.velocity.x - math.cos(yawRad) * speed
        rb.velocity.z = rb.velocity.z + math.sin(yawRad) * speed
    end

    if input:isKeyPressed("SPACE") and rb.isGrounded then
        rb.velocity.y = JUMP_FORCE
        rb.isGrounded = false
    end

    camera.x = t.position.x
    camera.y = t.position.y + EYE_HEIGHT
    camera.z = t.position.z
end

return Player
