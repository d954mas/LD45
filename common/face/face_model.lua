local COMMON = require "libs.common"

---@class FaceItem
local FaceItem = COMMON.class("FaceItem")
function FaceItem:initialize(img)
    self.img = hash(img)
end

local function fill_with_items(list,start_v,end_v,name)
    for i=start_v,end_v do
        table.insert(list,FaceItem(name .. "_" .. i))
    end
end

local Face = COMMON.class("Face")

---@type FaceItem[]
Face.BODY = {name = "body"}
Face.CLOTH = {name = "cloth"}
Face.EARS = {name = "ears"}
Face.EYE = {name = "eye"}
Face.EYE_BROW = {name = "eye_brow"}
Face.FACE = {name = "face"}
Face.HAIR = {name = "hair"}
Face.MOUTH = {name = "mouth"}
Face.NOSE = {name = "nose"}

---@type FaceItem[][]
Face.ORDERED_PARTS = {Face.BODY,Face.CLOTH,Face.FACE,Face.EARS,Face.EYE,Face.EYE_BROW,Face.HAIR,Face.MOUTH,Face.NOSE}

fill_with_items(Face.BODY,1,1,"body")
fill_with_items(Face.CLOTH,1,1,"clothe")
fill_with_items(Face.EARS,1,1,"ears")
fill_with_items(Face.EYE,1,2,"eyes")
fill_with_items(Face.EYE_BROW,1,3,"eyebrow")
fill_with_items(Face.FACE,1,5,"face")
fill_with_items(Face.HAIR,1,3,"hair")
fill_with_items(Face.MOUTH,1,2,"lip")
fill_with_items(Face.NOSE,1,3,"nose")



function Face:initialize(face)
    if face then
        self.body = face.body
        self.cloth = face.cloth
        self.ears = face.ears
        self.eye = face.eye
        self.eye_brow = face.eye_brow
        self.face = face.face
        self.hair = face.hair
        self.mouth = face.mouth
        self.nose = face.nose
    else
        self.body = Face.BODY[1]
        self.cloth = Face.CLOTH[1]
        self.ears = Face.EARS[1]
        self.eye = Face.EYE[1]
        self.eye_brow = Face.EYE_BROW[1]
        self.face = Face.FACE[1]
        self.hair = Face.HAIR[1]
        self.mouth = Face.MOUTH[1]
        self.nose = Face.NOSE[1]
    end

end

function Face:random()
    self.body = COMMON.LUME.randomchoice(Face.BODY)
    self.cloth = COMMON.LUME.randomchoice(Face.CLOTH)
    self.ears = COMMON.LUME.randomchoice(Face.EARS)
    self.eye = COMMON.LUME.randomchoice(Face.EYE)
    self.eye_brow = COMMON.LUME.randomchoice(Face.EYE_BROW)
    self.face = COMMON.LUME.randomchoice(Face.FACE)
    self.hair = COMMON.LUME.randomchoice(Face.HAIR)
    self.mouth = COMMON.LUME.randomchoice(Face.MOUTH)
    self.nose = COMMON.LUME.randomchoice(Face.NOSE)
end

--for DEBUG
Face.ALL = {}

local function fill_list(parts_index,face)
    local current_parts = Face.ORDERED_PARTS[parts_index]
    if not current_parts then
        table.insert(Face.ALL,Face(face))
        return
    end
    for _,part in ipairs(current_parts)do
        face[current_parts.name] = part
        fill_list(parts_index+1,face)
    end
end

fill_list(1,Face())


return Face