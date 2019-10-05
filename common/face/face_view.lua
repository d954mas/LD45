local COMMON = require "libs.common"

---@class FaceView
local Face = COMMON.class("Face")

Face.HEAD = {}
Face.EYE = {}
Face.MOUTH = {}
Face.NOSE = {}

function Face:initialize(collection,model)
    if type(collection) == "table" then
    else
        print(collection .. "/" .. "root")
        self.collection = {
            root = msg.url(collection .. "/" .. "root"),
            body = msg.url(collection .. "/" .. "body"),
            cloth = msg.url(collection .. "/" .. "cloth"),
            ears = msg.url(collection .. "/" .. "ears"),
            eye = msg.url(collection .. "/" .. "eye"),
            eye_brow = msg.url(collection .. "/" .. "eye_brow"),
            face = msg.url(collection .. "/" .. "face"),
            hair = msg.url(collection .. "/" .. "hair"),
            mouth = msg.url(collection .. "/" .. "mouth"),
            nose = msg.url(collection .. "/" .. "nose"),
        }
    end
    self.collection_sprites = {
        body = msg.url(self.collection.body.socket,self.collection.body.path,"sprite"),
        cloth = msg.url(self.collection.cloth.socket,self.collection.cloth.path,"sprite"),
        ears = msg.url(self.collection.ears.socket,self.collection.ears.path,"sprite"),
        eye = msg.url(self.collection.eye.socket,self.collection.eye.path,"sprite"),
        eye_brow = msg.url(self.collection.eye_brow.socket,self.collection.eye_brow.path,"sprite"),
        face = msg.url(self.collection.face.socket,self.collection.face.path,"sprite"),
        hair = msg.url(self.collection.hair.socket,self.collection.hair.path,"sprite"),
        mouth = msg.url(self.collection.mouth.socket,self.collection.mouth.path,"sprite"),
        nose = msg.url(self.collection.nose.socket,self.collection.nose.path,"sprite"),
    }
    self:set_face(model)
end

function Face:set_face(face)
    self.model = assert(face)
    self:face_changed()
end

function Face:face_changed()
    for k,v in pairs(self.collection_sprites) do
        if not self.model[k] then
            print("sss")
        end
        assert(self.model[k],"no key " .. tostring(k))
        sprite.play_flipbook(v,self.model[k].img)
    end
end


return Face