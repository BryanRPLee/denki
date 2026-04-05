local ffi = require("ffi")

local raylib = ffi.load("/opt/homebrew/opt/raylib/lib/libraylib.dylib")

ffi.cdef[[
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

    void InitWindow(int width, int height, const char* title);
    void CloseWindow(void);
    bool WindowShouldClose(void);
    void SetTargetFPS(int fps);
    int GetFPS(void);

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
]]

return raylib