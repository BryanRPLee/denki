local rl = require("libs.raylib")
local ffi = require("ffi")

local Renderer = require("src.renderer.renderer")

---@class Mesh
---@field shape string
---@field color any
---@field entity any
local Mesh = {}
Mesh.__index = Mesh

---@param shape? string
---@param color? any
---@return Mesh
function Mesh.new(shape, color)
    local self = setmetatable({}, Mesh)

    self.shape = shape or "cube"
    self.color = color or Renderer.colors.RED
    self.entity = nil

    return self
end

function Mesh:draw()
    if not self.entity then
        return
    end

    local t = self.entity.transform
    local pos = t.position:toFFI()
    local sx = t.scale.x
    local sy = t.scale.y
    local sz = t.scale.z

    if self.shape == "cube" then
        rl.DrawCube(pos, sx, sy, sz, self.color)
        rl.DrawCubeWires(pos, sx, sy, sz, Renderer.colors.BLACK)
    end
end

return Mesh
