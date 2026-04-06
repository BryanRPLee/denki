local ffi = require("ffi")
local rl = require("libs.raylib")

---@param degrees number
---@return number
local function toRad(degrees)
    return degrees * (math.pi / 180.0)
end

---@class Camera
---@field x number
---@field y number
---@field z number
---@field yaw number
---@field pitch number
---@field moveSpeed number
---@field mouseSens number
---@field data any
local Camera = {}
Camera.__index = Camera

---@param posX? number
---@param posY? number
---@param posZ? number
---@return Camera
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

---@param input any
---@param dt number
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
