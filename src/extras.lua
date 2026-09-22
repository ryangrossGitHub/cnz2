extras_sprites = {72, 74, 76, 78}
extras_flip = false
extras_flip_count = 0
extras_flip_delay = 19
bounce_increment = 0

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
        local bartender_x = 49 * 8
        local bounce = sin(bounce_increment / 30) * 2
        bounce_increment += 1
        local bartender_y = 2 * 8 + 1
        print("❎", bartender_x + 4, bartender_y - 7 + bounce, 7)
        spr(extras_sprites[4], bartender_x, bartender_y, 2, 3, extras_flip, false)
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

    spr(extras_sprites[2], screen_size * 1 + 18, 48, 2, 4, extras_flip, false)

    spr(extras_sprites[3], screen_size * 1 + 110, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 1 + 74, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 1 + 67, 30, 2, 4, extras_flip, false)

    spr(extras_sprites[1], screen_size * 1 + 85, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[2], screen_size * 1 + 94, 48, 2, 4, extras_flip, false)

    -- between dj and bar
    spr(extras_sprites[1], screen_size * 2 + 1, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[2], screen_size * 2 + 25, 48, 2, 4, extras_flip, false)

    spr(extras_sprites[1], screen_size * 2 + 18, 33, 2, 4, extras_flip, false)

    spr(extras_sprites[3], screen_size * 2 + 110, 34, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 2 + 81, 29, 2, 4, extras_flip, false)

    spr(extras_sprites[1], screen_size * 2 + 94, 37, 2, 4, extras_flip, false)

    -- bar
    spr(extras_sprites[1], screen_size * 3 + 1, 43, 2, 4, extras_flip, false)
    spr(extras_sprites[2], screen_size * 3 + 25, 48, 2, 4, extras_flip, false)

    spr(extras_sprites[2], screen_size * 3 + 18, 50, 2, 4, extras_flip, false)

    spr(extras_sprites[3], screen_size * 3 + 117, 34, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 3 + 55, 42, 2, 4, extras_flip, false)

    spr(extras_sprites[1], screen_size * 3 + 81, 39, 2, 4, extras_flip, false)

    -- bathroom
    spr(extras_sprites[1], screen_size * 4 + 1, 33, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 4 + 8, 36, 2, 4, extras_flip, false)

    spr(extras_sprites[4], screen_size * 4 + 34, 31, 2, 4, extras_flip, false)

    spr(extras_sprites[3], screen_size * 4 + 117, 39, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 4 + 85, 55, 2, 4, extras_flip, false)
    spr(extras_sprites[1], screen_size * 4 + 89, 88, 2, 4, extras_flip, false)
    spr(extras_sprites[2], screen_size * 4 + 56, 95, 2, 4, extras_flip, false)

    spr(extras_sprites[4], screen_size * 4 + 99, 48, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 4 + 83, 95, 2, 4, extras_flip, false)

    -- 3. Reset the palette immediately so other sprites draw normally
    pal()
    palt(13, true) -- Transparent Color Is Purple (13) 
    palt(0, false)
end