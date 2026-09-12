extras_sprites = {72, 74, 76, 78}
extras_flip = false
extras_flip_count = 0
extras_flip_delay = 13

function draw_extras(side)
    if extras_flip_count < extras_flip_delay then
        extras_flip_count += 1
    else
        extras_flip_count = 0
        extras_flip = not extras_flip
    end

    -- 1. Remap all colors to dark brown (index 4) or black (index 0)
    -- Reset palette to defaults first to avoid bleeding changes
    palt(13, true) -- Transparent Color Is Purple (13) 
    palt(0, false)

    -- Remap individual colors, or loop through all 16 colors:
    for i=0,15 do
        pal(i, 0) -- Changes every color to PICO-8 black (color 4)
    end

    -- 2. Draw your sprite normally
    if side == "front" then
        spr(extras_sprites[3], screen_size * 1 + 1, 39, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 25, 48, 2, 4, extras_flip, false)
        spr(extras_sprites[2], screen_size * 1 + 37, 70, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 5, 84, 2, 4, extras_flip, false)
        spr(extras_sprites[1], screen_size * 1 + 43, 92, 2, 4, extras_flip, false)

        spr(extras_sprites[2], screen_size * 1 + 18, 48, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 17, 92, 2, 4, extras_flip, false)
        spr(extras_sprites[1], screen_size * 1 + 27, 95, 2, 4, extras_flip, false)

        spr(extras_sprites[3], screen_size * 1 + 110, 39, 2, 4, extras_flip, false)
        spr(extras_sprites[4], screen_size * 1 + 119, 48, 2, 4, extras_flip, false)
        spr(extras_sprites[1], screen_size * 1 + 81, 60, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 109, 75, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 119, 84, 2, 4, extras_flip, false)
        spr(extras_sprites[1], screen_size * 1 + 88, 92, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 117, 95, 2, 4, extras_flip, false)

        spr(extras_sprites[1], screen_size * 1 + 85, 39, 2, 4, extras_flip, false)
        spr(extras_sprites[2], screen_size * 1 + 94, 48, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 87, 95, 2, 4, extras_flip, false)
    elseif side == "back" then
        spr(extras_sprites[1], screen_size * 1 + 10, 32, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 25, 30, 2, 4, extras_flip, false)
        spr(extras_sprites[1], screen_size * 1 + 45, 30, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 65, 31, 2, 4, extras_flip, false)

        spr(extras_sprites[1], screen_size * 1 + 40, 32, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 55, 30, 2, 4, extras_flip, false)
        spr(extras_sprites[3], screen_size * 1 + 95, 30, 2, 4, extras_flip, false)
        spr(extras_sprites[2], screen_size * 1 + 105, 31, 2, 4, extras_flip, false)
    end

    -- 3. Reset the palette immediately so other sprites draw normally
    pal()
    palt(13, true) -- Transparent Color Is Purple (13) 
    palt(0, false)

    
end