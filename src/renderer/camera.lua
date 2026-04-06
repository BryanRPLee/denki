local ffi = require("ffi")
local rl = require("libs.raylib")

local function toRad(degrees)
    return degrees * (math.pi / 180.0)
end

local Camera = {}
Camera.__index = Camera

function Camera.new(posX, posY, posZ)
    local self = setmetatable({}, Camera)

    self.x = posX or 0.0
    self.y = posY or 2.0
    self.z = posZ or 0.0

    self.yaw = 0.0
    self.pitch = 0.0

    self.moveSpeed = 10.0
    self.mouseSens = 0.1

    self.data = ffi.new("Camera3D")
    self.data.up = ffi.new("Vector3", { 0.0, 1.0, 0.0 })
    self.data.fovy = 60.0
    self.data.projection = 0

    self:_updateData()

    return self
end

function Camera:update(input, dt)
    local dx, dy = input:getMouseDelta()

    self.yaw = self.yaw - dx * self.mouseSens
    self.pitch = self.pitch - dy * self.mouseSens

    if self.pitch > 89.0 then
        self.pitch = 89.0
    end

    if self.pitch < -89.0 then
        self.pitch = -89.0
    end

    local yawRad = toRad(self.yaw)
    local speed = self.moveSpeed * dt

    if input:isKeyDown("W") then
        self.x = self.x + math.sin(yawRad) * speed
        self.z = self.z + math.cos(yawRad) * speed
    end

    if input:isKeyDown("S") then
        self.x = self.x - math.sin(yawRad) * speed
        self.z = self.z - math.cos(yawRad) * speed
    end

    if input:isKeyDown("A") then
        self.x = self.x + math.cos(yawRad) * speed
        self.z = self.z - math.sin(yawRad) * speed
    end

    if input:isKeyDown("D") then
        self.x = self.x - math.cos(yawRad) * speed
        self.z = self.z + math.sin(yawRad) * speed
    end

    if input:isKeyDown("SPACE") then
        self.y = self.y + speed
    end

    if input:isKeyDown("LEFT_SHIFT") then
        self.y = self.y - speed
    end

    self:_updateData()
end

function Camera:_updateData()
    self.data.position = ffi.new("Vector3", { self.x, self.y, self.z })

    local yawRad = toRad(self.yaw)
    local pitchRad = toRad(self.pitch)

    local fx = math.cos(pitchRad) * math.sin(yawRad)
    local fy = math.sin(pitchRad)
    local fz = math.cos(pitchRad) * math.cos(yawRad)

    self.data.target = ffi.new("Vector3", {
        self.x + fx,
        self.y + fy,
        self.z + fz
    })
end

function Camera:begin3D()
    rl.BeginMode3D(self.data)
end

function Camera:end3D()
    rl.EndMode3D()
end

return Camera
