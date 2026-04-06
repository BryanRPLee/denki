local ffi = require("ffi")

local raylib = ffi.load("/opt/homebrew/opt/raylib/lib/libraylib.dylib")

ffi.cdef [[
    typedef struct Vector2 { float x; float y; } Vector2;
    typedef struct Vector3 { float x; float y; float z; } Vector3;
    typedef struct Color { unsigned char r; unsigned char g; unsigned char b; unsigned char a; } Color;
    typedef struct Camera3D {
        Vector3 position;
        Vector3 target;
        Vector3 up;
        float fovy;
        int projection;
    } Camera3D;
    typedef struct BoundingBox {
        Vector3 min;
        Vector3 max;
    } BoundingBox;
    typedef struct Sound {
        char _opaque[48];
    } Sound;

    void InitWindow(int width, int height, const char* title);
    void CloseWindow(void);
    bool WindowShouldClose(void);
    void SetTargetFPS(int fps);
    int GetFPS(void);
    float GetFrameTime(void);

    void BeginDrawing(void);
    void EndDrawing(void);
    void ClearBackground(Color color);
    void BeginMode3D(Camera3D camera);
    void EndMode3D(void);

    void DrawCube(Vector3 position, float width, float height, float length, Color color);
    void DrawCubeWires(Vector3 position, float width, float height, float length, Color color);
    void DrawGrid(int slices, float spacing);

    void DrawFPS(int posX, int posY);
    void DrawText(const char* text, int posX, int posY, int fontSize, Color color);

    bool IsKeyDown(int key);
    bool IsKeyPressed(int key);
    bool IsKeyReleased(int key);
    bool IsMouseButtonDown(int button);
    bool IsMouseButtonPressed(int button);

    void DisableCursor(void);
    void EnableCursor(void);
    Vector2 GetMouseDelta(void);
    void SetMousePosition(int x, int y);

    void InitAudioDevice(void);
    void CloseAudioDevice(void);
    bool IsAudioDeviceReady(void);
    Sound LoadSound(const char* fileName);
    void UnloadSound(Sound sound);
    void PlaySound(Sound sound);
    void StopSound(Sound sound);
    bool IsSoundPlaying(Sound sound);
    void SetSoundVolume(Sound sound, float volume);
]]

---@class Vector2
---@field x number
---@field y number

---@class Vector3
---@field x number
---@field y number
---@field z number

---@class Color
---@field r number
---@field g number
---@field b number
---@field a number

---@class Camera3D
---@field position Vector3
---@field target Vector3
---@field up Vector3
---@field fovy number
---@field projection integer

---@class BoundingBox
---@field min Vector3
---@field max Vector3

---@class Sound

---@class Raylib
---@field InitWindow fun(width: integer, height: integer, title: string)
---@field CloseWindow fun()
---@field WindowShouldClose fun(): boolean
---@field SetTargetFPS fun(fps: integer)
---@field GetFPS fun(): integer
---@field GetFrameTime fun(): number
---@field BeginDrawing fun()
---@field EndDrawing fun()
---@field ClearBackground fun(color: Color)
---@field BeginMode3D fun(camera: Camera3D)
---@field EndMode3D fun()
---@field DrawCube fun(position: Vector3, width: number, height: number, length: number, color: Color)
---@field DrawCubeWires fun(position: Vector3, width: number, height: number, length: number, color: Color)
---@field DrawGrid fun(slices: integer, spacing: number)
---@field DrawFPS fun(posX: integer, posY: integer)
---@field DrawText fun(text: string, posX: integer, posY: integer, fontSize: integer, color: Color)
---@field IsKeyDown fun(key: integer): boolean
---@field IsKeyPressed fun(key: integer): boolean
---@field IsKeyReleased fun(key: integer): boolean
---@field IsMouseButtonDown fun(button: integer): boolean
---@field IsMouseButtonPressed fun(button: integer): boolean
---@field DisableCursor fun()
---@field EnableCursor fun()
---@field GetMouseDelta fun(): Vector2
---@field SetMousePosition fun(x: integer, y: integer)
---@field InitAudioDevice fun()
---@field CloseAudioDevice fun()
---@field IsAudioDeviceReady fun(): boolean
---@field LoadSound fun(fileName: string): Sound
---@field UnloadSound fun(sound: Sound)
---@field PlaySound fun(sound: Sound)
---@field StopSound fun(sound: Sound)
---@field IsSoundPlaying fun(sound: Sound): boolean
---@field SetSoundVolume fun(sound: Sound, volume: number)

---@cast raylib Raylib
return raylib
