---@class SoundComponent
---@field entity any
---@field _audio any
---@field _id string
local SoundComponent = {}
SoundComponent.__index = SoundComponent

---@param audio any
---@param id string
---@param path string
---@return SoundComponent
function SoundComponent.new(audio, id, path)
    local self = setmetatable({}, SoundComponent)

    self._audio = audio
    self._id = id
    self.entity = nil

    audio:load(id, path)

    return self
end

function SoundComponent:play()
    self._audio:play(self._id)
end

function SoundComponent:stop()
    self._audio:stop(self._id)
end

---@param volume number
function SoundComponent:setVolume(volume)
    self._audio:setVolume(self._id, volume)
end

---@param looping boolean
function SoundComponent:setLooping(looping)
    self._audio:setLooping(self._id, looping)
end

---@return boolean
function SoundComponent:isPlaying()
    return self._audio:isPlaying(self._id)
end

return SoundComponent
