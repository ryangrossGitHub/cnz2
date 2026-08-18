p_move = false

init_j_x = 45
init_c_x = 67
init_y = 80

j = {
 name="j",
 s={34,32}, -- spr in animation
 si=1, -- animation frame index
 sm=40, -- spr melee
 m=false, -- meleeing
 mfc=0, -- melee frame count
 mfd=5, -- melee frame delay
 f=true, -- flip sprite?
 x=init_j_x, -- position
 y=init_y, -- position
 lafx=init_j_x, -- last anima frame x
 lafy=init_y, -- last anima frame y
 afd=5, -- anima frame delay
 wpn=0, -- weapon: 0 pistol, 1 shotgun
 trigger=false -- trigger pressed
}

c = {
 name="c",
 s={2,0}, -- spr in animation
 si=1, -- animation frame index
 sm=42, -- spr melee
 m=false, -- meleeing
 mfc=0, -- melee frame count
 mfd=5, -- melee frame delay
 f=false, -- flip sprite?
 x=init_c_x, -- position
 y=init_y, -- position
 lafx=init_c_x, -- last anima frame x
 lafy=init_y, -- last anima frame y
 afd=5, -- anima frame delay
 wpn=0, -- weapon: 0 pistol, 1 shotgun
 trigger=false -- trigger pressed
}

boss={
 x=992,
 y=216
}

p1=j
p2=c
coop=false

sgun = { -- shotgun
 delay=30,
 cnt=0
}

pstol = { -- pistol
 delay=2,
 cnt=0
}

function update_p2()
 local c,y = closest_enemy()
 if c then
	 if c < 0 then
	  p2.f = true
	  
	  if p2.x > camera_x+32 then
	   p2.x -= 1
	  end
	 else
	  p2.f = false
	  	  
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
	
	enemy_collision(p2)
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
 
 if p2.wpn == 1 then
  hbox = 12
 end
 
 for e in all(enemies) do
  if not e.dead and 
   e.x > camera_x+5 and
   e.x < camera_x+screen_size-5
   then
   -- if left or right then
   -- fire at closest enemy
   -- otherwise calculate
   -- whether there are more
   -- enemies above or below
   -- to dictate y movement
   
   if (e.y > p2.y-hbox 
    and e.y < p2.y+hbox) 
    then
      
	   local dir = e.x-p2.x
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
 
 if closest == 99 then
  -- no enemies in range
  return nil, e_ydir
 else
  return c_xdir, e_ydir
 end
end

function p2_fire()
 if p2.wpn == 0 then
  if pstol.cnt == 0 then
   pstol.cnt = pstol.delay
  	sfx(0)
  	enemy_coll_detect(p2)
  end
 elseif p2.wpn == 1 then
  if sgun.cnt == 0 then
   sgun.cnt = sgun.delay
   sfx(1)
   enemy_coll_detect(p2)
  end
 end
end

function update_player_anims(p)
 if abs(p.x - p.lafx) 
  > p.afd or 
  abs(p.y - p.lafy) 
  > p.afd then

  p.lafx = p.x
  p.lafy = p.y
  
  -- get next animation frame
  p.si=(p.si % #p.s) + 1
 end
 
 enemy_collision(p)
end

function draw_boss(armed)
 if armed then
	 spr(36,boss.x,boss.y,
  	2,2,false,false)
 else
  spr(38,boss.x,boss.y,
  	2,2,false,false)
 end
end

function enemy_collision(p)
 for e in all(enemies) do
  if not e.dead and
   not e.yeeted and
   e.x > p.x-8 and 
   e.x < p.x+8 and
   e.y > p.y-8 and 
   e.y < p.y+8 then
   p.m = true
   e.yeeted=true
   e.yeet_sprite_flip = p.f
   sfx(0)
  end
 end 
end

function get_pspr(p)
 local ps = p.s[p.si]
 if p.m then
 	ps = p.sm -- melee spr
 	p.mfc += 1
 	
 	say(p.x,p.y, "YEEEEEET!")
 	
 	if p.mfc >= p.mfd then
 		p.mfc = 0
 		p.m = false
 	end
 end
 
 return ps
end

function update_p_move(p,ctrl)
 -- ctrl is the controller maping
 if btn(0,ctrl) and 
 	p.x>camera_x  then
  p.x -= 1
  p.f = true 
 elseif btn(1,ctrl) 
 	and p.x<camera_x + 
	 screen_size - 16 then
	  p.x += 1
	  p.f = false
 end
 
 if btn(2,ctrl) and p.y > 
  flr(stage/9)*screen_size+42 then
  p.y -= 1
 elseif btn(3,ctrl) and p.y < 
  flr(stage/9)*screen_size+110 then
  p.y += 1
 end
 
 if btn(❎,ctrl) or 
  btn(🅾️,ctrl) then
  if not p.trigger then
 	 if p.wpn == 0 then
 	  if pstol.cnt == 0 then
 	   pstol.cnt = pstol.delay
 	  	sfx(0)
 	  	enemy_coll_detect(p)
 	  end
 	 elseif p.wpn == 1 then
 	  if sgun.cnt == 0 then
 	   sgun.cnt = sgun.delay
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