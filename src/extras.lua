extras_sprites = {72, 74, 76, 78}
extras_flip = false
extras_flip_count = 0
extras_flip_delay = 19

function draw_extras(back)
    if extras_flip_count < extras_flip_delay then
        extras_flip_count += 1
    else
        extras_flip_count = 0
        extras_flip = not extras_flip
    end
    
    if back then
        -- DJ
        spr(extras_sprites[1], 23 * 8, 8, 2, 2, extras_flip, false)
        -- Bartender
        spr(extras_sprites[4], 49 * 8, 2 * 8 + 1, 2, 3, extras_flip, false)
        return 
    end

    -- 1. Remap all colors to dark brown (index 4) or black (index 0)
    -- Reset palette to defaults first to avoid bleeding changes
    palt(13, true) -- Transparent Color Is Purple (13) 
    palt(0, false)

    -- Remap individual colors, or loop through all 16 colors:
    for i=0,15 do
        pal(i, 0) -- Changes every color to PICO-8 black (color 4)
    end

    -- dj room
    spr(extras_sprites[2], screen_size * 1 + 1, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 1 + 25, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 1 + 5, 84, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 1 + 43, 92, 2, 4, extras_flip, false)

    spr(extras_sprites[2], screen_size * 1 + 18, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 1 + 27, 95, 2, 4, extras_flip, false)

    spr(extras_sprites[3], screen_size * 1 + 110, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 1 + 119, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 1 + 81, 60, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 1 + 109, 75, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 1 + 88, 92, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 1 + 117, 95, 2, 4, extras_flip, false)

    spr(extras_sprites[1], screen_size * 1 + 85, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[2], screen_size * 1 + 94, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 1 + 87, 95, 2, 4, extras_flip, false)

    -- between dj and bar
    spr(extras_sprites[1], screen_size * 2 + 1, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[2], screen_size * 2 + 25, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 2 + 5, 84, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 2 + 43, 92, 2, 4, extras_flip, false)

    spr(extras_sprites[1], screen_size * 2 + 18, 77, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 2 + 27, 95, 2, 4, extras_flip, false)

    spr(extras_sprites[3], screen_size * 2 + 110, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 2 + 81, 60, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 2 + 109, 75, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 2 + 119, 84, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 2 + 117, 95, 2, 4, extras_flip, false)

    spr(extras_sprites[1], screen_size * 2 + 85, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 2 + 94, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 2 + 87, 95, 2, 4, extras_flip, false)

    -- bar
    spr(extras_sprites[1], screen_size * 3 + 1, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[2], screen_size * 3 + 25, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 3 + 8, 84, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 3 + 43, 92, 2, 4, extras_flip, false)

    spr(extras_sprites[2], screen_size * 3 + 18, 78, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 3 + 34, 95, 2, 4, extras_flip, false)

    spr(extras_sprites[3], screen_size * 3 + 117, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 3 + 85, 60, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 3 + 129, 75, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 3 + 89, 92, 2, 4, extras_flip, false)

    spr(extras_sprites[1], screen_size * 3 + 81, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 3 + 83, 95, 2, 4, extras_flip, false)

    -- bathroom
    spr(extras_sprites[1], screen_size * 4 + 1, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 4 + 8, 84, 2, 4, extras_flip, false)

    spr(extras_sprites[4], screen_size * 4 + 34, 66, 2, 4, extras_flip, false)

    spr(extras_sprites[3], screen_size * 4 + 117, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 4 + 85, 55, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 4 + 89, 88, 2, 4, extras_flip, false)
    spr(extras_sprites[2], screen_size * 4 + 56, 95, 2, 4, extras_flip, false)

    spr(extras_sprites[4], screen_size * 4 + 99, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 4 + 83, 95, 2, 4, extras_flip, false)

    -- back
    spr(extras_sprites[2], screen_size * 4 + 1, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 4 + 8, 84, 2, 4, extras_flip, false)

    spr(extras_sprites[1], screen_size * 4 + 34, 66, 2, 4, extras_flip, false)

    spr(extras_sprites[3], screen_size * 4 + 117, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 4 + 101, 75, 2, 4, extras_flip, false)

    -- 3. Reset the palette immediately so other sprites draw normally
    pal()
    palt(13, true) -- Transparent Color Is Purple (13) 
    palt(0, false)
end