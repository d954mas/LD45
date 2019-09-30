local COMMON = require "libs.common"
local TAG = "ENTITIES"

---@class Entity
---@field tag string tag used for help when debug

---@class ENTITIES
local Entities = {}

---@type Entity[]
Entities.url_to_entity = {}
Entities.entity_to_url = {}

--region utils
---@param url url key that used for mapping entity to url_go
local function url_to_key(url) return url.path end

---@param ignore_warning boolean Used when trying to find entity when hit wall.
function Entities.get_entity_for_url(url,ignore_warning)
	local e =  Entities.url_to_entity[url_to_key(url)]
	if not e and not ignore_warning then
		COMMON.w("no entity for url:" .. url,TAG)
	end
	return e
end

function Entities.clear()
	Entities.entity_to_url = {}
	Entities.url_to_entity = {}
	Entities.enemies = {}
end

---@param game_controller GameController
function Entities.set_game_controller(game_controller) Entities.game_controller = assert(game_controller) end

--region ecs callbacks
---@param e Entity
function Entities.on_entity_removed(e)
end

---@param e Entity
function Entities.on_entity_added(e)

end

---@param e Entity
function Entities.on_entity_updated(e)

end
--endregion


return Entities




