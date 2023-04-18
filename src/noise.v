module main

import rand

fn noise(width int, height int) [][]f32 {
	mut values := [][]f32{}
	for _ in 0 .. height {
		mut row := []f32{}
		for _ in 0 .. width {
			row << rand.f32()
		}
		values << row
	}
	return values
}
