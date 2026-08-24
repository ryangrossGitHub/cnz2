player_move = false

init_jenn_x = 45
init_chad_x = 67
init_player_y = 80

j = {
	name = "jenn",
	sprite = {34,32}, -- spr in animation
	sprite_index = 1, -- animation frame index
	sprite_melee = 40, -- spr melee
	sprites_fire = {38,36},
	melee = false, -- meleeing
	melee_frame_count = 0, -- melee frame count
	melee_frame_delay = 5, -- melee frame delay
	flip_sprite = true, -- flip sprite?
	x = init_jenn_x, -- position
	y = init_player_y, -- position
	last_animation_frame_x = init_jenn_x, -- last anima frame x
	last_animation_frame_y = init_player_y, -- last anima frame y
	animation_frame_delay = 5, -- anima frame delay
	weapon = 0, -- weapon: 0 pistol, 1 shotgun
	weapon_delay = 2,
	trigger = false -- trigger pressed,
}

c = {
	name = "chad",
	sprite = {2,0}, -- spr in animation
	sprite_index = 1, -- animation frame index
	sprite_melee = 42, -- spr melee
	sprites_fire = {6,4},
	melee = false, -- meleeing
	melee_frame_count = 0, -- melee frame count
	melee_frame_delay = 5, -- melee frame delay
	flip_sprite = false, -- flip sprite?
	x = init_chad_x, -- position
	y = init_player_y, -- position
	last_animation_frame_x = init_chad_x, -- last anima frame x
	last_animation_frame_y = init_player_y, -- last anima frame y
	animation_frame_delay = 5, -- anima frame delay
	weapon = 0, -- weapon: 0 pistol, 1 shotgun
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
	delay = 15,
	cnt = 0
}

pistol = {
	delay = 2,
	cnt = 0
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
			sfx(0)
			enemy_coll_detect(p2)
		end
	elseif p2.weapon == 1 then
		if p2.weapon_delay == 0 then
			p2.weapon_delay = shotgun.delay
			sfx(1)
			enemy_coll_detect(p2)
		end
	end
end

function update_player_anims(p)
 	if abs(p.x - p.last_animation_frame_x) > p.animation_frame_delay or abs(p.y - p.last_animation_frame_y) > p.animation_frame_delay then
  		p.last_animation_frame_x = p.x
  		p.last_animation_frame_y = p.y
  
  		-- get next animation frame
  		p.sprite_index=(p.sprite_index % #p.sprite) + 1
 	end
 
 	enemy_collision(p)
end

function draw_boss(armed)
 	if armed then
	 	spr(36,boss.x,boss.y,2,2,false,false)
 	else
  		spr(38,boss.x,boss.y,2,2,false,false)
 	end
end

function enemy_collision(p)
	for e in all(enemies) do
		if not e.dead and not e.yeeted and e.x > p.x-8 and  e.x < p.x+8 and e.y > p.y-8 and e.y < p.y+8 then
			p.melee = true
			e.yeeted = true
			e.yeet_sprite_flip = p.flip_sprite
		end
	end 
end

function get_player_sprite(p)
 	local player_sprite = p.sprite[p.sprite_index]
 	if p.melee then
 		player_sprite = p.sprite_melee -- melee spr
 		p.melee_frame_count += 1
 	
 		say(p.x,p.y, "YEEEEEET!")
 	
		if p.melee_frame_count >= p.melee_frame_delay then
			p.melee_frame_count = 0
			p.melee = false
		end
 	elseif p.weapon_delay > 0 then
 		player_sprite = p.sprites_fire[p.sprite_index]
 	end
 
 	return player_sprite
end

function update_player_move(p, ctrl)
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
		if not p.trigger and not p.melee then
			if p.weapon == 0 then
				if p.weapon_delay == 0 then
					p.weapon_delay = pistol.delay
					sfx(0)
					enemy_coll_detect(p)
				end
			elseif p.weapon == 1 then
				if p.weapon_delay == 0 then
					p.weapon_delay = shotgun.delay
					sfx(1)
					enemy_coll_detect(p)
				end
			end
		end
  		
		p.trigger = true
 	else
  		p.trigger = false
 	end
end