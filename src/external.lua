function load_external_data()
  -- User save data is reserved for 0x8000 - 0x0800
  -- TODO: Auto-save progress and reload on start
  
  -- Preload LEVEL 2 (Grabbing Tab 4 at 0x1800)
  reload(0x8800, 0x1800, 0x0800, "map2.p8")       
  reload(0x9000, 0x2000, 0x1000, "map2.p8")       
  
  -- Preload LEVEL 3 (Grabbing Tab 4 at 0x1800)
  reload(0xa000, 0x1800, 0x0800, "map3.p8")       
  reload(0xa800, 0x2000, 0x1000, "map3.p8")       
  
  -- Preload LEVEL 4 (Grabbing Tab 4 at 0x1800)
  reload(0xb800, 0x1800, 0x0800, "map4.p8")       
  reload(0xc000, 0x2000, 0x1000, "map4.p8")       
  
  -- Preload LEVEL 5 (Grabbing Tab 4 at 0x1800)
  reload(0xd000, 0x1800, 0x0800, "map5.p8")       
  reload(0xd800, 0x2000, 0x1000, "map5.p8")       
  
  -- Preload LEVEL 6 (Grabbing Tab 4 at 0x1800)
  reload(0xe800, 0x1800, 0x0800, "map6.p8")       
  reload(0xf000, 0x2000, 0x1000, "map6.p8") 
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