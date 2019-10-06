local COMMON = require "libs.common"
local RX = require "libs.rx"
local Level = require "scenes.game.model.level"
local EVENTS = require "libs.events"
local ENTITIES = require "scenes.game.model.ecs.entities.entities"
local RENDER_CAM = require "rendercam.rendercam"
local DEBUG_INFO = require "debug.debug_info"

local TAG = "GameController"

---@class GameController
local M = COMMON.class("GameController")

function M:reset()
	ENTITIES.clear()
	self.level:dispose()
end

function M:initialize()
	ENTITIES.set_game_controller(self)
	self.rx = RX.Subject()
	DEBUG_INFO.init(self)
end

function M:load_level()
	self.level = Level()
	self.level:prepare()
end	
--endregion

function M:update(dt) end

function M:post_update(dt)
	if self.level then self.level:update(dt) end
	DEBUG_INFO.update(dt)
end

function M:dispose() self:reset() end

function M:on_input(action_id,action)
	
end

function M:item_cell_clicked(i)
	local part = self.level.face_current_parts[i]
	self.level.face:change_part(part)
	self.level.face:changed()
	self.level:face_current_parts_change()
end


local m =  M()

return M