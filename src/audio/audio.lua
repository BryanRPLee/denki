local rl = require("libs.raylib")

---@class Audio
---@field _sounds table<string, any>
---@field _initialized boolean
local Audio = {}
Audio.__index = Audio

---@return Audio
function Audio.new()
    local self = setmetatable({}, Audio)

    self._sounds = {}
    self._initialized = false

    -- Initialize audio device
    rl.InitAudioDevice()

    if rl.IsAudioDeviceReady() then
        self._initialized = true
        print("[Audio] Device initialized")
    else
        print("[Audio] Failed to initialize audio device")
    end

    return self
end

---@param id string
---@param path string
---@return boolean success
function Audio:load(id, path)
    if not self._initialized then
        return false
    end

    if self._sounds[id] then
        print("[Audio] Sound already loaded: " .. id)
        return true
    end

    local sound = rl.LoadSound(path)
    if not sound then
        print("[Audio] Failed to load sound '" .. id .. "' from '" .. path .. "'")
        return false
    end

    self._sounds[id] = sound
    print("[Audio] Loaded sound: " .. id .. " from " .. path)
    return true
end

---@param id string
function Audio:play(id)
    if not self._initialized then
        return
    end

    local sound = self._sounds[id]
    if not sound then
        print("[Audio] Sound not found: " .. id)
        return
    end

    rl.PlaySound(sound)
end

---@param id string
function Audio:stop(id)
    if not self._initialized then
        return
    end

    local sound = self._sounds[id]
    if not sound then
        return
    end

    rl.StopSound(sound)
end

---@param id string
---@param volume number 0-1
function Audio:setVolume(id, volume)
    if not self._initialized then
        return
    end

    local sound = self._sounds[id]
    if not sound then
        return
    end

    rl.SetSoundVolume(sound, volume)
end

---@param id string
---@return boolean
function Audio:isPlaying(id)
    if not self._initialized then
        return false
    end

    local sound = self._sounds[id]
    if not sound then
        return false
    end

    return rl.IsSoundPlaying(sound)
end

function Audio:shutdown()
    for _, sound in pairs(self._sounds) do
        rl.UnloadSound(sound)
    end
    self._sounds = {}

    if self._initialized then
        rl.CloseAudioDevice()
        print("[Audio] Device closed")
    end
end

return Audio
