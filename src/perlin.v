module main

import rand

const (
	perm = [151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103,
		30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62,
		94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136,
		171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229,
		122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63,
		161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196, 135, 130, 116, 188,
		159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123, 5, 202, 38,
		147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223,
		183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
		129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97,
		228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14,
		239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127,
		4, 150, 254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215,
		61, 156, 180, 151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140,
		36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26,
		197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20,
		125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83,
		111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
		65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196, 135, 130,
		116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123, 5,
		202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189,
		28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167,
		43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
		218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145,
		235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121,
		50, 45, 127, 4, 150, 254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195,
		78, 66, 215, 61, 156, 180]
)

fn smooth_step(t f32) f32 {
	return t * t * t * (t * (t * 6.0 - 15.0) + 10.0)
}

fn linear_interpolation(t f32, a f32, b f32) f32 {
	return a + t * (b - a)
}

fn gradient(hash int, x f32, y f32) f32 {
	match hash & 0xF {
		0x0 { return x + y }
		0x1 { return -x + y }
		0x2 { return x - y }
		0x3 { return -x - y }
		0x4 { return x }
		0x5 { return -x }
		0x6 { return x }
		0x7 { return -x }
		0x8 { return y }
		0x9 { return -y }
		0xA { return y }
		0xB { return -y }
		0xC { return y + x }
		0xD { return -y }
		0xE { return y - x }
		0xF { return -y }
		else { return 0 }
	}
}

fn perlin(xx f32, yy f32, perm []int) f32 {
	ix := int(xx)
	gx := ix & 0xFF
	iy := int(yy)
	gy := iy & 0xFF

	x := xx - ix
	y := yy - iy

	u := smooth_step(x)
	v := smooth_step(y)

	a := perm[gx] + gy
	aa := perm[a]
	ab := perm[a + 1]
	b := perm[gx + 1] + gy
	ba := perm[b]
	bb := perm[b + 1]

	return linear_interpolation(v, linear_interpolation(u, gradient(perm[aa], x, y), gradient(perm[ba],
		x - 1, y)), linear_interpolation(u, gradient(perm[ab], x, y - 1), gradient(perm[bb],
		x - 1, y - 1)))
}

fn perlin_array(width int, height int, res int) [][]f32 {
	new_perm := rand.shuffle_clone(perm) or { perm }
	mut grid := [][]f32{}
	for y in 0 .. height {
		grid << []f32{}
		yy := f32(y * (1 / f32(res)))
		for x in 0 .. width {
			xx := f32(x * (1 / f32(res)))
			grid[y] << (perlin(xx, yy, new_perm) + 1) / 2
		}
	}
	return grid
}

fn fractal_perlin_array(width int, height int, res int, octaves int, persistance f32, lacunarity f32) [][]f32 {
	mut grid := [][]f32{}
	for y in 0 .. height {
		grid << []f32{}
		for _ in 0 .. width {
			grid[y] << 0.0
		}
	}

	mut frequency := 1.0
	mut amplitude := 1.0

	for _ in 0 .. octaves {
		mut values := perlin_array(width, height, int(res * frequency))
		for mut row in values {
			for mut val in row {
				val *= amplitude
			}
		}
		frequency *= lacunarity
		amplitude *= persistance
		for y in 0 .. height {
			for x in 0 .. width {
				grid[y][x] += values[y][x]
			}
		}
	}
	mut min := f32(9999)
	mut max := f32(-9999)
	for row in grid {
		for val in row {
			if val < min {
				min = val
			}
			if val > max {
				max = val
			}
		}
	}

	for y in 0 .. height {
		for x in 0 .. width {
			grid[y][x] = (grid[y][x] - min) / (max - min)
		}
	}
	return grid
}
