player_move = false

init_jenn_x = 45
init_chad_x = 67
init_player_y = 80

camera_shake_offset = 0
camera_shake_offset_amount = 2

j = {
	name = "jenn",
	sprites = {
		stand_pistol = 32,
		move_pistol = 34,
		stand_shoot_pistol = 36,
		move_shoot_pistol = 38,
		stand_shotgun = 40,
		move_shotgun = 42,
		stand_shoot_shotgun = 44,
		move_shoot_shotgun = 46,
		yeet = 96
	},
	sprite = 34, -- intial value
	yeet_frame_count = 0, 
	yeet_frame_delay = 5,
	flip_sprite = true, 
	x = init_jenn_x, 
	y = init_player_y, 
	last_animation_frame_x = init_jenn_x, 
	last_animation_frame_y = init_player_y, 
	animation_frame_delay = 5, 
	weapon = 0, -- weapon: 0 pistol, 1 shotgun
	weapon_delay = 2,
	trigger = false -- trigger pressed,
}

c = {
	name = "chad",
	sprites = {
		stand_pistol = 0,
		move_pistol = 2,
		stand_shoot_pistol = 4,
		move_shoot_pistol = 6,
		stand_shotgun = 8,
		move_shotgun = 10,
		stand_shoot_shotgun = 12,
		move_shoot_shotgun = 14,
		yeet = 64
	},
	sprite = 10, -- intial value
	yeet_frame_count = 0, 
	yeet_frame_delay = 5, 
	flip_sprite = false, 
	x = init_chad_x,
	y = init_player_y, 
	last_animation_frame_x = init_chad_x, 
	last_animation_frame_y = init_player_y, 
	animation_frame_delay = 5, 
	weapon = 1, -- weapon: 0 pistol, 1 shotgun
	weapon_delay = 2,
	trigger = false -- trigger pressed
}

boss = {
	x = 992,
	y = 216
}

p1 = j
p2 = c
coop = false

shotgun = {
	delay = 20
}

pistol = {
	delay = 2
}

function update_p2()
	enemy_collision(p2)

	-- Bot gets better as the game goes on
	if rnd(16) > stage + 1 then
		return -- early exit
	end
	
	local c,y = closest_enemy()
 	if c then
		if c < 0 then
	  		p2.flip_sprite = true	  
	  		if p2.x > camera_x+32 then
	   			p2.x -= 1
	  		end
	 	else
	  		p2.flip_sprite = false	  	  
	  		if p2.x < camera_x+screen_size-32 then
	   			p2.x += 1
	  		end
		end

		p2_fire()
	end
	
	if y < 0 then
		p2.y -= 1
	elseif y > 0 then
	 	p2.y += 1
	end
end

function closest_enemy()
	-- which direction to fire
	local closest = 99
	-- neg = left, pos = right
	local c_xdir = 0

	-- which direction to move
	-- neg = up, pos = down
	local e_ydir = 0

	local hbox = 4 -- hit box

	if p2.weapon == 1 then
		hbox = 12
	end
 
	for e in all(enemies) do
		if not e.dead and e.x > camera_x + 5 and e.x < camera_x + screen_size - 5 then
			-- if left or right then fire at closest enemy
			-- else calculate whether there are more enemies above or below to dictate y movement
			if (e.y > p2.y - hbox and e.y < p2.y + hbox) then
				local dir = e.x - p2.x
				local dif = abs(dir)
				if dif < closest then
					closest = dif
					c_xdir = dir
				end
			elseif e.y < p2.y then
				e_ydir -= 1
			else
				e_ydir += 1
			end
		end
	end
 
	if closest == 99 then -- no enemies in range
		return nil, e_ydir
	else
		return c_xdir, e_ydir
	end
end

function p2_fire()
	if p2.weapon == 0 then
		if p2.weapon_delay == 0 then
			p2.weapon_delay = pistol.delay

			if p2.sprite == p2.sprites.stand_pistol then
				p2.sprite = p2.sprites.stand_shoot_pistol
			elseif p2.sprite == p2.sprites.move_pistol then
				p2.sprite = p2.sprites.move_shoot_pistol
			end

			sfx(0)
			enemy_coll_detect(p2)
		end
	elseif p2.weapon == 1 then
		if p2.weapon_delay == 0 then
			p2.weapon_delay = shotgun.delay

			if p2.sprite == p2.sprites.stand_shotgun then
				p2.sprite = p2.sprites.stand_shoot_shotgun
			elseif p2.sprite == p2.sprites.move_shotgun then
				p2.sprite = p2.sprites.move_shoot_shotgun
			end

			sfx(1)

			if p2.flip_sprite then
				camera_x -= camera_shake_offset_amount
				camera_shake_offset -= camera_shake_offset_amount
			else
				camera_x += camera_shake_offset_amount
				camera_shake_offset += camera_shake_offset_amount
			end

			enemy_coll_detect(p2)
		end
	end
