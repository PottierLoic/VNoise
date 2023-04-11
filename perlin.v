module main

import math
import rand

fn random_gradient() (f32, f32) {
	nr := rand.f32_in_range(0.0, math.pi * 2) or { 0 }
	return math.cosf(nr), math.sinf(nr)
}

fn interpolate(a f32, b f32, w f32) f32 {
	return ((a - b) * w) + a
}

fn dot_product(x1 int, y1 int, x2 f32, y2 f32) f32 {
	vec_x, vec_y := random_gradient()
	dx := x2 - f32(x1)
	dy := y2 - f32(y1)
	return dx * vec_x + dy * vec_y
}

pub fn perlin(width int, height int) [][]f32 {
	mut values := [][]f32{}
	for y in 0..height {
		mut row := []f32{}
		for x in 0..width {
			x1 := int(math.floor(x))
			y1 := int(math.floor(y))
			x2 := x1 + 1
			y2 := y1 + 1

			sx := x - f32(x1)
			sy := y - f32(y2)

			n0 := dot_product(x1, y1, x, y)
			n1 := dot_product(x2, y1, x, y)
			first := interpolate(n0, n1, sx)

			n2 := dot_product(x1, y2, x, y)
			n3 := dot_product(x2, y2, x, y)
			second := interpolate(n2, n3, sx)

			row << interpolate(first, second, sy)
		}
		values << row
	}
	return values
}