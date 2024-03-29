local COMMON = require "libs.common"

---@class FaceItem
local FaceItem = COMMON.class("FaceItem")
function FaceItem:initialize(img,atlas,name)
    self.img = hash(img)
    self.atlas = atlas
    self.name = name
end

local function fill_with_items(list,start_v,end_v,name)
    for i=start_v,end_v do
        table.insert(list,FaceItem(name .. "_" .. i,name,list.name))
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

Face.EMPTY = FaceItem("sss")
Face.EMPTY.img = nil

---@type FaceItem[][]
Face.ORDERED_PARTS = {Face.BODY,Face.CLOTH,Face.FACE,Face.EARS,Face.EYE,Face.EYE_BROW,Face.HAIR,Face.MOUTH,Face.NOSE}

fill_with_items(Face.BODY,1,1,"body")
fill_with_items(Face.CLOTH,1,3,"clothe")
fill_with_items(Face.EARS,1,1,"ears")
fill_with_items(Face.EYE,1,3,"eyes")
fill_with_items(Face.EYE_BROW,1,4,"eyebrow")
fill_with_items(Face.FACE,1,5,"face")
fill_with_items(Face.HAIR,1,4,"hair")
fill_with_items(Face.MOUTH,1,2,"lip")
fill_with_items(Face.NOSE,1,2,"nose")


local available = {Face.EYE,Face.EYE_BROW,Face.FACE,Face.HAIR,Face.MOUTH,Face.NOSE, Face.CLOTH}
Face.ALL_AVAILABLE = {}

for _,pages in ipairs(available)do
    for _,page in ipairs(pages)do
        table.insert(Face.ALL_AVAILABLE,page)
    end
end



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
        self.eye = Face.EMPTY
        self.eye_brow = Face.EMPTY
        self.face = COMMON.LUME.randomchoice(Face.FACE)
        self.hair = Face.EMPTY
        self.mouth = Face.EMPTY
        self.nose = Face.EMPTY
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
    self:changed()
end

---@param view FaceView
function Face:set_view(view)
    self.view = assert(view)
end

function Face:changed()
    if self.view then self.view:face_changed() end
end

function Face:change_part(part)
    self[part.name] = part
    self:changed()
end

function Face:equal(face)
    return self.body == face.body and
           self.cloth == face.cloth and
           self.ears == face.ears and
           self.eye == face.eye and
           self.eye_brow == face.eye_brow and
           self.face == face.face and
           self.hair == face.hair and
           self.mouth == face.mouth and
           self.nose == face.nose
end

function Face:equal_one(face, part)
    return part == face.body or
            part == face.cloth or
            part == face.ears or
            part == face.eye or
            part == face.eye_brow or
            part == face.face or
            part == face.hair or
            part == face.mouth or
            part == face.nose
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