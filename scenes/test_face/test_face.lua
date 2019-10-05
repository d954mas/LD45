local BaseScene = require "libs.sm.scene"
local COMMON = require "libs.common"
local GAME_CONTROLLER = require "scenes.game.model.game_controller"
local SM = require "libs.sm.sm"
local FaceModel = require "common.face.face_model"
local FaceView = require "common.face.face_view"

---@class TestFaceScene:Scene
local Scene = BaseScene:subclass("TestFace")
function Scene:initialize()
    BaseScene.initialize(self, "TestFace", "/test_face#proxy", "test_face:/scene_controller")
end


function Scene:on_show()
    ---@type FaceView[]
    self.faces = {}
    self.faces_size = 6
    self.faces_page_current = 1
    self.faces_page_max = math.ceil(#FaceModel.ALL/self.faces_size)
    
    for i=1,self.faces_size do
        table.insert(self.faces,FaceView("/man" .. i,FaceModel()))
    end
    self:faces_update_page()
end

function Scene:faces_update_page()
    local start_index = (self.faces_page_current-1)* self.faces_size
    for i=1,self.faces_size do
        local idx = start_index+i
        if FaceModel.ALL[idx] then
            self.faces[i]:set_face(FaceModel.ALL[start_index+i])
        end
    end
    COMMON.GLOBAL.DEBUG_FACES = {faces_page_current = self.faces_page_current, faces_page_max = self.faces_page_max}
end

function Scene:faces_changed_page(value)
    self.faces_page_current = self.faces_page_current + value
    if self.faces_page_current < 0 then self.faces_page_current = self.faces_page_max end
    if self.faces_page_current > self.faces_page_max then self.faces_page_current = 1 end
    self:faces_update_page()
end

function Scene:on_message(message_id, message, sender)
    if message_id == hash("change_page") then
        self:faces_changed_page(message.value)
    end
end

return Scene