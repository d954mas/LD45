local BaseScene = require "libs.sm.scene"

---@class LoseModal:Scene
local Scene = BaseScene:subclass("LoseModal")
function Scene:initialize()
    BaseScene.initialize(self, "LoseModal", "/lose_modal#proxy", "lose_modal:/scene_controller")
    self._config.modal = true
end




return Scene