end

function update_player_anims(p)
	-- leg movement
 	if abs(p.x - p.last_animation_frame_x) > p.animation_frame_delay or abs(p.y - p.last_animation_frame_y) > p.animation_frame_delay then
  		p.last_animation_frame_x = p.x
  		p.last_animation_frame_y = p.y
  
  		-- get next animation frame
  		if p.sprite == p.sprites.move_pistol then
  			p.sprite = p.sprites.stand_pistol
  		elseif p.sprite == p.sprites.stand_pistol then
			p.sprite = p.sprites.move_pistol
		elseif p.sprite == p.sprites.move_shotgun then
  			p.sprite = p.sprites.stand_shotgun
  		elseif p.sprite == p.sprites.stand_shotgun then
			p.sprite = p.sprites.move_shotgun
		end
 	end
 
 	enemy_collision(p)

	-- yeet
	if p.sprite == p.sprites.yeet then
 		p.yeet_frame_count += 1
 	
 		say(p.x,p.y, "YEEEEEET!")
 	
		if p.yeet_frame_count >= p.yeet_frame_delay then
			p.yeet_frame_count = 0
			if p.weapon == 0 then
				p.sprite = p.sprites.stand_pistol
			elseif p.weapon == 1 then
				p.sprite = p.sprites.stand_shotgun
			end
		end

	-- weapon recoil
 	elseif p.sprite == p.sprites.stand_shoot_pistol and p.weapon_delay == 0 then
		p.sprite = p.sprites.stand_pistol
	elseif p.sprite == p.sprites.move_shoot_pistol and p.weapon_delay == 0 then
		p.sprite = p.sprites.move_pistol
	elseif p.sprite == p.sprites.stand_shoot_shotgun and p.weapon_delay == 0 then
		p.sprite = p.sprites.stand_shotgun
	elseif p.sprite == p.sprites.move_shoot_shotgun and p.weapon_delay == 0 then
		p.sprite = p.sprites.move_shotgun
 	end
end

function draw_boss(armed)
 	if armed then
	 	spr(36,boss.x,boss.y,2,2,false,false)
 	else
  		spr(38,boss.x,boss.y,2,2,false,false)
 	end
end

function enemy_collision(p)
	if p.sprite == p.sprites.yeet then
		return -- early exit
	end
	
	for e in all(enemies) do
		if not e.dead and not e.yeeted and e.x > p.x-8 and  e.x < p.x+8 and e.y > p.y-8 and e.y < p.y+8 then
			p.sprite = p.sprites.yeet
			e.yeeted = true
			e.yeet_sprite_flip = p.flip_sprite
		end
	end 
end

function update_player_move(p, ctrl)
	if p.sprite == p.sprites.yeet then
		return -- early exit
	end

	-- ctrl is the controller maping
	if btn(0, ctrl) and p.x>camera_x then
		p.x -= 1
		p.flip_sprite = true 
	elseif btn(1, ctrl) and p.x<camera_x + screen_size - 16 then
		p.x += 1
		p.flip_sprite = false
	end
 
	if btn(2, ctrl) and p.y > flr(stage/9) * screen_size + 42 then
		p.y -= 1
	elseif btn(3, ctrl) and p.y < flr(stage/9) * screen_size + 110 then
		p.y += 1
	end
 
	if btn(❎, ctrl) or btn(🅾️, ctrl) then
		if not p.trigger and p.sprite != p.sprites.yeet then
			if p.weapon == 0 then
				if p.weapon_delay == 0 then
					p.weapon_delay = pistol.delay

					if p.sprite == p.sprites.stand_pistol then
						p.sprite = p.sprites.stand_shoot_pistol
					elseif p.sprite == p.sprites.move_pistol then
						p.sprite = p.sprites.move_shoot_pistol
					end

					sfx(0)
					enemy_coll_detect(p)
				end
			elseif p.weapon == 1 then
				if p.weapon_delay == 0 then
					p.weapon_delay = shotgun.delay

					if p.sprite == p.sprites.stand_shotgun then
						p.sprite = p.sprites.stand_shoot_shotgun
					elseif p.sprite == p.sprites.move_shotgun then
						p.sprite = p.sprites.move_shoot_shotgun
					end

					sfx(1)
					enemy_coll_detect(p)

					if p.flip_sprite then
						camera_x -= camera_shake_offset_amount
						camera_shake_offset -= camera_shake_offset_amount
					else
						camera_x += camera_shake_offset_amount
						camera_shake_offset += camera_shake_offset_amount
					end
				end
			end
		end
  		
		p.trigger = true
 	else
  		p.trigger = false
 	end
end