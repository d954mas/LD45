local BaseScene = require "libs.sm.scene"

---@class WinModal:Scene
local Scene = BaseScene:subclass("WinModal")
function Scene:initialize()
    BaseScene.initialize(self, "WinModal", "/win_modal#proxy", "win_modal:/scene_controller")
    self._config.modal = true
end




return Scene