local ffi = require("ffi")
local rl = require("libs.raylib")

local Camera = {}
Camera.__index = Camera

function Camera.new(posX, posY, posZ, targetX, targetY, targetZ)
    local self = setmetatable({}, Camera)

    self.data = ffi.new("Camera3D", {
        position = { posX, posY, posZ },
        target = { targetX, targetY, targetZ },
        up = { 0.0, 1.0, 0.0 },
        fovy = 60.0,
        projection = 0
    })

    return self
end

function Camera:begin3D()
    rl.BeginMode3D(self.data)
end

function Camera:end3D()
    rl.EndMode3D()
end

return Camera