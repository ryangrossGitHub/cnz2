player_move = false

init_jenn_x = 45
init_chad_x = 67
init_player_y = 64

camera_shake_offset = 0
camera_shake_offset_amount = 1

bot_nerf_multiplier = 1.5 

weapon_count = 7

j = {
	name = "jenn",
	sprites = {
		head = 2,
		torso = 34,
		legs_standing = 48,
		legs_moving = 50,
		arm_out = 38,
		arm_up = 3
	},
	yeet_frame_count = 0, 
	yeet_frame_delay = 10,
	flip_sprite = true, 
	x = init_jenn_x, 
	y = init_player_y, 
	last_animation_frame_x = init_jenn_x, 
	last_animation_frame_y = init_player_y, 
	animation_frame_delay = 5, 
	weapon = 0, -- weapon: 0 pistol, 1 shotgun, 2 oozie
	weapon_delay = 0,
	trigger = false, -- trigger pressed,
	kill_count = 0,
	stepping = true, -- movement sprite
	yeeting = false,
	recoil = false -- arm movement when firing
}

c = {
	name = "chad",
	sprites = {
		head = 0,
		torso = 32,
		legs_standing = 48,
		legs_moving = 50,
		arm_out = 22,
		arm_up = 33
	},
	yeet_frame_count = 0, 
	yeet_frame_delay = 10, 
	flip_sprite = false, 
	x = init_chad_x,
	y = init_player_y, 
	last_animation_frame_x = init_chad_x, 
	last_animation_frame_y = init_player_y, 
	animation_frame_delay = 5, 
	weapon = 0, -- weapon: 0 pistol, 1 shotgun, 2 oozie, 3 burst rifle, 4 auto rifle, 5 hunting rifle, 6 revolver, 7 long shotgun
	weapon_delay = 0,
	trigger = false, -- trigger pressed
	kill_count = 0,
	stepping = true, -- movement sprite
	yeeting = false,
	recoil = false -- arm movement when firing
}

boss = {
	x = 992,
	y = 216
}

p1 = j
p2 = c
coop = false

shotgun = {
	delay = 10,
	damage = 10
}

long_shotgun = {
	delay = 20,
	damage = 20
}

pistol = {
	delay = 5,
	damage = 2
}

oozie = {
	delay = 0,
	damage = 2
}

burst_rifle = {
	delay = 3,
	damage = 2
}

auto_rifle = {
	delay = 0,
	damage = 3
}

hunting_rifle = {
	delay = 20,
	damage = 10
}

revolver = {
	delay = 10,
	damage = 10
}

function update_p2()
	enemy_collision(p2)

	-- Ensure player gets first shots
	if p1.kill_count < 5 then
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

		handle_player_trigger(p2)
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

	local player_weapon_offset = 12

	local hbox = 4 -- hit box
	if p2.weapon == 1 or p2.weapon == 2 or p2.weapon == 7 then
		hbox = 8
	end
 
	for e in all(enemies) do
		if not e.dead and e.x > camera_x + 5 and e.x < camera_x + screen_size - 5 then
			-- if left or right then fire at closest enemy
			-- else calculate whether there are more enemies above or below to dictate y movement
			if (e.y > p2.y + player_weapon_offset - hbox and e.y < p2.y + player_weapon_offset + hbox) then
				local dir = e.x - p2.x
				local dif = abs(dir)
				if dif < closest then
					closest = dif
					c_xdir = dir
				end
			elseif e.y < p2.y + player_weapon_offset then
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

function update_player_anims(p)
	-- leg movement
 	if abs(p.x - p.last_animation_frame_x) > p.animation_frame_delay or abs(p.y - p.last_animation_frame_y) > p.animation_frame_delay then
  		p.last_animation_frame_x = p.x
  		p.last_animation_frame_y = p.y
  
  		-- get next animation frame
  		if p.stepping then
  			p.stepping = false
  		else
			p.stepping = true
		end
 	end
 
 	enemy_collision(p)

	-- yeet
	if p.yeeting then
 		p.yeet_frame_count += 1
 	
 		say(p.x,p.y, "YEEEEEET!")
 	
		if p.yeet_frame_count >= p.yeet_frame_delay then
			p.yeet_frame_count = 0
			p.yeeting = false
		end
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
	if p.yeeting then
		return -- early exit
	end
	
	for e in all(enemies) do
		if not e.dead and not e.yeeted and e.x > p.x-8 and  e.x < p.x+8 and e.y > p.y-8 and e.y < p.y+8 then
			p.yeeting = true
			e.yeeted = true
			e.yeet_sprite_flip = p.flip_sprite
			p.kill_count += 1
		end
	end 
