enemies = {}

e_spawn = false
enemey_spawn_stage_count = 0 -- stage cnt
enemy_spawn_delay_count = 0 

function spawn_enemy(speed)
	enemy = {
		sprite_number = 128,
		speed = speed, -- movement speed
		sprite_flip = true,
		x = rnd({ camera_x-16, camera_x + screen_size + 16 }),
		y = rnd(48) + flr(stage/9) * screen_size + 48,
		death_animation_frame_delay = 20,
		death_animation_frame_count = 0, -- death animation frame count
		dead = false,
		animation_frame_delay = 7, -- animation frame delay
		animation_frame_count = 0,
		yeeted = false,
		yeet_sprite = 136,
		yeet_sprite_flip = false, --flip of yeeting player
		yeet_animation_frame_delay = 5,
		yeet_animation_frame_count = 0
	}
	
	-- if wall spawn support then 25% chance of wall spawn
	if stages[stage].enemy_wall_spawn_range and rnd() < 0.25 then
	 	local r = 1 + flr(rnd(#stages[stage].enemy_wall_spawn_range)) -- which wall opening
	 	local xr = stages[stage].enemy_wall_spawn_range[r] -- get range and index r
	 	local xs = xr[1] + rnd(xr[2] - xr[1]) -- choose spawn point in range

  		enemy.x = xs * 8 + camera_x
  		enemy.y = flr(stage/9) * screen_size + 42
	end
	
	add(enemies, enemy)
end

function update_enemies()
	for enemy in all(enemies) do
		if enemy.dead then
			enemy.death_animation_frame_count += 1
		
			if enemy.death_animation_frame_count >= enemy.death_animation_frame_delay then
				enemy.death_animation_frame_count = 0
			
				if enemy.sprite_number == 134 then
					enemy.sprite_number = 168
				end
			end
		elseif enemy.yeeted then
			yeet(enemy)
		else
			if p1.x < enemy.x - enemy.speed then
				enemy.x -= enemy.speed
				enemy.sprite_flip = false
			elseif p1.x > enemy.x + enemy.speed then
				enemy.x += enemy.speed
				enemy.sprite_flip = true
			end
		
			-- walk to middle before down
			if abs(p1.x-enemy.x) < 2 then
				if p1.y < enemy.y - enemy.speed then
					enemy.y -= enemy.speed
				elseif p1.y > enemy.y + enemy.speed then
					enemy.y += enemy.speed
				end
			end
		
			enemy.animation_frame_count += 1
		
			if enemy.animation_frame_count >= enemy.animation_frame_delay then
				enemy.animation_frame_count = 0
				
				-- enemy animation
				if enemy.sprite_number == 128 then
					enemy.sprite_number = 130
				elseif enemy.sprite_number == 130 then
					enemy.sprite_number = 128
				end
			end 
		end
	end
end

function draw_enemies()
	for enemy in all(enemies) do
		if enemy.sprite_number == -1 then
			-- shotgun death, don't draw
		elseif enemy.sprite_number == 136 then
			-- wide instead of tall sprite
			spr(enemy.sprite_number, enemy.x, enemy.y, 4, 2, enemy.sprite_flip, false)
		elseif enemy.sprite_number == 168 then
			-- wide instead of tall sprite and need to lower it
			spr(enemy.sprite_number, enemy.x, enemy.y + 16, 4, 2, enemy.sprite_flip, false)
		else
			spr(enemy.sprite_number, enemy.x, enemy.y, 2, 4, enemy.sprite_flip, false)
		end
	end
end

function enemy_coll_detect(player) 
	local hbox = 8 -- hit box
 
	if player.weapon == 1 then
		hbox = 16
	end
 
	for enemy in all(enemies) do
		if not enemy.dead and not enemy.yeeted
		and ((enemy.x - 2 < player.x and player.flip_sprite) or (enemy.x + 2 > player.x and not player.flip_sprite)) 
		and (enemy.y > player.y - hbox + 12 and enemy.y < player.y + hbox + 8) then
			enemy_die(enemy, player.weapon, player.flip_sprite, false)
			return -- 1 at a time
		end
	end
end

function enemy_die(enemy, weapon, flip, rotate)
 	enemy.dead = true
	enemy.yeet = false

	if weapon == 0 then
		enemy.sprite_number = 134
	elseif weapon == 1 then
		enemy.sprite_number = -1
	end
   
	local particle_count = 10

	if weapon == 1 then
		particle_count = 50
	end

	for i=1,particle_count do
		local xs = rnd(6)
		if flip then
			xs = -xs
		end
		local ys = rnd(4 - -4) + -4
		local color = rnd({3, 11})

		if rotate and flip then
			add(particles, particle(enemy.x+20, enemy.y, xs, ys, color, 7))
		else
			add(particles, particle(enemy.x+4, enemy.y, xs, ys, color, 7))
		end
	end
end

function yeet(enemy)
	if enemy.x < camera_x or enemy.x > camera_x + screen_size - 32 then
		enemy_die(enemy, 1, not enemy.sprite_flip, true)
		sfx(0)
	else
		if enemy.yeet_animation_frame_count < enemy.yeet_animation_frame_delay * 0.5 then
			-- pickup animation
			enemy.sprite_number = enemy.yeet_sprite
			if enemy.yeet_sprite_flip then
				enemy.x += 3
				enemy.sprite_flip = true
			else
				enemy.x -= 3
				enemy.sprite_flip = false
			end
		else
			if enemy.yeet_sprite_flip then
				enemy.x -= 15
			else
				enemy.x += 15
			end
		end

		enemy.yeet_animation_frame_count += 1
	end
end