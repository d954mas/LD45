local BaseScene = require "libs.sm.scene"
local COMMON = require "libs.common"
local GAME_CONTROLLER = require "scenes.game.model.game_controller"
local SM = require "libs.sm.sm"

---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
    BaseScene.initialize(self, "GameScene", "/game#proxy", "game:/scene_controller")
end

function Scene:on_show()
    GAME_CONTROLLER:load_level(assert(self._input.level,"need level name"))
    COMMON.input_acquire()
end

function Scene:on_hide()
    COMMON.input_release()
end

function Scene:on_final(go_self)
    GAME_CONTROLLER:dispose()
end

function Scene:on_update(dt)
    self.dt = dt
    BaseScene.on_update(self,dt)
    GAME_CONTROLLER:update(dt)
    msg.post("#",COMMON.HASHES.MSG_POST_UPDATE)
end

function Scene:on_input(action_id, action)
    return GAME_CONTROLLER:on_input(action_id,action)
end

function Scene:on_message(message_id, message, sender)
    if message_id == COMMON.HASHES.MSG_POST_UPDATE then GAME_CONTROLLER:post_update(self.dt) end
end


return Scene