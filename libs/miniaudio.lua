local ffi = require("ffi")

local scriptDir = debug.getinfo(1, "S").source:match("@(.+)/[^/]+$")
local ma = ffi.load(scriptDir .. "/libminiaudio.dylib")

ffi.cdef [[
    typedef int ma_result;
    static const int MA_SUCCESS = 0;

    typedef struct ma_engine ma_engine;
    typedef struct ma_sound  ma_sound;

    struct ma_engine { char _opaque[1024]; };
    struct ma_sound { char _opaque[512];  };

    ma_result ma_engine_init(void* pConfig, ma_engine* pEngine);
    void ma_engine_uninit(ma_engine* pEngine);

    ma_result ma_engine_play_sound(ma_engine* pEngine, const char* pFilePath, void* pGroup);
    ma_result ma_sound_init_from_file(ma_engine* pEngine, const char* pFilePath, unsigned int flags, void* pGroup, void* pFence, ma_sound* pSound);
    void ma_sound_uninit(ma_sound* pSound);
    ma_result ma_sound_start(ma_sound* pSound);
    ma_result ma_sound_stop(ma_sound* pSound);
    void ma_sound_set_volume(ma_sound* pSound, float volume);
    void ma_sound_set_looping(ma_sound* pSound, int isLooping);
    int ma_sound_is_playing(ma_sound* pSound);
    int ma_sound_at_end(ma_sound* pSound);
    ma_result ma_sound_seek_to_pcm_frame(ma_sound* pSound, unsigned long long frameIndex);
]]

---@class ma_engine

---@class ma_sound

---@class Miniaudio
---@field MA_SUCCESS integer
---@field ma_engine_init fun(pConfig: any, pEngine: ma_engine): integer
---@field ma_engine_uninit fun(pEngine: ma_engine)
---@field ma_engine_play_sound fun(pEngine: ma_engine, pFilePath: string, pGroup: any): integer
---@field ma_sound_init_from_file fun(pEngine: ma_engine, pFilePath: string, flags: integer, pGroup: any, pFence: any, pSound: ma_sound): integer
---@field ma_sound_uninit fun(pSound: ma_sound)
---@field ma_sound_start fun(pSound: ma_sound): integer
---@field ma_sound_stop fun(pSound: ma_sound): integer
---@field ma_sound_set_volume fun(pSound: ma_sound, volume: number)
---@field ma_sound_set_looping fun(pSound: ma_sound, isLooping: integer)
---@field ma_sound_is_playing fun(pSound: ma_sound): integer
---@field ma_sound_at_end fun(pSound: ma_sound): integer
---@field ma_sound_seek_to_pcm_frame fun(pSound: ma_sound, frameIndex: integer): integer

---@cast ma Miniaudio
return ma
