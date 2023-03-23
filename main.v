module main

import gg
import gx

const (
	width = 800
	height = 800
	section_size = 100
	vectors = [[1.0, 0.0], [1.0, 1.0], [0.0, 1.0], [-1.0, 1.0], [-1.0, 0.0], [-1.0, -1.0], [0.0, -1.0], [1.0, -1.0]]
)


fn fcolor(val f32) gx.Color {
	return gx.Color{r: u8(255*val), g: u8(255*val), b: u8(255*val), a: 255}
}

struct App {
	mut:
		gg &gg.Context = unsafe { nil }
		iidx int
		noise_type int = 0
		noise []f32
		pixels &u32 = unsafe { vcalloc(width * height * sizeof(f32)) }
}

fn (mut app App) display_noise() {
	// converting noise to pixel
	for i := 0; i < width * height; i++ {
		app.pixels[i] = u32(fcolor(app.noise[i]).abgr8())
	}

	mut istream_image := app.gg.get_cached_image_by_idx(app.iidx)
	istream_image.update_pixel_data(app.pixels)
	size := gg.window_size()
	app.gg.draw_image(0, 0, size.width, size.height, istream_image)
}

fn graphics_init(mut app App) {
	app.iidx = app.gg.new_streaming_image(width, height, 4, pixel_format: .rgba8)
}

fn frame(mut app App) {
	app.gg.begin()
	if app.noise_type == 0 {
		app.noise = noise(width, height)
	} else if app.noise_type == 1 {
		app.noise = perlin_noise(width, height, section_size, vectors)
	}
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
		
	}
}

fn main() {
	mut app := App {
		gg: 0
	}
	app.gg = gg.new_context(
		frame_fn: frame
		init_fn: graphics_init
		user_data: &app
		width: width
		height: height
		keydown_fn: keydown
		create_window: true
		window_title: 'V Noise'
	)
	app.gg.run()
}