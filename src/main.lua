screen_size = 128

function _init()
	palt(13, true)
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
 
	if p_move then
		update_p_move(p1,0)
		
		if coop then
			update_p_move(p2,1)
		end
	end
 
	if sgun.cnt > 0 then
		sgun.cnt -= 1
	end

	if pstol.cnt > 0 then
		pstol.cnt -= 1
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
   
	spr(get_pspr(p1), p1.x, p1.y, 2, 2, p1.f, false)
	print("p1", p1.x - 3, p1.y - 6, 8)
	spr(get_pspr(p2), p2.x, p2.y, 2, 2, p2.f, false)
 
	local p2_disp = "cp"
	if coop then
		p2_disp = "p2"
	end
	print(p2_disp, p2.x - 3, p2.y - 6, 12)
 
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