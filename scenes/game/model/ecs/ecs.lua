local requiref = require
local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "scenes.game.model.ecs.systems"

local EcsWorld = COMMON.class("EcsWorld")

function EcsWorld:initialize()
	self.ecs = ECS.world()
	self.ecs.game_controller = requiref("scenes.game.model.game_controller")
	self:_init_systems()
	self.systems = SYSTEMS
end

function EcsWorld:_init_systems()
	SYSTEMS.load()
end

function EcsWorld:update(dt)
	self.ecs:update(dt)
end

function EcsWorld:clear()
	self.ecs:clear()
end

function EcsWorld:add(...)
	self.ecs:add()
end

function EcsWorld:add_entity(e)
	self.ecs:addEntity(e)
end

function EcsWorld:remove_entity(e)
	self.ecs:removeEntity(e)
end

return EcsWorld



