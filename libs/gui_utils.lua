local GOOEY = require "gooey.gooey"
local SM = require "libs.sm.sm"
local M = {}

function M.get_scaled_size(node)
	assert(node)
	local size = gui.get_size(node)
	local scale = gui.get_scale(node)
	size.x = size.x * scale.x
	size.y = size.y * scale.y
	size.z = size.z * scale.z
	return size
end

local btn_question_refresh = function(button)
	local scale = vmath.vector4(2)
	if button.pressed then
		gui.set_scale(button.node,scale * 0.9)
	else
		gui.set_scale(button.node,scale)
	end
end
function M.btn_question(node,action_id,action)
	GOOEY.button(node,action_id,action,function ()
		SM:show("TooltipModal")
	end,btn_question_refresh)
end

return M