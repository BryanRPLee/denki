local rl = require("libs.raylib")
local ffi = require("ffi")

local Renderer = {}
Renderer.__index = Renderer

Renderer.colors = {
    RAYWHITE = ffi.new("Color", { 245, 245, 245, 255 }),
    BLACK = ffi.new("Color", { 0, 0, 0, 255 }),
    RED = ffi.new("Color", { 230, 41, 55, 255 }),
    GREEN = ffi.new("Color", { 0, 228, 48, 255 }),
    BLUE = ffi.new("Color", { 0, 121, 241, 255 }),
    DARKGRAY = ffi.new("Color", { 80, 80, 80, 255 }),
    LIGHTGRAY = ffi.new("Color", { 200, 200, 200, 255 }),
}

function Renderer.new(width, height, title, fps)
    local self = setmetatable({}, Renderer)

    self.width = width or 1280
    self.height = height or 720
    self.title = title or "Denki"
    self.fps = fps or 60

    return self
end

function Renderer:init()
    rl.InitWindow(self.width, self.height, self.title)
    rl.SetTargetFPS(self.fps)
    print("[Renderer] Window initialized: " .. self.width .. "x" .. self.height)
end

function Renderer:beginFrame()
    rl.BeginDrawing()
    rl.ClearBackground(Renderer.colors.RAYWHITE)
end

function Renderer:endFrame()
    rl.DrawFPS(10, 10)
    rl.EndDrawing()
end

function Renderer:shouldClose()
    return rl.WindowShouldClose()
end

function Renderer:shutdown()
    rl.CloseWindow()
    print("[Renderer] Window closed.")
end

return Renderer