end

function update_player_move(p, ctrl)
	if p.yeeting then
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
 
	if btn(2, ctrl) and p.y > flr(stage/9) * screen_size + 26 then
		p.y -= 1
	elseif btn(3, ctrl) and p.y < flr(stage/9) * screen_size + 96 then
		p.y += 1
	end
 
	if btn(🅾️, ctrl) then
		handle_player_trigger(p)
		p.trigger = true
 	else
  		p.trigger = false
 	end
	
	if btnp(❎, ctrl) then
		p.weapon += 1
		if p.weapon > weapon_count then
			p.weapon = 0
		end
	end

	if p.weapon == 3 and p.weapon_delay > 0 then
		handle_player_fire(p)
	end
end

function draw_kill_count()
	spr(j.sprites.head, camera_x + 5, camera_y + 3, 1, 2, false, false)
	print(j.kill_count, camera_x + 16, camera_y + 8, 11)
	spr(c.sprites.head, camera_x + screen_size - 20, camera_y + 3, 2, 2, true, false)
	print(c.kill_count, camera_x + screen_size - 27, camera_y + 8, 11)
end

function handle_player_fire(p)
	p.recoil = true
	if p.weapon == 0 or p.weapon == 3 or p.weapon == 5 or p.weapon == 6 then
		if p.weapon == 0 then
			sfx(0)
		elseif p.weapon == 3 then
			sfx(4)
		elseif p.weapon == 5 or p.weapon == 6 then
			sfx(5)

			if p.flip_sprite then
				p.x += 3
			else
				p.x -= 3
			end

			if p.flip_sprite then
				camera_x -= camera_shake_offset_amount
				camera_shake_offset -= camera_shake_offset_amount
			else
				camera_x += camera_shake_offset_amount
				camera_shake_offset += camera_shake_offset_amount
			end
		end

		enemy_coll_detect(p)

		local xs = 15
		if p.flip_sprite then
			xs = -xs
		end
		add(particles, particle(p.x+4, p.y + 15, xs, 0, 0, 7))
	elseif p.weapon == 1 or p.weapon == 7 then
		if p.flip_sprite then
			p.x += 3
		else
			p.x -= 3
		end

		sfx(1)

		for i=1,10 do
			local ys = rnd(1 - -1) + -1
			local xs = 12 + rnd(3)
			if p.flip_sprite then
				xs = -xs
			end
			add(particles, particle(p.x+4, p.y + 15, xs, ys, 0, 14))
		end

		if p.flip_sprite then
			camera_x -= camera_shake_offset_amount
			camera_shake_offset -= camera_shake_offset_amount
		else
			camera_x += camera_shake_offset_amount
			camera_shake_offset += camera_shake_offset_amount
		end
	elseif p.weapon == 2 or p.weapon == 4 then
		if p.weapon == 2 then
			sfx(0)
		elseif p.weapon == 4 then
			sfx(4)
		end
		
		local ys = rnd(0.5 - -0.5) + -0.5
		local xs = 14 + rnd(1)
		if p.flip_sprite then
			xs = -xs
		end
		add(particles, particle(p.x+4, p.y + 15, xs, ys, 0, 14))
	end
	enemy_coll_detect(p)
end

