module main	

import rand

struct Noise {
	mut:
		noise []f32
}

fn noise(width int, height int) []f32 {
	mut noise := []f32{}
	for i := 0; i < width * height; i++ {
		noise << rand.f32()
	}
	return noise
}

