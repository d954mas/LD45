local BaseScene = require "libs.sm.scene"

---@class TooltipModal:Scene
local Scene = BaseScene:subclass("SelectLocale")
function Scene:initialize()
    BaseScene.initialize(self, "TooltipModal", "/tooltip_modal#proxy", "tooltip_modal:/scene_controller")
    self._config.modal = true
end




return Scene