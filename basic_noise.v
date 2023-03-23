module main	

import rand

fn noise(width int, height int) []f32 {
	mut noise := []f32{}
	for i := 0; i < width * height; i++ {
		noise << rand.f32()
	}
	return noise
}

