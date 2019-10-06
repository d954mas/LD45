local BaseScene = require "libs.sm.scene"
local COMMON = require "libs.common"
local GAME_CONTROLLER = require "scenes.game.model.game_controller"
local FaceView = require "common.face.face_view"
local SM = require "libs.sm.sm"

---@class StartScene:Scene
local Scene = BaseScene:subclass("StartScene")
function Scene:initialize()
    BaseScene.initialize(self, "StartScene", "/start#proxy", "start:/scene_controller")
end
function Scene:on_show()
    COMMON.input_acquire()
    GAME_CONTROLLER:load_level()
    self.face_ideal = FaceView("man",GAME_CONTROLLER.level.face_ideal)
    GAME_CONTROLLER.level.face_ideal:set_view(self.face_ideal)
end

function Scene:on_hide()
    COMMON.input_release()
end


function Scene:on_update(dt)
    BaseScene.on_update(self,dt)
    msg.post("/phone",GUI_SHOW_FACE and COMMON.HASHES.MSG_ENABLE or COMMON.HASHES.MSG_DISABLE)
end

function Scene:on_input(action_id, action)
    return GAME_CONTROLLER:on_input(action_id,action)
end

function Scene:on_message(message_id, message, sender)
    if message_id == COMMON.HASHES.MSG_POST_UPDATE then GAME_CONTROLLER:post_update(self.dt) end
end


return Scene