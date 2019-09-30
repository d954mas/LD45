local COMMON = require "libs.common"
local RX = require "libs.rx"
local LEVELS = require "scenes.game.model.levels"
local EVENTS = require "libs.events"
local ENTITIES = require "scenes.game.model.ecs.entities.entities"
local RENDER_CAM = require "rendercam.rendercam"
local DEBUG_INFO = require "debug.debug_info"

local TAG = "GameController"

---@class GameController
local M = COMMON.class("GameController")

function M:reset()
	if self.level then self.level:dispose() end
	self.level = nil
	ENTITIES.clear()
end

function M:initialize()
	ENTITIES.set_game_controller(self)
	self.rx = RX.Subject()
	self:reset()
	DEBUG_INFO.init(self)
end
--endregion

function M:load_level(name)
	assert(not self.level,"lvl already loaded")
	self.level = LEVELS.load_level(name)
	self.level:prepare()
end

function M:update(dt) end

function M:post_update(dt)
	if self.level then self.level:update(dt) end
	DEBUG_INFO.update(dt)
end

function M:dispose() self:reset() end

function M:on_input(action_id,action)
	
end

return M()