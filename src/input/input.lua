local rl = require("libs.raylib")

---@type table<string, number>
local KEY = {
    -- Alphabet
    W = 87, A = 65, S = 83, D = 68, C = 67, E = 69, F = 70, Q = 81, R = 82, X = 88, Z = 90,
    -- Special
    SPACE = 32, TAB = 258, ESCAPE = 256,
    -- Modifiers
    LEFT_SHIFT = 340, LEFT_CTRL = 341, LEFT_ALT = 342,
    -- Numbers
    NUM_1 = 49, NUM_2 = 50, NUM_3 = 51, NUM_4 = 52, NUM_5 = 53, NUM_6 = 54, NUM_7 = 55, NUM_8 = 56, NUM_9 = 57,
    -- Function keys
    F1 = 290, F2 = 291, F3 = 292, F4 = 293, F5 = 294,
    -- Arrow keys
    UP = 265, DOWN = 264, LEFT = 263, RIGHT = 262
}

---@type table<string, number>
local MOUSE = {
    LEFT = 0,
    RIGHT = 1,
    MIDDLE = 2
}

---@class Input
---@field _actions table<string, {type: string, code: number}>
local Input = {}
Input.__index = Input

---@return Input
function Input.new()
    local self = setmetatable({}, Input)
    self._actions = {}

    -- Set up default action bindings
    self:_setupDefaultActions()

    return self
end

function Input:_setupDefaultActions()
    self:bindAction("MOVE_FORWARD", "key", "W")
    self:bindAction("MOVE_BACK", "key", "S")
    self:bindAction("STRAFE_LEFT", "key", "A")
    self:bindAction("STRAFE_RIGHT", "key", "D")
    self:bindAction("JUMP", "key", "SPACE")
    self:bindAction("SPRINT", "key", "LEFT_SHIFT")
    self:bindAction("FIRE", "mouse", "LEFT")
    self:bindAction("ALT_FIRE", "mouse", "RIGHT")
end

---@param action string
---@param type string "key" or "mouse"
---@param name string key or mouse button name
function Input:bindAction(action, type, name)
    local code
    if type == "key" then
        code = KEY[name]
        if not code then
            print("[Input] Unknown key for action '" .. action .. "': " .. name)
            return
        end
    elseif type == "mouse" then
        code = MOUSE[name]
        if not code then
            print("[Input] Unknown mouse button for action '" .. action .. "': " .. name)
            return
        end
    else
        print("[Input] Unknown action type: " .. type)
        return
    end

    self._actions[action] = { type = type, code = code }
end

---@param action string
---@return boolean
function Input:isActionDown(action)
    local binding = self._actions[action]
    if not binding then
        return false
    end

    if binding.type == "key" then
        return rl.IsKeyDown(binding.code)
    elseif binding.type == "mouse" then
        return rl.IsMouseButtonDown(binding.code)
    end

    return false
end

---@param action string
---@return boolean
function Input:isActionPressed(action)
    local binding = self._actions[action]
    if not binding then
        return false
    end

    if binding.type == "key" then
        return rl.IsKeyPressed(binding.code)
    elseif binding.type == "mouse" then
        return rl.IsMouseButtonPressed(binding.code)
    end

    return false
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

---@param key string
---@return boolean
function Input:isKeyReleased(key)
    local code = KEY[key]
    if not code then
        return false
    end
    return rl.IsKeyReleased(code)
end

---@param button string
---@return boolean
function Input:isMouseButtonDown(button)
    local code = MOUSE[button]
    if not code then
        return false
    end
    return rl.IsMouseButtonDown(code)
end

---@param button string
---@return boolean
function Input:isMouseButtonPressed(button)
    local code = MOUSE[button]
    if not code then
        return false
    end
    return rl.IsMouseButtonPressed(code)
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

---@type table<string, number>
Input.MOUSE = MOUSE

return Input
