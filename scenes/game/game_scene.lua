local BaseScene = require "libs.sm.scene"
local COMMON = require "libs.common"
local GAME_CONTROLLER = require "scenes.game.model.game_controller"
local SM = require "libs.sm.sm"
local FaceView = require "common.face.face_view"

local MAN_PHRASES = {
    "Alince still my face.I need to make new from nothing.",
    "I forgot my face at home.I need to make new from nothing.",
    "My previous girl still my face.I need to make new from nothing.",
    "FBI is looking for me.I need to make new from nothing.",
    "My race will capture this planet.I need new face.",
    "What happened yesterday and where is my face.I need new face."
}

---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
    BaseScene.initialize(self, "GameScene", "/game#proxy", "game:/scene_controller")
end
function Scene:on_show()
    COMMON.input_acquire()
    spine.play_anim("/go#spinemodel","animtion0",go.PLAYBACK_LOOP_FORWARD)
    self.face_view = FaceView("/man",GAME_CONTROLLER.level.face)
    self.face_ideal = FaceView("/man_ideal",GAME_CONTROLLER.level.face_ideal)
    GAME_CONTROLLER.level.face:set_view(self.face_view)
    label.set_text("/lbl_start#label",COMMON.LUME.randomchoice(MAN_PHRASES))
    msg.post("/lbl_start#label",COMMON.HASHES.MSG_ENABLE)
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
    if action_id == COMMON.HASHES.INPUT_TOUCH and action.pressed then
        msg.post("/lbl_start#label",COMMON.HASHES.MSG_DISABLE)
    end

    return GAME_CONTROLLER:on_input(action_id,action)
end

function Scene:on_message(message_id, message, sender)
    if message_id == COMMON.HASHES.MSG_POST_UPDATE then GAME_CONTROLLER:post_update(self.dt) end
end


return Scene