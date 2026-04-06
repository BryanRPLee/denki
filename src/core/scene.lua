---@class Scene
---@field name string
---@field entities table
---@field _byName table<string, any>
---@field _byTag table<string, any>
local Scene = {}
Scene.__index = Scene

---@param name? string
---@return Scene
function Scene.new(name)
    local self = setmetatable({}, Scene)

    self.name = name or "Scene"
    self.entities = {}
    self._byName = {}
    self._byTag = {}

    print("[Scene] Created: " .. self.name)

    return self
end

---@param entity any
---@return any
function Scene:add(entity)
    table.insert(self.entities, entity)
    self._byName[entity.name] = entity

    for tag, _ in pairs(entity.tags) do
        if not self._byTag[tag] then
            self._byTag[tag] = {}
        end
        table.insert(self._byTag[tag], entity)
    end

    return entity
end

---@param entity any
function Scene:remove(entity)
    for i, e in ipairs(self.entities) do
        if e.id == entity.id then
            table.remove(self.entities, i)
            self._byName[entity.name] = nil
            break
        end
    end
end

---@param name string
---@return any
function Scene:getByName(name)
    return self._byName[name]
end

---@param tag string
---@return table
function Scene:getByTag(tag)
    return self._byTag[tag] or {}
end

---@param dt number
function Scene:update(dt)
    for _, entity in ipairs(self.entities) do
        entity:update(dt)
    end

    for i = #self.entities, 1, -1 do
        if not self.entities[i].active then
            self._byName[self.entities[i].name] = nil
            table.remove(self.entities, i)
        end
    end
end

function Scene:draw()
    for _, entity in ipairs(self.entities) do
        entity:draw()
    end
end

function Scene:clear()
    self.entities = {}
    self._byName = {}
    self._byTag = {}
    print("[Scene] Cleared.")
end

---@return number
function Scene:entityCount()
    return #self.entities
end

return Scene
