local GOOEY = require "gooey.gooey"
local SM = require "libs.sm.sm"
local M = {}

local ATLAS = {"eyebrow", "eyes", "hair", "face"}
local ITEMS = {{"eyebrow_1", "eyebrow_2", "eyebrow_3"},
			   {"eyes_1", "eyes_2"},
			   {"hair_1", "hair_2", "hair_3"},
			   {"face_1", "face_1", "face_1"}
			  }
--last_sprite = {"", "", "", ""}

function M.button_items(action_id,action) 
	local button_click													-- <Кнопка, которую нажали.>
	local new_items = {}
	local item
	
	if action_id == hash("touch") and action.pressed then
		local buttons = {gui.get_node("button_item/button_1"), 
						 gui.get_node("button_item/button_2"),
						 gui.get_node("button_item/button_3"),
						 gui.get_node("button_item/button_4")
						}

		for i = 1, #buttons do  										-- <Находим кнопку по которой кликнули.>
			if gui.pick_node(buttons[i], action.x, action.y) then
				button_click = buttons[i]
			end
		end

		if button_click	~= nil then										-- <Если по какой-то кнопке нажали.>
			for i = 1, #buttons do  									-- <Меняем спрайты всех кнопок.>

				local atlas = math.random(1, #ITEMS)  					--<Рандомим атлас.>
				
				--[[repeat 
					item = math.random(1, #ITEMS[atlas])
				until last_sprite[i] ~= ITEMS[atlas][item]--]]
				item = math.random(1, #ITEMS[atlas])
				
				--last_sprite[i] = ITEMS[atlas][item] 					--<Сохраняем последний спрайт, чтобы не повторялся.>
				
				gui.set_texture(buttons[i], ATLAS[atlas])
				gui.play_flipbook(buttons[i], ITEMS[atlas][item])
			end
		end
	end
end


return M
