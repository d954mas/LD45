local BaseScene = require "libs.sm.scene"

---@class SelectLocaleScene:Scene
local Scene = BaseScene:subclass("SelectLocale")
function Scene:initialize()
    BaseScene.initialize(self, "SelectLocale", "/select_locale#proxy", "select_locale:/scene_controller")
end




return Scene