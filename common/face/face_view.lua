local COMMON = require "libs.common"

local Face = COMMON.class("Face")

Face.HEAD = {}
Face.EYE = {}
Face.MOUTH = {}
Face.NOSE = {}

function Face:initialize(collection,model)
    if type(collection) == "table" then
        self.collection = {
            root = msg.url(collection[hash("root")]),
            head = msg.url(collection[hash("head")]),
            eye = msg.url(collection[hash("eye")]),
            mouth = msg.url(collection[hash("mouth")]),
            nose = msg.url(collection[hash("nose")])
        }
    else
        self.collection = {
            root = msg.url(go.get(collection .. "/" .. "root")),
            head = msg.url(go.get(collection .. "/" .. "head")),
            eye = msg.url(go.get(collection .. "/" .. "eye")),
            mouth = msg.url(go.get(collection .. "/" .. "mouth")),
            nose = msg.url(go.get(collection .. "/" .. "nose")),
        }
    end
    self.collection_sprites = {
        head = msg.url(self.collection.head.socket,self.collection.head.path,"sprite"),
        eye = msg.url(self.collection.eye.socket,self.collection.eye.path,"sprite"),
        mouth = msg.url(self.collection.mouth.socket,self.collection.mouth.path,"sprite"),
        nose = msg.url(self.collection.nose.socket,self.collection.nose.path,"sprite"),
    }
   self.model = assert(model)
end

function Face:face_changed()
    sprite.play_flipbook(self.collection_sprites.head,self.model.head)
    sprite.play_flipbook(self.collection_sprites.eye,self.model.eye)
    sprite.play_flipbook(self.collection_sprites.mouth,self.model.mouth)
    sprite.play_flipbook(self.collection_sprites.nose,self.model.nose)
end


return Face