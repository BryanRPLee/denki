local Vec3 = require("src.core.vec3")

local Transform = {}
Transform.__index = Transform

function Transform.new(x, y, z)
    local self = setmetatable({}, Transform)

    self.position = Vec3.new(x or 0, y or 0, z or 0)
    self.rotation = Vec3.zero()
    self.scale = Vec3.one()

    return self
end

function Transform:setPosition(x, y, z)
    self.position = Vec3.new(x, y, z)
end

function Transform:setRotation(x, y, z)
    self.rotation = Vec3.new(x, y, z)
end

function Transform:setScale(x, y, z)
    self.scale = Vec3.new(x, y, z)
end

function Transform:translate(dx, dy, dz)
    self.position = self.position + Vec3.new(dx, dy, dz)
end

return Transform
