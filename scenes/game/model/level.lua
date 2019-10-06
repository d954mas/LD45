local COMMON = require "libs.common"
local ENTITIES = require "scenes.game.model.ecs.entities.entities"
local ECS_WORLD = require "scenes.game.model.ecs.ecs"
local Face = require "common.face.face_model"
local FaceView = require "common.face.face_view"

local TAG = "Level"

---@class Level
local Level = COMMON.class("Level")

---@param data LevelData
function Level:initialize()
	self.ecs_world = ECS_WORLD()
	self.scheduler = COMMON.RX.CooperativeScheduler.create()
	self:register_world_entities_callbacks()
	self.face = Face()
	self.face_ideal = Face()
	self.face_ideal:random()
end

function Level:register_world_entities_callbacks()
	self.ecs_world.ecs.on_entity_added = function(_,e) ENTITIES.on_entity_added(e) end
	self.ecs_world.ecs.on_entity_updated = function(_,e) ENTITIES.on_entity_updated(e) end
	self.ecs_world.ecs.on_entity_removed = function(_,e) ENTITIES.on_entity_removed(e) end
end

--region prepare
-- prepared to play. Call it after create and before play
function Level:prepare()
	self.face_available_parts = {}
	self.face_current_parts = {}
	self:face_current_parts_change()
	self.face_ideal:random()
end

function Level:face_current_parts_change()
	for i=1,4 do
		local part = nil
		while not part do
			part = table.remove(self.face_available_parts)
			if not part then
				self.face_available_parts = COMMON.LUME.clone(Face.ALL_AVAILABLE)
				COMMON.LUME.shuffle(self.face_available_parts)
				part = table.remove(self.face_available_parts)
			end
			if self.face[part.name] == part then part = nil end
		end
		self.face_current_parts[i] = part
	end

	local have_needed_part = false
	for i=1,4 do
		local part = self.face_current_parts[i]
		if self.face_ideal[part.name] == part then
			have_needed_part = true
			print("take:" .. i)
			break
		end
	end
	if not have_needed_part then
		local idx = math.random(1,#self.face_current_parts)
		local part = self.face_current_parts[idx]
		while not part or self.face_ideal[part.name] ~= part  do
			part = table.remove(self.face_available_parts)
			if not part then
				self.face_available_parts = COMMON.LUME.clone(Face.ALL_AVAILABLE)
				COMMON.LUME.shuffle(self.face_available_parts)
			end
			if part and self.face[part.name] == part then part = nil end
		end
		assert(part)
		self.face_current_parts[idx] = part
		print("take:" .. idx)
	end
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