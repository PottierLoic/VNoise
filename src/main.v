module main

import rand
import gg
import gx

const (
	screen_width = 600
	screen_height = 600
	pixel_size = 1
	grid_width = screen_width / pixel_size
	grid_height = screen_height / pixel_size
)

fn fcolor(val f32) gx.Color {
	return gx.Color{r: u8(255*val), g: u8(255*val), b: u8(255*val), a: 255}
}

struct App {
	mut:
		gg &gg.Context = unsafe { nil }
		iidx int
		noise_type int
		pixels &u32 = unsafe { vcalloc(screen_width * screen_height * sizeof(f32)) }
		noise [][]f32
}

fn (mut app App) display_noise() {
	for x in 0..screen_width {
		for y in 0..screen_height {
			unsafe { app.pixels[( y) * screen_width + x] = u32(fcolor(app.noise[x][y]).abgr8()) }
		}
	}

	mut istream_image := app.gg.get_cached_image_by_idx(app.iidx)
	istream_image.update_pixel_data(app.pixels)
	size := gg.window_size()
	app.gg.draw_image(0, 0, size.width, size.height, istream_image)
}

fn (mut app App) generate_noise() {
	if app.noise_type == 0 {
		print("noise generated")
		app.noise = noise(screen_width, screen_height)
	} else if app.noise_type == 1 {
		print("perlin generated")
		app.noise = fractal_perlin_array(screen_width, screen_height, 100, 8, 0.35, 2)
	}
}

fn graphics_init(mut app App) {
	app.iidx = app.gg.new_streaming_image(screen_width, screen_height, 4, pixel_format: .rgba8)
}

fn frame(mut app App) {
	app.gg.begin()
	app.display_noise()
	app.gg.end()
}

fn keydown (code gg.KeyCode, mod gg.Modifier, mut app App) {
	if code == gg.KeyCode.space {
		app.noise_type++
		if app.noise_type > 1 {
			app.noise_type = 0
		}
		print('noise type: $app.noise_type\n')
	} else if code == gg.KeyCode.enter {
		app.generate_noise()
	}
}

fn main() {
	mut app := App {
		gg: 0
		noise: noise(screen_width, screen_height)
	}
	app.gg = gg.new_context(
		frame_fn: frame
		init_fn: graphics_init
		user_data: &app
		width: screen_width
		height: screen_height
		keydown_fn: keydown
		create_window: true
		window_title: 'V Noise'
	)

	rand.seed([u32(3807353518), 2705198303])
	app.gg.run()
}