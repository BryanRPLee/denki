local Renderer = require("src.renderer.renderer")
local Camera = require("src.renderer.camera")
local Input = require("src.input.input")
local Scene = require("src.core.scene")
local Entity = require("src.core.entity")
local Mesh = require("src.renderer.mesh")
local rl = require("libs.raylib")
local ffi = require("ffi")

local Engine = {}
Engine.__index = Engine

function Engine.new()
    local self = setmetatable({}, Engine)

    self.renderer = Renderer.new(1280, 720, "Denki - Phase 1", 60)
    self.camera = Camera.new(10.0, 10.0, 10.0)
    self.input = Input.new()
    self.scene = Scene.new("MainScene")

    return self
end

function Engine:init()
    self.renderer:init()
    self.input:disableCursor()
    self:_populateScene()
    print("[Engine] Initialized.")
end

function Engine:update()
    local dt = rl.GetFrameTime()

    if self.input:isKeyPressed("ESCAPE") then
        self.running = false
    end

    self.camera:update(self.input, dt)
    self.scene:update(dt)
end

function Engine:draw()
    self.renderer:beginFrame()

    self.camera:begin3D()

    rl.DrawGrid(40, 1.0)
    self.scene:draw()

    self.camera:end3D()

    rl.DrawText("Denki - Phase 3", 10, 40, 20, Renderer.colors.DARKGRAY)
    rl.DrawText("Entities: " .. self.scene:entityCount(), 10, 65, 18, Renderer.colors.DARKGRAY)
    rl.DrawText("WASD: Move  |  Mouse: Look  |  ESC: Quit", 10, 88, 18, Renderer.colors.DARKGRAY)

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
    self.scene:clear()
    self.renderer:shutdown()
    print("[Engine] Shutdown complete.")
end

function Engine:_populateScene()
    local cubeA = Entity.new("CubeA")
    cubeA.transform:setPosition(0, 1, 0)
    cubeA.transform:setScale(2, 2, 2)
    cubeA:addComponent("mesh", Mesh.new("cube", Renderer.colors.RED))
    self.scene:add(cubeA)

    local cubeB = Entity.new("CubeB")
    cubeB.transform:setPosition(5, 0.75, 5)
    cubeB.transform:setScale(1.5, 1.5, 1.5)
    cubeB:addComponent("mesh", Mesh.new("cube", Renderer.colors.BLUE))
    cubeB:addTag("obstacle")
    self.scene:add(cubeB)

    local cubeC = Entity.new("CubeC")
    cubeC.transform:setPosition(-5, 0.75, -5)
    cubeC.transform:setScale(1.5, 1.5, 1.5)
    cubeC:addComponent("mesh", Mesh.new("cube", Renderer.colors.GREEN))
    cubeC:addTag("obstacle")
    self.scene:add(cubeC)

    local cubeChild = Entity.new("CubeA_Child")
    cubeChild.transform:setPosition(3, 1, 0)
    cubeChild.transform:setScale(1, 1, 1)
    cubeChild:addComponent("mesh", Mesh.new("cube", Renderer.colors.LIGHTGRAY))
    cubeA:addChild(cubeChild)
    self.scene:add(cubeChild)

    print("[Engine] Scene populated: " .. self.scene:entityCount() .. " entities")
end

return Engine
