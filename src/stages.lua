stage = 0
stage_trans = false
stage_transfer_count = 0
stage_transfer_total = 161 -- stage trans total 
camera_x = 0
camera_y = 0
intro_count = 0
intro_time = 60 * 5 -- 7 seconds
intro = false
floor_color_transition = 20
floor_color_delay = 300
floor_color_count = 0
floor_color = 9
wall_height = 56
map_width = 8
map_height = 2

rain = {}
rain_indoor = {}


stages = {
  { -- 1 Club entrance
    enemy_spawn_count = 0,
    enemy_speed = 0.5,
    enemy_spawn_delay = 20,
    music_track = 24,
    weapon_unlock = 1
  },
  { -- 2 Bar floor 1
    enemy_spawn_count = 500,
    enemy_speed = 0.4,
    enemy_spawn_delay = 20,
    enemy_spawn_initial_delay = 30,
    enemy_spawn_initial_delay_count = 0,
    music_track = 24,
    weapon_unlock = 1
  },
  { -- 3 Bar floor 2
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 8,
    music_track = 16,
    weapon_unlock = 7
  },
  { -- 4 Bar floor 3
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 7,
    music_track = 16,
    weapon_unlock = 7
  },
  { -- 5 Bar roof (floor 4)
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 6,
    music_track = 0,
    weapon_unlock = 3
  },
  { -- 6 elevator
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 6,
    music_track = 0,
    weapon_unlock = 3
  },
  { -- 7 street
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 5,
    music_track = 0,
    weapon_unlock = 3
  },
  { -- 8 train station
    enemy_spawn_count = 50,
    enemy_speed = 0.4,
    enemy_spawn_delay = 5,
    music_track = -1,
    weapon_unlock = 6
  },
  { -- 9 train
    enemy_spawn_count = 60,
    enemy_speed = 0.5,
    enemy_spawn_delay = 5,
    music_track = 32,
    weapon_unlock = 1
  },
  { -- 10 train top
    enemy_spawn_count = 60,
    enemy_speed = 0.5,
    enemy_spawn_delay = 5,
    music_track = 32,
    weapon_unlock = 1
  },
  { -- 11 street
    enemy_spawn_count = 60,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4,
    music_track = 32,
    weapon_unlock = 2
  },
  { -- 12 bridge
    enemy_spawn_count = 70,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4,
    music_track = 32,
    weapon_unlock = 5
  },
  { -- 13 bridge
    enemy_spawn_count = 90,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4,
    enemy_wall_spawn_range = {{ 11, 12}} ,
    music_track = 32,
    weapon_unlock = 5
  },
  { -- 14 bridge
    enemy_spawn_count = 150,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4,
    enemy_wall_spawn_range = {{ 1, 5 }, { 10, 14 }},
    music_track = 32,
    weapon_unlock = 4
  },
  { -- 15 train
    enemy_spawn_count = 300,
    enemy_speed = 0.5,
    enemy_spawn_delay = 4,
    enemy_wall_spawn_range = {{ 0, 1 }, { 13, 14 }},
    music_track = 32,
    weapon_unlock = 4
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
    e_spawn = true
    player_move = true
  else
    if music_track_index < #music_tracks + 1 then
      music(music_tracks[music_track_index])
      music_track_index += 1
    end

    if weapon_index < #weapon_list + 1 then
      j.weapon = weapon_list[weapon_index]
      c.weapon = weapon_list[weapon_index]
      weapon_index += 1
    end
    enemey_spawn_stage_count = 0
    floor_color_count = 0
    
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
    j.x += 0.8
    c.x += 0.8
    camera_x += 0.8
  else
    stage_trans = false
    enemies = {} -- clear
    particles = {} -- clear
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
    intro = true
    run_intro()
    music(-1)
    printh("GAME START", log_file)
  end
end

function draw_start()
  rect(p1.x - 3, p1.y - 1, p1.x + 16, p1.y + 32, 8)
  
  if coop then
	  rect(p2.x - 3, p2.y - 1, p2.x + 16, p2.y + 32, 12)
  end
  
  say(58,43, "⬆️    ONE PLAYER", 0, true)
  say(58,53, "⬇️    TWO PLAYERS", 0, true)  
  say(58,110, "⬅️   JENN CHAD    ➡️", 0, true)
  say(58,120, "PRESS ❎/🅾️ TO START", 0, true)
end

function run_intro()
  if intro_count > 10 and (btnp(🅾️) or btnp(❎)) then
    intro = false
    load_stage(1)
  end

  if intro_count < intro_time then
    intro_count += 1
  else
    intro = false
    load_stage(1)
  end
end

function draw_floor()
  if floor_color_count >= floor_color_delay then
    floor_color_count = 0
    if floor_color == 9 then
      floor_color = 2
    elseif floor_color == 2 then
      floor_color = 9
    end
  else
    floor_color_count += 1

    local color = 0
    if floor_color_count < floor_color_delay - floor_color_transition then
      color = floor_color
    end

    rectfill(screen_size, wall_height, screen_size * map_width, screen_size * map_height, color)
  end
end

function draw_gun_shelf()
  local upper_left = 19 * 8
  rectfill(upper_left, 0, 29 * 8, 5 * 8, 7)
  spr(20, upper_left + 6, 3, 2, 1)
  spr(36, upper_left + 34, 3, 2, 1)
  spr(52, upper_left + 58, 3, 2, 1)
  spr(4, upper_left + 3, 15)
  spr(6, upper_left + 16, 15)
  spr(5, upper_left + 50, 15)
  spr(7, upper_left + 66, 15)
end

function init_rain()
  for i = 1, 100 do
    add(rain, {
      x = flr(rnd(128)),
      y = flr(rnd(128)),
      spd = 2 + rnd(3)
    })
  end
  for i = 1, 50 do
    add(rain_indoor, {
      x = 0,
      y = 0,
      spd = 3 + rnd(3)
    })
  end
end

function draw_rain()
  -- move each drop down
  for drop in all(rain) do
    drop.y += drop.spd
    drop.x -= 1 -- slight wind angle
    
      if (drop.y > 127) drop.y = -4
      if (drop.x < 0) drop.x = 127
  end

  for drop in all(rain) do
    line(drop.x, drop.y, drop.x - 1, drop.y + 3, 1)
  end
end

function draw_rain_indoor()
  -- move each drop down
  for drop in all(rain_indoor) do
    drop.y += drop.spd
    drop.x -= 1
    
    -- reset at the top/sides
    if (drop.y > camera_y + screen_size) or (drop.x < 0) then
      drop.x = flr(rnd(screen_size + camera_x))
      drop.y = flr(rnd(screen_size + camera_y))
    end
  end


  for drop in all(rain_indoor) do
    line(drop.x, drop.y, drop.x - 1, drop.y + 3, 1)
  end
end