module main

import gg
import gx

const (
	screen_width  = 900
	screen_height = 600
	menu_size     = screen_width - screen_height
	bg_color      = gx.rgb(124, 124, 124)
	button_color  = gx.rgb(51, 51, 51)
	grid_width 	  = screen_width - menu_size
	grid_height   = screen_height
	pixel_size    = 1
	text_cfg      = gx.TextCfg{
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
	gg         &gg.Context = unsafe { nil }
	iidx       int
	pixels     &u32 = unsafe { vcalloc(screen_width * screen_height * sizeof(f32)) }
	noise_type int
	noise      [][]f32
}

fn (mut app App) display_noise() {
	// noise drawing
	for x in 0 .. grid_width {
		for y in 0 .. grid_height {
			for xx in 0 .. pixel_size {
				for yy in 0 .. pixel_size {
					if x * pixel_size + xx >= grid_width * pixel_size || y * pixel_size + yy >= grid_height * pixel_size {
						continue
					}
					unsafe {
						app.pixels[(y * pixel_size + yy) * screen_width + x * pixel_size + xx] = u32(fcolor(app.noise[x][y]).abgr8())
					}
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
	app.gg.draw_text(screen_height + menu_size / 2, screen_height / 6 + 30, 'Noise generator', text_cfg)

	// generation button
	app.gg.draw_rect_filled(screen_height + 50, screen_height / 6 + 300, menu_size - 100, 60, button_color)
	app.gg.draw_text(screen_height + menu_size / 2, screen_height / 6 + 330, 'Generate', text_cfg)

	// change type button
	app.gg.draw_rect_filled(screen_height + 50, screen_height / 6 + 400, menu_size - 100, 60, button_color)
	app.gg.draw_text(screen_height + menu_size / 2, screen_height / 6 + 430, 'Change type',	text_cfg)
}

fn (mut app App) generate_noise() {
	if app.noise_type == 0 {
		app.noise = noise(grid_width, grid_width)
	} else if app.noise_type == 1 {
		app.noise = fractal_perlin_array(grid_width, grid_height, 100, 8, 0.65, 2)
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
	} else if code == gg.KeyCode.enter {
		app.generate_noise()
	}
}

fn click(x f32, y f32, btn gg.MouseButton, mut app App) {
	if btn == .left {
		// check if clicked on buttons
		if x > screen_height + 50 && x < screen_height + menu_size - 50 {
			if y > screen_height / 6 + 300 && y < screen_height / 6 + 360 {
				app.generate_noise()
			} else if y > screen_height / 6 + 400 && y < screen_height / 6 + 460 {
				app.noise_type++
				if app.noise_type > 1 {
					app.noise_type = 0
				}
				app.generate_noise()
			}
		}
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
		click_fn: click
		create_window: true
		window_title: 'V Noise'
	)

	app.gg.run()
}
