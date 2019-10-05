local COMMON = require "libs.common"

local Face = COMMON.class("Face")

Face.HEAD = {}
Face.EYE = {}
Face.MOUTH = {}
Face.NOSE = {}

function Face:initialize(collection)
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
    self.data = {
        head = Face.HEAD[1],
        eye = Face.EYE[1],
        mouth = Face.MOUTH[1],
        nose = Face.NOSE[1],
    }
end

function Face:random()
    self.data.head = COMMON.LUME.randomchoice(Face.HEAD)
    self.data.eye = COMMON.LUME.randomchoice(Face.EYE)
    self.data.mouth = COMMON.LUME.randomchoice(Face.MOUTH)
    self.data.nose = COMMON.LUME.randomchoice(Face.NOSE)
    self:face_changed()
end

function Face:set(type,value)
    self.data[type] = assert(Face[string.upper(type)][value],string.format("unknown face:%s %s", type, value ))
end

function Face:face_changed()
    sprite.play_flipbook(self.collection_sprites.head,self.data.head)
    sprite.play_flipbook(self.collection_sprites.eye,self.data.eye)
    sprite.play_flipbook(self.collection_sprites.mouth,self.data.mouth)
    sprite.play_flipbook(self.collection_sprites.nose,self.data.nose)
end


return Face