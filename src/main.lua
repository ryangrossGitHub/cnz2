screen_size = 128
user_data_memory_address = 0x8000
log_file = "log.txt"

function _init()
	printh("GAME INIT", log_file, true)
	
	-- Preload external assets into user data memory slots
	-- reload(0x8000, 0x0000, 0x0800, "characters.p8")

	-- reload(0x8800, 0x0800, 0x0800, "map2.p8")
	-- reload(0x9000, 0x2000, 0x1000, "map2.p8")
	
	-- reload(0xa000, 0x0800, 0x0800, "map3.p8")
	-- reload(0xa800, 0x2000, 0x1000, "map3.p8")
	
	-- reload(0xb800, 0x0800, 0x0800, "map4.p8")
	-- reload(0xc000, 0x2000, 0x1000, "map4.p8")
	
	-- reload(0xd000, 0x0800, 0x0800, "map5.p8")
	-- reload(0xd800, 0x2000, 0x1000, "map5.p8")
	
	-- reload(0xe800, 0x0800, 0x0800, "map6.p8")
	-- reload(0xf000, 0x2000, 0x1000, "map6.p8")

	printh(" external assets loaded successfully", log_file)

	palt(13, true) -- Transparent Color Is Purple (13)
	palt(0, false)
	load_stage(0)
	music(0)
end

function _update()
 	if stage == 0 then
  		update_start()
	elseif stage_trans then
  		update_stage_trans()
 	else
		if stages[stage].enemy_spawn_count > enemey_spawn_stage_count then
			enemy_spawn_delay_count += 1
				
			if e_spawn and enemy_spawn_delay_count >= stages[stage].enemy_spawn_delay then
				spawn_enemy(stages[stage].enemy_speed)
				enemy_spawn_delay_count = 0
				enemey_spawn_stage_count += 1
			end
		else
			local all_dead = true
				
			for e in all(enemies) do
				if not e.dead then
					all_dead = false
					break
				end
			end
					
			if all_dead then
				load_stage(stage+1)
			end
		end
	end
 
	if player_move then
		update_player_move(p1,0)
		
		if coop then
			update_player_move(p2,1)
		end
	end
 
	if p1.weapon_delay > 0 then
		p1.weapon_delay -= 1
	end

	if p2.weapon_delay > 0 then
		p2.weapon_delay -= 1
	end
 
	if not coop then
		update_p2()
	end
 
	update_enemies()
	update_player_anims(p1)
	update_player_anims(p2)
end

function _draw()
	cls()
	map(0,0)
 
	local s = stages[stage]
	if not s then
		s = stages[1]
	end
 
	camera(camera_x,camera_y)
	draw_enemies()
	draw_particles(particles)

	say(58,12,"DONUTS ♥", 0, false)
	say(screen_size + 58, 12, "COFFEE ●", 0, false)
	say(screen_size * 2 + 58, 12, "PARKING ★", 0, false)
	say(screen_size * 3 + 29, 17, "ICE CREAM", 0, false)
	say(screen_size * 5 + 37, 40, "WATER TREATEMENT PLANT ∧", 0, false)
	say(screen_size * 7 + 32, 49, "danger! DO NOT ENTER", 0, false)
   
	spr(p1.sprite, p1.x, p1.y, 2, 2, p1.flip_sprite, false)
	print("p1", p1.x - 3, p1.y - 7, 8)
	spr(p2.sprite, p2.x, p2.y, 2, 2, p2.flip_sprite, false)
 
	local p2_disp = "cp"
	if coop then
		p2_disp = "p2"
	end
	print(p2_disp, p2.x - 3, p2.y - 7, 12)
 
	if stage == 0 then
		draw_start()
	elseif stage == 16 then
		if stage_trans == false then
			ending_dialog()
		end
	end

	if stage_trans then
		draw_trans_dialog() 
	end
end