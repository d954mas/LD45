local COMMON = require "libs.common"
local ENTITIES = require "scenes.game.model.ecs.entities.entities"
local M = {}

M.entities = 0
M.enemies = 0
M.walls = 0
M.walls_transparent = 0
M.walls_total = 0
M.draw_calls = 0
M.instances = 0

---@param game_controller GameController
function M.init(game_controller)
	M.GAME_CONTROLLER = game_controller
end

function M.update(dt)
	if M.GAME_CONTROLLER.level then
		M.entities = #M.GAME_CONTROLLER.level.ecs_world.ecs.entities
	end
end


---@param system DrawWallsSystem
function M.update_draw_walls_system(system)

end



return M