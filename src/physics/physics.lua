---@class Physics
---@field bodies any[]
local Physics = {}
Physics.__index = Physics

local FLOOR_Y = 0.0

---@return Physics
function Physics.new()
    local self = setmetatable({}, Physics)
    self.bodies = {}
    return self
end

---@param rigidbody any
function Physics:register(rigidbody)
    table.insert(self.bodies, rigidbody)
end

---@param rigidbody any
function Physics:unregister(rigidbody)
    for i, rb in ipairs(self.bodies) do
        if rb == rigidbody then
            table.remove(self.bodies, i)
            return
        end
    end
end

---@param dt number
function Physics:update(dt)
    for _, rb in ipairs(self.bodies) do
        rb:update(dt)
    end

    for _, rb in ipairs(self.bodies) do
        self:_resolveFloor(rb)
    end

    for i = 1, #self.bodies do
        for j = i + 1, #self.bodies do
            self:_resolveCollision(self.bodies[i], self.bodies[j])
        end
    end
end

---@param rbA any
---@param rbB any
function Physics:_resolveCollision(rbA, rbB)
    local aabbA = rbA:getAABB()
    local aabbB = rbB:getAABB()

    if not aabbA:intersects(aabbB) then
        return
    end

    local pen = aabbA:penetration(aabbB)

    local tA = rbA.entity.transform
    local tB = rbB.entity.transform

    if pen.x < pen.y and pen.x < pen.z then
        local dir = tA.position.x < tB.position.x and -1 or 1

        if not rbA.isStatic then
            tA.position.x = tA.position.x + dir * pen.x * 0.5
        end

        if not rbB.isStatic then
            tB.position.x = tB.position.x - dir * pen.x * 0.5
        end

        if not rbA.isStatic then
            rbA.velocity.x = -rbA.velocity.x * rbA.restitution
        end

        if not rbB.isStatic then
            rbB.velocity.x = -rbB.velocity.x * rbB.restitution
        end
    elseif pen.y < pen.x and pen.y < pen.z then
        local dir = tA.position.y < tB.position.y and -1 or 1

        if not rbA.isStatic then
            tA.position.y = tA.position.y + dir * pen.y * 0.5
            if dir == 1 then
                rbA.isGrounded = true
            end
        end

        if not rbB.isStatic then
            tB.position.y = tB.position.y - dir * pen.y * 0.5
            if dir == -1 then
                rbB.isGrounded = true
            end
        end

        if not rbA.isStatic then
            rbA.velocity.y = -rbA.velocity.y * rbA.restitution
        end

        if not rbB.isStatic then
            rbB.velocity.y = -rbB.velocity.y * rbB.restitution
        end
    else
        local dir = tA.position.z < tB.position.z and -1 or 1

        if not rbA.isStatic then
            tA.position.z = tA.position.z + dir * pen.z * 0.5
        end

        if not rbB.isStatic then
            tB.position.z = tB.position.z - dir * pen.z * 0.5
        end

        if not rbA.isStatic then
            rbA.velocity.z = -rbA.velocity.z * rbA.restitution
        end

        if not rbB.isStatic then
            rbB.velocity.z = -rbB.velocity.z * rbB.restitution
        end
    end
end

---@param rb any
function Physics:_resolveFloor(rb)
    if rb.isStatic then
        return
    end

    local t = rb.entity.transform
    local halfY = t.scale.y * 0.5
    local bottom = t.position.y - halfY

    if bottom <= FLOOR_Y then
        t.position.y  = FLOOR_Y + halfY
        rb.velocity.y = 0.0
        rb.isGrounded = true
    else
        rb.isGrounded = false
    end
end

return Physics
