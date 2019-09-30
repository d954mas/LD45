local COMMON = require "libs.common"
local Level = require "scenes.game.model.level"
local M = {}
local TAG = "LEVEL"

M.TESTS = {
}

M.LEVELS = {
	PROTOTYPE = "prototype",
}


---@return Level
function M.load_level(name)
	local time = os.clock()
	--local data = assert(sys.load_resource("/assets/levels/result/" .. name .. ".json","no lvl:" .. name))
	local data = "{}"
	local lvl = Level(json.decode(data))
	COMMON.d("lvl:" .. name .. " loaded. Time:" .. (os.clock()-time),TAG)
	return lvl
end



return M