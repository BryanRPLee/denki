local Renderer = require("src.renderer.renderer")
local Camera = require("src.renderer.camera")
local rl = require("libs.raylib")
local ffi = require("ffi")

local Engine = {}
Engine.__index = Engine

function Engine.new()
    local self = setmetatable({}, Engine)
    self.renderer = Renderer.new(1280, 720, "LuaEngine - Phase 1")
    self.camera = Camera.new(
        10.0, 10.0, 10.0,
        0.0, 0.0, 0.0
    )
    return self
end

function Engine:init()
    self.renderer:init()
    print("[Engine] Initialized.")
end

function Engine:update()
end

function Engine:draw()
    self.renderer:beginFrame()

    self.camera:begin3D()

    rl.DrawGrid(20, 1.0)

    rl.DrawCube(
        ffi.new("Vector3", { 0.0, 1.0, 0.0 }),
        2.0, 2.0, 2.0,
        Renderer.colors.RED
    )
    rl.DrawCubeWires(
        ffi.new("Vector3", { 0.0, 1.0, 0.0 }),
        2.0, 2.0, 2.0,
        Renderer.colors.BLACK
    )

    self.camera:end3D()

    rl.DrawText("LuaEngine - Phase 1", 10, 40, 20, Renderer.colors.DARKGRAY)

    self.renderer:endFrame()
end

function Engine:run()
    self:init()

    print("[Engine] Starting main loop...")
    while not self.renderer:shouldClose() do
        self:update()
        self:draw()
    end

    self:shutdown()
end

function Engine:shutdown()
    self.renderer:shutdown()
    print("[Engine] Shutdown complete.")
end

return Engine