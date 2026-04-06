local Vec3 = require("src.core.vec3")

local AABB = {}
AABB.__index = AABB

function AABB.new(min, max)
    local self = setmetatable({}, AABB)

    self.min = min or Vec3.zero()
    self.max = max or Vec3.one()

    return self
end

function AABB.fromTransform(transform)
    local p = transform.position
    local hs = transform.scale * .5

    return AABB.new(
        Vec3.new(p.x - hs.x, p.y - hs.y, p.z - hs.z),
        Vec3.new(p.x + hs.x, p.y + hs.y, p.z + hs.z)
    )
end

function AABB:intersects(other)
    return self.min.x <= other.max.x and self.max.x >= other.min.x
        and self.min.y <= other.max.y and self.max.y >= other.min.y
        and self.min.z <= other.max.z and self.max.z >= other.min.z
end

function AABB:penetration(other)
    local ox = math.min(self.max.x, other.max.x) - math.max(self.min.x, other.min.x)
    local oy = math.min(self.max.y, other.max.y) - math.max(self.min.y, other.min.y)
    local oz = math.min(self.max.z, other.max.z) - math.max(self.min.z, other.min.z)
    return Vec3.new(ox, oy, oz)
end

function AABB:center()
    return Vec3.new(
        (self.min.x + self.max.x) * 0.5,
        (self.min.y + self.max.y) * 0.5,
        (self.min.z + self.max.z) * 0.5
    )
end

function AABB:__tostring()
    return string.format("AABB(min=%s, max=%s)", tostring(self.min), tostring(self.max))
end

return AABB
