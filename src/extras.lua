extras_sprites = {72, 74, 76, 78}
extras_flip = false
extras_flip_count = 0
extras_flip_delay = 13

function draw_extras()
    if extras_flip_count < extras_flip_delay then
        extras_flip_count += 1
    else
        extras_flip_count = 0
        extras_flip = not extras_flip
    end

    spr(extras_sprites[1], screen_size * 1 + 30, 96, 2, 4, extras_flip, false)
    spr(extras_sprites[2], screen_size * 1 + 45, 94, 2, 4, extras_flip, false)
    spr(extras_sprites[3], screen_size * 1 + 65, 94, 2, 4, extras_flip, false)
    spr(extras_sprites[4], screen_size * 1 + 85, 95, 2, 4, extras_flip, false)
end