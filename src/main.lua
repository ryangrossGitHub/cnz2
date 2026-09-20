screen_size = 128
user_data_memory_address = 0x8000
log_file = "log.txt"
intro_text_full = "dispatch to all units, respond immediately to a public disturbance at da club."
intro_text = ""
intro_count = 0

music_tracks = {24, 0, 16, 8, 50, 32}
music_tack_colors = {9, 14, 12, 14, 3, 0}
music_index = 1

function _init()
	printh("GAME INIT", log_file, true)
	palt(13, true) -- Transparent Color Is Purple (13)
	palt(0, false)
	load_stage(0)
	music(music_tracks[music_index])
	init_rain()
end

function _update()
 	if stage == 0 then
  		update_start()
	elseif stage_trans then
  		update_stage_trans()
 	else
		-- Initial delay before spawning enemies for this stage
		if stages[stage].enemy_spawn_initial_delay and 
			stages[stage].enemy_spawn_initial_delay_count <  stages[stage].enemy_spawn_initial_delay then
			
			stages[stage].enemy_spawn_initial_delay_count += 1
		elseif stages[stage].enemy_spawn_count > enemey_spawn_stage_count then
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
 
	if not coop then
		update_p2()
	end

	center_camera_on_players()
	update_enemies()
	update_player_anims(p1)
	update_player_anims(p2)

	if p1.weapon_delay > 0 then
		p1.weapon_delay -= 1
	end

	if p2.weapon_delay > 0 then
		p2.weapon_delay -= 1
	end
end

function _draw()
	cls()
	
	if intro then
		say(60, 50, intro_text, 0, true, false, 7, 0)
		intro_text = sub(intro_text_full, 1, intro_count) 
		intro_count += 1

		if intro_count < #intro_text_full then
			sfx(3)
		end
		
		run_intro()
	else
		map(0,0)
		if stage == 0 then
			draw_start()
			say(58,22,"cOPS yEET zOMBIES ii ", 0, true)
		else
			say(88, 22, "da club", 0, false, false, 9, 2)
			say(113 * 8, 6 * 8, "police", 0, false, false, 0, 7)
			if stage == 16 and stage_trans == false then
				ending_dialog()
			end

			if not stage_trans and stage > 1 then
				if displaying_weapons then
					draw_gun_shelf()

					if displaying_weapons_delay > displaying_weapons_count then
						displaying_weapons_count += 1
					else
						displaying_weapons = false
						displaying_weapons_count = 0
					end
				end

				if switching_music then
					if switching_music_delay > switching_music_count then
						switching_music_count += 1
					else
						switching_music_count = 0
						switching_music = false
					end
				end
				draw_floor()
				draw_kill_count()
			end
		end

		local s = stages[stage]
		if not s then
			s = stages[1]
		end
	
		camera(camera_x,camera_y)
		if camera_shake_offset < 0 then
			camera_shake_offset += 1
			camera_x += 1
		elseif camera_shake_offset > 0 then
			camera_shake_offset -= 1
			camera_x -= 1
		end

		draw_dj_booth_song_color()
		draw_extras(true)
		draw_particles(particles)

		draw_enemies()
		
		draw_player_weapon(p2)
		draw_player(p2)
		local p2_disp = "cp"
		if coop then
			p2_disp = "p2"
		end
		print(p2_disp, p2.x - 3, p2.y - 7, 12)

		-- Draw player 1 after player 2 so that player 1 is in front of player 2
		draw_player_weapon(p1)
		draw_player(p1)
		print("p1", p1.x - 3, p1.y - 7, 8)

		draw_extras()

		draw_rain()
		-- draw_rain_indoor()

		if stage_trans then
			draw_trans_dialog() 
		end
	end
end