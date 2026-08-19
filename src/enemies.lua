enemies = {}

e_spawn = false
enemey_spawn_stage_count = 0 -- stage cnt
enemy_spawn_delay_count = 0 

function spawn_enemy(speed)
	enemy = {
		sprite_number = 8,
		speed = speed, -- movement speed
		sprite_flip = true,
		x = rnd({ camera_x-16, camera_x + screen_size + 16 }),
		y = rnd(56) + flr(stage/9) * screen_size + 56,
		death_animation_frame_delay = 20,
		death_animation_frame_count = 0, -- death animation frame count
		dead = false,
		animation_frame_delay = 7, -- animation frame delay
		animation_frame_count = 0,
		yeeted = false,
		yeet_sprite_flip = false, --flip of yeeting player
		yeet_frame_count = 0,
		yeet_frame_delay = 5
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
			
				if enemy.sprite_number == 12 then
					enemy.sprite_number = 14
				elseif enemy.sprite_number == 44 then
					enemy.sprite_number = 46
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
				if enemy.sprite_number == 8 then
					enemy.sprite_number = 10
				elseif enemy.sprite_number == 10 then
					enemy.sprite_number = 8
				end
			end 
		end
	end
end

function draw_enemies()
	for enemy in all(enemies) do
		spr(enemy.sprite_number, enemy.x, enemy.y, 2, 2, enemy.sprite_flip, false)
	end
end

function enemy_coll_detect(player) 
	local hbox = 4 -- hit box
 
	if player.weapon == 1 then
		hbox = 12
	end
 
	for enemy in all(enemies) do
		if not enemy.dead 
		and ((enemy.x - 2 < player.x and player.flip_sprite) or (enemy.x + 2 > player.x and not player.flip_sprite)) 
		and (enemy.y > player.y - hbox and enemy.y < player.y + hbox + 2) then
			enemy_die(enemy, player)

			if player.weapon == 0 then
				return -- pistol hits 1 at a time
			end
		end
	end
end

function enemy_die(enemy, player)
 	enemy.dead = true
   
	for i=1,20 do
 		local xs = rnd(3 - 0) + 0
  		local ys = rnd(1 - -1) + -1
  		add(particles, particle(enemy.x+4, enemy.y, xs, ys, 3, 10))
 	end

 	if player.weapon == 1 or player.melee then
  		enemy.sprite_number = 46
 	elseif player.weapon == 0 then
  		enemy.sprite_number = 12
 	end
end

function yeet(enemy)
	if enemy.yeet_frame_count < enemy.yeet_frame_delay then
  		enemy.yeet_frame_count += 1		
	
		if enemy.yeet_sprite_flip then
			enemy.x -= 3
		else
			enemy.x += 3
		end
	else
	 	enemy.yeeted = false
	 	enemy.yeet_frame_count = 0
	end
end