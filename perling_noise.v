module main

import math
import rand

fn perlin_noise(width int, height int, section_size int, vectors [][]f64) []f32 {
	mut noise := []f32{}
	mut gradient_vectors := []f64{}
	mut dot_products := []f64{}
	mut distance_vectors := [][]int{}
	mut x, mut y := 0, 0
	
	for j := 0; j < int(width / section_size) * int(height / section_size); j++ {
		gradient_vectors << rand.element(vectors) or { [0.0, 0.0] }
	}

	for i := 0; i < width * height; i++ {
		noise << rand.f32()
		x = i % width
		y = i / width
		distance_vectors = [[math.abs(x - x/width/100), math.abs(y - y/height/100)],
							 [math.abs(x - (x+1)/width/100), math.abs(y - y/height/100)],
							 [math.abs(x - x/width/100), math.abs(y - (y+1)/height/100)],
							 [math.abs(x - (x+1)/width/100), math.abs(y - (y+1)/height/100)]]
		// il faut replacer l'expression par le produit scalaire et recuperer les bons vecteurs
		dot_products = [gradient_vectors[y*(height/section_size) + x] * distance_vectors[0],
						gradient_vectors[y*(height/section_size) + x+1] * distance_vectors[1],
						gradient_vectors[(y+1)*(height/section_size) + x] * distance_vectors[2],
						gradient_vectors[(y+1)*(height/section_size) + x+1] * distance_vectors[3]]
	}
	return noise
}