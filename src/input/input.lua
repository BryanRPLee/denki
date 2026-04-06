local rl = require("libs.raylib")

---@type table<string, number>
local KEY = {
    W = 87,
    A = 65,
    S = 83,
    D = 68,
    SPACE = 32,
    LEFT_SHIFT = 340,
    ESCAPE = 256
}

---@class Input
local Input = {}
Input.__index = Input

---@return Input
function Input.new()
    local self = setmetatable({}, Input)
    return self
end

---@param key string
---@return boolean
function Input:isKeyDown(key)
    local code = KEY[key]
    if not code then
        print("[Input] Unknown key: " .. tostring(key))
        return false
    end
    return rl.IsKeyDown(code)
end

---@param key string
---@return boolean
function Input:isKeyPressed(key)
    local code = KEY[key]
    if not code then
        return false
    end
    return rl.IsKeyPressed(code)
end

---@return number, number
function Input:getMouseDelta()
    local delta = rl.GetMouseDelta()
    return delta.x, delta.y
end

function Input:enableCursor()
    rl.EnableCursor()
end

function Input:disableCursor()
    rl.DisableCursor()
end

---@type table<string, number>
Input.KEY = KEY

return Input
