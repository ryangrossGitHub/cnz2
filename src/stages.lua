stage = 0
stage_trans = false
stage_transfer_count = 0
stage_transfer_total = 128 -- stage trans total 
camera_x = 0
camera_y = 0

function switch_to_level(lvl)
  if lvl == 2 then
    memcpy(0x1800, 0x8800, 0x0800) -- Sprites
    memcpy(0x2000, 0x9000, 0x1000) -- Map
    memcpy(0x3448, 0xA000, 0x02A0) -- SFX
    memcpy(0x3100, 0xA2A0, 0x0084) -- Music
  elseif lvl == 3 then
    memcpy(0x1800, 0xA324, 0x0800) -- Sprites
    memcpy(0x2000, 0xAB24, 0x1000) -- Map
    memcpy(0x3448, 0xBB24, 0x02A0) -- SFX
    memcpy(0x3100, 0xBDC4, 0x0084) -- Music
  elseif lvl == 4 then
    memcpy(0x1800, 0xBE48, 0x0800) -- Sprites
    memcpy(0x2000, 0xC648, 0x1000) -- Map
    memcpy(0x3448, 0xD648, 0x02A0) -- SFX
    memcpy(0x3100, 0xD8E8, 0x0084) -- Music
  elseif lvl == 5 then
    memcpy(0x1800, 0xD96C, 0x0800) -- Sprites
    memcpy(0x2000, 0xE16C, 0x1000) -- Map
    memcpy(0x3448, 0xF16C, 0x02A0) -- SFX
    memcpy(0x3100, 0xF40C, 0x0084) -- Music
  end
end



stages = {
  { -- 1 DONUTS
    enemy_spawn_count = 50,
    enemy_speed = 0.3,
    enemy_spawn_delay = 10
  },
  { -- 2 COFFEE
    enemy_spawn_count = 50,
    enemy_speed = 0.3,
    enemy_spawn_delay = 9
  },
  { -- 3 PARKING
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 8,
    enemy_wall_spawn_range = {{ 5, 10 }} 
  },
  { -- 4 ICE CREAM TRUCK
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 7
  },
  { -- 5 PARK
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 6
  },
  { -- 6 WATER PLANT SIGN
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 6
  },
  { -- 7 WATER PLANT FENCE
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 5
  },
  { -- 8 WATER PLANT BUILDING
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 5
  },
  { -- 9 INSIDE
    enemy_spawn_count = 60,
    enemy_speed = 0.5,
    enemy_spawn_delay = 5
  },
  { -- 10 PIPES
    enemy_spawn_count = 60,
    enemy_speed = 0.5,
    enemy_spawn_delay = 5
  },
  { -- 11 LEAKING PIPES
    enemy_spawn_count = 60,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4
  },
  { -- 12 CONTAINERS
    enemy_spawn_count = 70,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4
  },
  { -- 13 CONTAINERS WITH DOOR
    enemy_spawn_count = 90,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4,
    enemy_wall_spawn_range = {{ 11, 12}} 
  },
  { -- 14 DOUBLE WALL OPENINGS
    enemy_spawn_count = 150,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4,
    enemy_wall_spawn_range = {{ 1, 5 }, { 10, 14 }} 
  },
  { -- 15 FINAL STAGE
    enemy_spawn_count = 300,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4,
    enemy_wall_spawn_range = {{ 0, 1 }, { 13, 14 }} 
  },
  { -- 16 BOSS
    enemy_spawn_count = 2,
    enemy_speed = 0.3
  }
}

function load_stage(n)
  stage = n
  
  if n == 0 then
    load_start()
  elseif n == 1 then
    load("cnz2s3.p8")
    e_spawn = true
    player_move = true
  else
    enemey_spawn_stage_count = 0
    
    -- 8 to 9 is transition inside
    if n == 9 then
      j.y = screen_size + init_player_y
      c.y = screen_size + init_player_y-16
      j.x = 16
      c.x = 16
      camera_y = screen_size
      camera_x = 0
      e_spawn = true
      player_move = true
    else
      stage_trans = true
      e_spawn = false
      player_move = false
      j.flip_sprite = false
      c.flip_sprite = false
    end
  end
end

function update_stage_trans()
  if stage_transfer_count < stage_transfer_total then
    stage_transfer_count += 1
    j.x += 1
    c.x += 1
    camera_x += 1
  else
    stage_trans = false
    enemies = {} -- clear
    if stage < 16 then
      stage_transfer_count = 0
      e_spawn = true
      player_move = true
    end
  end
end

function load_start()
  player_move = false
  e_spawn = false
  camera_x = 0
  camera_y = 0
  j.y = init_player_y
  c.y = init_player_y
  j.x = init_jenn_x
  c.x = init_chad_x
end

function update_start()
  if btnp(0) or btnp(1) then
    if p1.name == "jenn" then
      p1 = c
      p2 = j
    else
      p1 = j
      p2 = c
    end
  end
 
 if btnp(2) or btnp(3) then
    if coop then
      coop = false
    else 
      coop = true
    end
 end
 
  if btnp(4) or btnp(5) then
    load_stage(1)
    printh("GAME START", log_file)
  end
end

function draw_start()
  rect(p1.x - 3, p1.y - 1, p1.x + 16, p1.y + 16, 8)
  
  if coop then
	  rect(p2.x - 3, p2.y - 1, p2.x + 16, p2.y + 16, 12)
  end
  
  say(58,63, "⬆️    ONE PLAYER", 0, true)
  say(58,73, "⬇️    TWO PLAYERS", 0, true)  
  say(58,110, "⬅️   JENN CHAD    ➡️", 0, true)
  say(58,120, "PRESS ❎/🅾️ TO START", 0, true)
end