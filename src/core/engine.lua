local Renderer = require("src.renderer.renderer")
local Camera = require("src.renderer.camera")
local Input = require("src.input.input")
local rl = require("libs.raylib")
local ffi = require("ffi")

local Engine = {}
Engine.__index = Engine

function Engine.new()
    local self = setmetatable({}, Engine)

    self.renderer = Renderer.new(1280, 720, "Denki - Phase 1", 60)
    self.camera = Camera.new(10.0, 10.0, 10.0)
    self.input = Input.new()

    return self
end

function Engine:init()
    self.renderer:init()
    self.input:disableCursor()
    print("[Engine] Initialized.")
end

function Engine:update()
    local dt = rl.GetFrameTime()

    if self.input:isKeyPressed("ESCAPE") then
        self.running = false
    end

    self.camera:update(self.input, dt)
end

function Engine:draw()
    self.renderer:beginFrame()

    self.camera:begin3D()

    rl.DrawGrid(40, 1.0)

    rl.DrawCube(
        ffi.new("Vector3", { 0.0, 1.0, 0.0 }),
        2.0,
        2.0,
        2.0,
        Renderer.colors.RED
    )
    rl.DrawCubeWires(
        ffi.new("Vector3", { 0.0, 1.0, 0.0 }),
        2.0,
        2.0,
        2.0,
        Renderer.colors.BLACK
    )

    rl.DrawCube(
        ffi.new("Vector3", {  5.0, 1.0,  5.0 }),
        1.5,
        1.5,
        1.5,
        Renderer.colors.BLUE
    )
    rl.DrawCube(
        ffi.new("Vector3", { -5.0, 1.0, -5.0 }),
        1.5,
        1.5,
        1.5,
        Renderer.colors.GREEN
    )

    self.camera:end3D()

    rl.DrawText("Denki - Phase 2", 10, 40, 20, Renderer.colors.DARKGRAY)
    rl.DrawText("WASD: Move  |  Mouse: Look  |  ESC: Quit", 10, 65, 18, Renderer.colors.DARKGRAY)

    self.renderer:endFrame()
end

function Engine:run()
    self:init()
    self.running = true

    print("[Engine] Starting main loop...")
    while self.running and not self.renderer:shouldClose() do
        self:update()
        self:draw()
    end

    self:shutdown()
end

function Engine:shutdown()
    self.input:enableCursor()
    self.renderer:shutdown()
    print("[Engine] Shutdown complete.")
end

return Engine