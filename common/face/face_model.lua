local COMMON = require "libs.common"

local Face = COMMON.class("Face")

Face.HEAD = {}
Face.EYE = {}
Face.MOUTH = {}
Face.NOSE = {}

function Face:initialize()
    self.head = Face.HEAD[1]
    self.eye = Face.EYE[1]
    self.mouth = Face.MOUTH[1]
    self.nose = Face.NOSE[1]
end

function Face:random()
    self.head = COMMON.LUME.randomchoice(Face.HEAD)
    self.eye = COMMON.LUME.randomchoice(Face.EYE)
    self.mouth = COMMON.LUME.randomchoice(Face.MOUTH)
    self.nose = COMMON.LUME.randomchoice(Face.NOSE)
    self:face_changed()
end


return Face