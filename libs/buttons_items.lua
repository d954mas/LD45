local M = {}

local ATLAS = {"eyebrow", "eyes", "hair", "face", "lip"}
local ITEMS = {{"eyebrow_1", "eyebrow_2", "eyebrow_3"},
			   {"eyes_1", "eyes_2"},
			   {"hair_1", "hair_2", "hair_3"},
			   {"face_1", "face_2", "face_3", "face_4", "face_5"},
			   {"lip_1", "lip_2"}
			  }

function M.button_items(last_item, action_id, action) 
	local button_click													-- <Кнопка, которую нажали.>
	local used_atlas = {}												-- <Массив уже использованных атласов.>
	local item															-- <Зарандомленная часть тела.>
	local atlas															-- <Зарандомленный атлас.>
	
	if action_id == hash("touch") and action.pressed then
		local buttons_sprite = {gui.get_node("button_item/button_1"), 
						 gui.get_node("button_item/button_2"),
						 gui.get_node("button_item/button_3"),
						 gui.get_node("button_item/button_4")
					}

		local buttons = {gui.get_node("cell_1/root/bg"), 
						 gui.get_node("cell_2/root/bg"),
						 gui.get_node("cell_3/root/bg"),
						 gui.get_node("cell_4/root/bg")
						}

		for i = 1, #buttons do  										-- <Находим кнопку по которой кликнули.>
			if gui.pick_node(buttons[i], action.x, action.y) then
				button_click = buttons[i]
			end
		end

		if button_click	~= nil then										-- <Если по какой-то кнопке нажали.>
			for i = 1, #buttons do  									-- <Меняем спрайты всех кнопок.>

				repeat
					atlas = math.random(1, #ITEMS)  					--<Рандомим неповторяющиеся атласы.>
				until (used_atlas[i-1] ~= atlas and used_atlas[i-2] ~= atlas and used_atlas[i-3] ~= atlas)
				used_atlas[i] = atlas

				repeat													--<Рандомим неповторяющиеся части тела.>
					item = math.random(1, #ITEMS[atlas])
				until last_item[i] ~= ITEMS[atlas][item]
				last_item[i] = ITEMS[atlas][item]
				
				gui.set_texture(buttons_sprite[i], ATLAS[atlas])
				gui.play_flipbook(buttons_sprite[i], ITEMS[atlas][item])
			end
		end
	end
end


return M
