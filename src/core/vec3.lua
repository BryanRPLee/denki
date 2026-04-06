local Vec3 = {}
Vec3.__index = Vec3

function Vec3.new(x, y, z)
    return setmetatable({ x = x or 0.0, y = y or 0.0, z = z or 0.0 }, Vec3)
end

function Vec3.zero()
    return Vec3.new(0, 0, 0)
end

function Vec3.one()
    return Vec3.new(1, 1, 1)
end

function Vec3.up()
    return Vec3.new(0, 1, 0)
end

function Vec3.forward()
    return Vec3.new(0, 0, 1)
end

function Vec3:clone()
    return Vec3.new(self.x, self.y, self.z)
end

function Vec3:length()
    return math.sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
end

function Vec3:normalize()
    local len = self:length()
    if len == 0 then
        return Vec3.new(0, 0, 0)
    end
    return Vec3.new(self.x / len, self.y / len, self.z / len)
end

function Vec3:dot(other)
    return self.x * other.x + self.y * other.y + self.z * other.z
end

function Vec3:cross(other)
    return Vec3.new(
        self.y * other.z - self.z * other.y,
        self.z * other.x - self.x * other.z,
        self.x * other.y - self.y * other.x
    )
end

function Vec3:toFFI()
    local ffi = require("ffi")
    return ffi.new("Vector3", { self.x, self.y, self.z })
end

function Vec3.__add(a, b)
    return Vec3.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

function Vec3.__sub(a, b)
    return Vec3.new(a.x - b.x, a.y - b.y, a.z - b.z)
end

function Vec3.__mul(a, b)
    if type(b) == "number" then
        return Vec3.new(a.x * b, a.y * b, a.z * b)
    elseif type(a) == "number" then
        return Vec3.new(b.x * a, b.y * a, b.z * a)
    end
    return Vec3.new(a.x * b.x, a.y * b.y, a.z * b.z)
end

function Vec3.__eq(a, b)
    return a.x == b.x and a.y == b.y and a.z == b.z
end

function Vec3.__tostring(v)
    return string.format("Vec3(%.2f, %.2f, %.2f)", v.x, v.y, v.z)
end

return Vec3
