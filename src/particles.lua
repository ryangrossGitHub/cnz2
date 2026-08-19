particles = {}

function particle(x, y, x_speed, y_speed, color, life)
	local p = {
		x = x,
		y = y,
		x_speed = x_speed,
		y_speed = y_speed,
		color = color, 
		life = life, -- frames until deletion
	}

	return p
end

function draw_particles(particles)
	for particle in all(particles) do
		particle.y += particle.y_speed
		particle.x += particle.x_speed
		particle.life -= 1

		if particle.life > 0 then
		 pset(particle.x, particle.y, particle.color)
		else
	  del(particles, particle)
		end
	end
end