function draw_player_weapon(p)
	if p.yeeting then
		return -- early exit
	end

	local recoil_mult = 0

	if p.recoil then
		recoil_mult = 2
	end

	if p.weapon == 0 then
		if p.flip_sprite then
			spr(4, p.x - 1 + recoil_mult, p.y + 12, 1, 1, true, false)
		else
			spr(4, p.x + 9 - recoil_mult, p.y + 12, 1, 1, false, false)
		end
	elseif p.weapon == 1 then
		if p.flip_sprite then
			spr(20, p.x - 2 + recoil_mult, p.y + 11, 1, 1, true, false)
		else
			spr(20, p.x + 10 - recoil_mult, p.y + 11, 1, 1, false, false)
		end
	elseif p.weapon == 2 then
		if p.flip_sprite then
			spr(5, p.x - 1 + recoil_mult, p.y + 12, 1, 1, true, false)
		else
			spr(5, p.x + 9 - recoil_mult, p.y + 12, 1, 1, false, false)
		end
	elseif p.weapon == 3 then
		if p.flip_sprite then
			spr(36, p.x - 8 + recoil_mult, p.y + 11, 2, 1, true, false)
		else
			spr(36, p.x + 8 - recoil_mult, p.y + 11, 2, 1, false, false)
		end
	elseif p.weapon == 4 then
		if p.flip_sprite then
			spr(7, p.x + recoil_mult, p.y + 11, 1, 1, true, false)
		else
			spr(7, p.x + 8 - recoil_mult, p.y + 11, 1, 1, false, false)
		end
	elseif p.weapon == 5 then
		if p.flip_sprite then
			spr(52, p.x - 8 + recoil_mult, p.y + 12, 2, 1, true, false)
		else
			spr(52, p.x + 8 - recoil_mult, p.y + 12, 2, 1, false, false)
		end
	elseif p.weapon == 6 then
		if p.flip_sprite then
			spr(6, p.x - 3 + recoil_mult, p.y + 11, 1, 1, true, false)
		else
			spr(6, p.x + 11 - recoil_mult, p.y + 11, 1, 1, false, false)
		end
	elseif p.weapon == 7 then
		if p.flip_sprite then
			spr(20, p.x - 8 + recoil_mult, p.y + 11, 2, 1, true, false)
		else
			spr(20, p.x + 10 - recoil_mult, p.y + 11, 2, 1, false, false)
		end
	end
end

function handle_player_trigger(p)
	if not p.yeeting then
		if not p.trigger then
			if p.weapon == 0 and p.weapon_delay == 0 then
				p.weapon_delay = pistol.delay
				handle_player_fire(p)
			elseif p.weapon == 1 and p.weapon_delay == 0 then
				p.weapon_delay = shotgun.delay
				handle_player_fire(p)
			elseif p.weapon == 3 and p.weapon_delay == 0 then
				p.weapon_delay = burst_rifle.delay
				handle_player_fire(p)
			elseif p.weapon == 5 and p.weapon_delay == 0 then
				p.weapon_delay = hunting_rifle.delay
				handle_player_fire(p)
			elseif p.weapon == 6 and p.weapon_delay == 0 then
				p.weapon_delay = revolver.delay
				handle_player_fire(p)
			elseif p.weapon == 7 and p.weapon_delay == 0 then
				p.weapon_delay = long_shotgun.delay
				handle_player_fire(p)
			end
		end

		if p.weapon == 2 or p.weapon == 4 then
			p.weapon_delay = 0
			handle_player_fire(p)
		end
	end
end

function draw_player(p)
	-- head
	if p.name == "chad" then
		spr(p.sprites.head, p.x, p.y, 2, 2, p.flip_sprite, false)
	else
		if p.flip_sprite then
			spr(p.sprites.head, p.x + 8, p.y, 1, 2, p.flip_sprite, false)
		else
			spr(p.sprites.head, p.x, p.y, 1, 2, p.flip_sprite, false)
		end
	end

	local recoil_mult = 0

	if p.recoil then
		recoil_mult = 2
		p.recoil = false
	end

	--torso
	if p.flip_sprite then
		spr(p.sprites.torso, p.x + 7, p.y + 16, 1, 1, p.flip_sprite, false)
	else
		spr(p.sprites.torso, p.x + 1, p.y + 16, 1, 1, p.flip_sprite, false)
	end

	-- arm
	if p.flip_sprite then
		if p.yeeting then
			spr(p.sprites.arm_up, p.x + 5, p.y + 5, 1, 2, p.flip_sprite, false)
		else
			spr(p.sprites.arm_out, p.x - 3 + recoil_mult, p.y + 16, 2, 1, p.flip_sprite, false)
		end
	else
		if p.yeeting then
			spr(p.sprites.arm_up, p.x + 3, p.y + 5, 1, 2, p.flip_sprite, false)
		else
			spr(p.sprites.arm_out, p.x + 3 - recoil_mult, p.y + 16, 2, 1, p.flip_sprite, false)
		end
	end

	if p.stepping then
		spr(p.sprites.legs_moving, p.x, p.y + 24, 2, 1, p.flip_sprite, false)
	else
		if p.flip_sprite then
			spr(p.sprites.legs_standing, p.x + 7, p.y + 24, 1, 1, p.flip_sprite, false)
		else
			spr(p.sprites.legs_standing, p.x + 1, p.y + 24, 1, 1, p.flip_sprite, false)
		end
	end
	
end