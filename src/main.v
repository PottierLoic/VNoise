module main

import gg
import gx

const (
	screen_width  = 900
	screen_height = 600
	menu_size = screen_width-screen_height
	bg_color = gx.rgb(36, 66, 216)
	button_color = gx.rgb(115, 138, 250)
	text_cfg = gx.TextCfg{
		color: gx.white
		size: 20
		align: .center
		vertical_align: .middle
	}
)

fn fcolor(val f32) gx.Color {
	return gx.Color{
		r: u8(255 * val)
		g: u8(255 * val)
		b: u8(255 * val)
		a: 255
	}
}

struct App {
mut:
	gg          &gg.Context = unsafe { nil }
	iidx        int
	pixels      &u32 = unsafe { vcalloc(screen_width * screen_height * sizeof(f32)) }
	noise_type  int
	noise       [][]f32
	grid_width  int = screen_width-menu_size
	grid_height int = screen_height
	pixel_size  int = 1
}

fn (mut app App) display_noise() {
	// noise drawing
	for x in 0 .. app.grid_width {
		for y in 0 .. app.grid_height {
			for xx in 0 .. app.pixel_size {
				for yy in 0 .. app.pixel_size {
					if x * app.pixel_size + xx >= app.grid_width * app.pixel_size || y * app.pixel_size + yy >= app.grid_height * app.pixel_size { continue }
					unsafe { app.pixels[(y * app.pixel_size + yy)*screen_width  + x * app.pixel_size + xx] = u32(fcolor(app.noise[x][y]).abgr8()) }
				}
			}
		}
	}

	// full image display
	mut istream_image := app.gg.get_cached_image_by_idx(app.iidx)
	istream_image.update_pixel_data(app.pixels)
	size := gg.window_size()
	app.gg.draw_image(0, 0, size.width, size.height, istream_image)

	// UI display
	app.gg.draw_rect_filled(screen_height + 50, screen_height / 6, menu_size - 100, 60, button_color)
	app.gg.draw_text(screen_height + menu_size / 2, screen_height / 6 + 30, "Noise generator", text_cfg)
}

fn (mut app App) generate_noise() {
	if app.noise_type == 0 {
		print('noise generated')
		app.noise = noise(app.grid_width, app.grid_width)
	} else if app.noise_type == 1 {
		print('perlin generated')
		app.noise = fractal_perlin_array(app.grid_width, app.grid_height, 100, 8, 0.65, 2)
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

fn keydown(code gg.KeyCode, mod gg.Modifier, mut app App) {
	if code == gg.KeyCode.space {
		app.noise_type++
		if app.noise_type > 1 {
			app.noise_type = 0
		}
		print('noise type: ${app.noise_type}\n')
	} else if code == gg.KeyCode.enter {
		app.generate_noise()
	}
}

fn main() {
	mut app := App{
		gg: 0
		noise: noise(screen_width, screen_height)
	}
	app.gg = gg.new_context(
		frame_fn: frame
		bg_color: bg_color
		init_fn: graphics_init
		user_data: &app
		width: screen_width
		height: screen_height
		keydown_fn: keydown
		create_window: true
		window_title: 'V Noise'
	)

	app.gg.run()
}
