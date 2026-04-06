local ffi = require("ffi")
local ma = require("libs.miniaudio")

---@class Audio
---@field _engine any
---@field _sounds table<string, any>
local Audio = {}
Audio.__index = Audio

---@return Audio
function Audio.new()
    local self = setmetatable({}, Audio)

    self._sounds = {}

    -- Allocate engine structure
    local engine = ffi.new("ma_engine[1]")
    local result = ma.ma_engine_init(nil, engine)

    if result ~= ma.MA_SUCCESS then
        print("[Audio] Failed to initialize engine (code " .. result .. ")")
        return self
    end

    self._engine = engine
    print("[Audio] Engine initialized")
    return self
end

---@param id string
---@param path string
---@return boolean success
function Audio:load(id, path)
    if self._sounds[id] then
        print("[Audio] Sound already loaded: " .. id)
        return true
    end

    -- Allocate sound and keep reference
    local sound = ffi.new("ma_sound")
    local result = ma.ma_sound_init_from_file(self._engine, path, 0, nil, nil, sound)

    if result ~= ma.MA_SUCCESS then
        print("[Audio] Failed to load sound '" .. id .. "' from '" .. path .. "' (code " .. result .. ")")
        return false
    end

    -- Store in table to keep alive
    self._sounds[id] = {
        sound = sound,
        id = id
    }
    print("[Audio] Loaded sound: " .. id .. " from " .. path)
    return true
end

---@param id string
function Audio:play(id)
    local entry = self._sounds[id]
    if not entry then
        print("[Audio] Sound not found: " .. id)
        return
    end

    local sound = entry.sound
    ma.ma_sound_seek_to_pcm_frame(sound, 0)
    ma.ma_sound_start(sound)
end

---@param id string
function Audio:stop(id)
    local entry = self._sounds[id]
    if not entry then
        return
    end

    ma.ma_sound_stop(entry.sound)
end

---@param id string
---@param volume number 0-1
function Audio:setVolume(id, volume)
    local entry = self._sounds[id]
    if not entry then
        return
    end

    ma.ma_sound_set_volume(entry.sound, volume)
end

---@param id string
---@param looping boolean
function Audio:setLooping(id, looping)
    local entry = self._sounds[id]
    if not entry then
        return
    end

    ma.ma_sound_set_looping(entry.sound, looping and 1 or 0)
end

---@param id string
---@return boolean
function Audio:isPlaying(id)
    local entry = self._sounds[id]
    if not entry then
        return false
    end

    return ma.ma_sound_is_playing(entry.sound) ~= 0
end

function Audio:shutdown()
    for _, entry in pairs(self._sounds) do
        ma.ma_sound_uninit(entry.sound)
    end
    self._sounds = {}

    ma.ma_engine_uninit(self._engine)
    print("[Audio] Engine shut down")
end

return Audio
