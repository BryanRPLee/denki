local Renderer = require("src.renderer.renderer")
local Camera = require("src.renderer.camera")
local Input = require("src.input.input")
local Scene = require("src.core.scene")
local Entity = require("src.core.entity")
local Mesh = require("src.renderer.mesh")
local Physics = require("src.physics.physics")
local Rigidbody = require("src.physics.rigidbody")
local Player = require("src.core.player")
local Audio = require("src.audio.audio")
local rl = require("libs.raylib")

---@class Engine
---@field renderer Renderer
---@field camera Camera
---@field input Input
---@field physics Physics
---@field scene Scene
---@field player Player
---@field audio Audio
---@field running boolean
local Engine = {}
Engine.__index = Engine

---@return Engine
function Engine.new()
    local self = setmetatable({}, Engine)

    self.renderer = Renderer.new(1280, 720, "Denki - Phase 5", 60)
    self.camera = Camera.new(10.0, 10.0, 10.0)
    self.input = Input.new()
    self.physics = Physics.new()
    self.scene = Scene.new("MainScene")
    self.audio = Audio.new()

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

    self.player:update(self.input, self.camera, dt)
    self.physics:update(dt)
    self.camera:update(self.input, dt)
    self.scene:update(dt)
end

function Engine:draw()
    self.renderer:beginFrame()

    self.camera:begin3D()

    rl.DrawGrid(40, 1.0)
    self.scene:draw()

    self.camera:end3D()

    local rb = self.player.rb
    local t = self.player.entity.transform

    rl.DrawText("Denki - Phase 5", 10, 40, 20, Renderer.colors.DARKGRAY)
    rl.DrawText("Entities: " .. self.scene:entityCount(), 10, 65, 18, Renderer.colors.DARKGRAY)
    rl.DrawText(string.format("Pos: %.1f, %.1f, %.1f", t.position.x, t.position.y, t.position.z), 10, 88, 18,
        Renderer.colors.DARKGRAY)
    rl.DrawText(string.format("Vel: %.1f, %.1f, %.1f", rb.velocity.x, rb.velocity.y, rb.velocity.z), 10, 111, 18,
        Renderer.colors.DARKGRAY)
    rl.DrawText("Grounded: " .. tostring(rb.isGrounded), 10, 134, 18, Renderer.colors.DARKGRAY)
    rl.DrawText("WASD: Move  |  SPACE: Jump  |  Mouse: Look+Fire  |  ESC: Quit", 10, 157, 18, Renderer.colors.DARKGRAY)

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
    if self.audio then
        self.audio:shutdown()
    end
    self.renderer:shutdown()
    print("[Engine] Shutdown complete.")
end

function Engine:_populateScene()
    ---@param name string
    ---@param x number
    ---@param y number
    ---@param z number
    ---@param sx number
    ---@param sy number
    ---@param sz number
    ---@param color any
    ---@return Entity
    local function makeStaticCube(name, x, y, z, sx, sy, sz, color)
        local e = Entity.new(name)
        e.transform:setPosition(x, y, z)
        e.transform:setScale(sx, sy, sz)
        e:addComponent("mesh", Mesh.new("cube", color))
        e:addTag("obstacle")

        local rb = Rigidbody.new({ isStatic = true })
        e:addComponent("rigidbody", rb)
        self.physics:register(rb)
        self.scene:add(e)

        return e
    end

    makeStaticCube("CubeA", 0, 1, 0, 2, 2, 2, Renderer.colors.RED)
    makeStaticCube("CubeB", 5, 0.75, 5, 1.5, 1.5, 1.5, Renderer.colors.BLUE)
    makeStaticCube("CubeC", -5, 0.75, -5, 1.5, 1.5, 1.5, Renderer.colors.GREEN)
    makeStaticCube("Wall1", 10, 2, 0, 1, 4, 10, Renderer.colors.DARKGRAY)

    self.player = Player.new(self.physics, self.audio)
    self.scene:add(self.player.entity)

    print("[Engine] Scene populated: " .. self.scene:entityCount() .. " entities")
end

return Engine
