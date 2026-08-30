function load_external_data()
  -- User save data is reserved for 0x8000 - 0x87FF (0x0800 bytes)

  ---------------------------------------------------------
  -- PRELOAD LEVEL 2
  ---------------------------------------------------------
  reload(0x8800, 0x1800, 0x0800, "map2.p8")  -- Sprites (Tab 4)
  reload(0x9000, 0x2000, 0x1000, "map2.p8")  -- Map
  reload(0xA000, 0x3448, 0x02A0, "map2.p8")  -- SFX 20-40
  reload(0xA2A0, 0x3100, 0x0084, "map2.p8")  -- Music 0-32

  ---------------------------------------------------------
  -- PRELOAD LEVEL 3
  ---------------------------------------------------------
  reload(0xA324, 0x1800, 0x0800, "map3.p8")  -- Sprites (Tab 4)
  reload(0xAB24, 0x2000, 0x1000, "map3.p8")  -- Map
  reload(0xBB24, 0x3448, 0x02A0, "map3.p8")  -- SFX 20-40
  reload(0xBDC4, 0x3100, 0x0084, "map3.p8")  -- Music 0-32

  ---------------------------------------------------------
  -- PRELOAD LEVEL 4
  ---------------------------------------------------------
  reload(0xBE48, 0x1800, 0x0800, "map4.p8")  -- Sprites (Tab 4)
  reload(0xC648, 0x2000, 0x1000, "map4.p8")  -- Map
  reload(0xD648, 0x3448, 0x02A0, "map4.p8")  -- SFX 20-40
  reload(0xD8e8, 0x3100, 0x0084, "map4.p8")  -- Music 0-32

  ---------------------------------------------------------
  -- PRELOAD LEVEL 5
  ---------------------------------------------------------
  reload(0xD96C, 0x1800, 0x0800, "map5.p8")  -- Sprites (Tab 4)
  reload(0xE16C, 0x2000, 0x1000, "map5.p8")  -- Map
  reload(0xF16C, 0x3448, 0x02A0, "map5.p8")  -- SFX 20-40
  reload(0xF40C, 0x3100, 0x0084, "map5.p8")  -- Music 0-32

  -- End address used is 0xF490. 
  -- Free space left at the very end: 0xF490 to 0xFFFF (2,928 bytes)

  printh(" external assets loaded successfully", log_file)
end


function swap_sprites(source_data_address, src_index, tgt_index)
  -- 1. Calculate the active RAM target address (0x0000 sprite sheet)
  local tgt_col = tgt_index % 16
  local tgt_row = flr(tgt_index / 16)
  local target_base = (tgt_row * 512) + (tgt_col * 4)
  
  -- 2. Calculate the offset inside the high memory storage
  local src_col = src_index % 16
  local src_row = flr(src_index / 16)
  local source_offset = (src_row * 512) + (src_col * 4)
  
  -- The absolute memory starting point inside your high memory storage
  local source_base = source_data_address + source_offset

  -- 3. Copy the 16x16 sprite row-by-row (16 rows total)
  for row = 0, 15 do
    local active_ram_address = target_base + (row * 64)
    local high_mem_address = source_base + (row * 64)
    
    -- copy 8 bytes (16 pixels wide) for this row from high mem to sprite sheet
    memcpy(active_ram_address, high_mem_address, 8)
  end
end