local Transform = require("src.core.transform")

---@class Entity
---@field id number
---@field name string
---@field active boolean
---@field transform Transform
---@field components table<string, any>
---@field tags table<string, boolean>
---@field children Entity[]
---@field parent Entity|nil
local Entity = {}
Entity.__index = Entity

local nextId = 1

---@param name? string
---@return Entity
function Entity.new(name)
    local self = setmetatable({}, Entity)

    self.id = nextId
    nextId = nextId + 1
    self.name = name or ("Entity_" .. self.id)
    self.active = true
    self.transform = Transform.new()
    self.components = {}
    self.tags = {}
    self.children = {}
    self.parent = nil

    print("[Entity] Created: " .. self.name .. " (id=" .. self.id .. ")")

    return self
end

---@param name string
---@param component any
---@return any
function Entity:addComponent(name, component)
    self.components[name] = component
    component.entity = self
    return component
end

---@param name string
---@return any
function Entity:getComponent(name)
    return self.components[name]
end

---@param name string
function Entity:removeComponent(name)
    self.components[name] = nil
end

---@param tag string
function Entity:addTag(tag)
    self.tags[tag] = true
end

---@param tag string
---@return boolean
function Entity:hasTag(tag)
    return self.tags[tag] == true
end

---@param child Entity
function Entity:addChild(child)
    child.parent = self
    table.insert(self.children, child)
end

---@param dt number
function Entity:update(dt)
    if not self.active then
        return
    end

    for _, comp in pairs(self.components) do
        if comp.update then
            comp:update(dt)
        end
    end

    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

function Entity:draw()
    if not self.active then
        return
    end

    for _, comp in pairs(self.components) do
        if comp.draw then
            comp:draw()
        end
    end

    for _, child in ipairs(self.children) do
        child:draw()
    end
end

function Entity:destroy()
    self.active = false
    print("[Entity] Destroyed " .. self.name)
end

return Entity
