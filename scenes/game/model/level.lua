local COMMON = require "libs.common"
local ENTITIES = require "scenes.game.model.ecs.entities.entities"
local ECS_WORLD = require "scenes.game.model.ecs.ecs"

local TAG = "Level"

---@class Level
local Level = COMMON.class("Level")

---@param data LevelData
function Level:initialize(data)
	self.data = assert(data)
	self.ecs_world = ECS_WORLD()
	self.scheduler = COMMON.RX.CooperativeScheduler.create()
	self:register_world_entities_callbacks()
end

function Level:register_world_entities_callbacks()
	self.ecs_world.ecs.on_entity_added = function(_,e) ENTITIES.on_entity_added(e) end
	self.ecs_world.ecs.on_entity_updated = function(_,e) ENTITIES.on_entity_updated(e) end
	self.ecs_world.ecs.on_entity_removed = function(_,e) ENTITIES.on_entity_removed(e) end
end

--region prepare
-- prepared to play. Call it after create and before play
function Level:prepare()
end


--endregion
function Level:update(dt)
	self.scheduler:update(dt)
	self.ecs_world:update(dt)
end

function Level:dispose()
	self.ecs_world:clear()
end

return Level