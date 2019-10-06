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
	self.win = false
    self.lose = false
    self.started = false
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

function M:start_game()
    self.started = true

    -- Get the current value on component "spine"
    local playback_rate = go.get("/go#spinemodel", "playback_rate")
    -- Set the playback_rate to double the previous value.
    local time = 7.375
    local need_time = 20
    self.time_scale = time/need_time
    sound.play("/sounds#timer")
	spine.play_anim("/go#spinemodel","animtion0",go.PLAYBACK_ONCE_FORWARD,{playback_rate = self.time_scale},function()
		if not self.win then self.lose = true end
	end)
end

function M:update(dt)
end

function M:post_update(dt)
	if self.level then self.level:update(dt) end
	DEBUG_INFO.update(dt)
end

function M:dispose() self:reset() end

function M:on_input(action_id,action)
	
end

function M:item_cell_clicked(i)
	if self.win then return end
	local part = self.level.face_current_parts[i]
	self.level.face:change_part(part)
	self.level.face:changed()
	if self.level.face:equal_one(self.level.face_ideal, part) then
		sound.play("/sounds#correct")
	end
	if self.level.face:equal(self.level.face_ideal) then
		self.win = true
	else
		self.level:face_current_parts_change()
	end
end


local m =  M()

return M