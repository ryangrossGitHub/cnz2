particles = {}

function particle(x, y, x_speed, y_speed, clr, life)
	local p = {
		x = x,
		y = y,
		x_speed = x_speed,
		y_speed = y_speed,
		clr = clr, -- pixel color
		life = life, -- frames until deletion
	}

	return p
end

function draw_particles(particles)
	for p in all(particles) do
		p.y += p.y_speed
		p.x += p.x_speed
		p.life -= 1

		if p.life > 0 then
		 pset(p.x, p.y, p.clr)
		else
	  del(particles, p)
		end
	end
end