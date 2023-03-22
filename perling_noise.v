import gg
import gx
import rand

// Windows size
const (
	width = 800
	height = 800

	gradient_size = 100
	gradient_vectors = [[1.0, 0.0], [1.0, 1.0], [0.0, 1.0], [-1.0, 1.0], [-1.0, 0.0], [-1.0, -1.0], [0.0, -1.0], [1.0, -1.0]]
)

fn fcolor(val f32) gx.Color {
	return gx.Color{r: u8(255*val), g: u8(255*val), b: u8(255*val), a: 255}
}

struct App {
	mut:
		gg &gg.Context = unsafe { nil }
		iidx int
		noise []f32
		vectors [][]f64
		pixels &u32 = unsafe { vcalloc(width * height * sizeof(f32)) }
}

fn (mut app App) create_noise() []f32 {
	mut noise := []f32{}
	for i := 0; i < width * height; i++ {
		noise << rand.f32()
	}
	for i := 0; i < int(width / gradient_size) * int(height / gradient_size); i++ {
		app.vectors << rand.element(gradient_vectors) or { [0.0, 0.0] }
	}
	return noise
}

fn (mut app App) display_sim() {
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
	app.noise = app.create_noise()
	app.display_sim()
	app.gg.end()
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
		create_window: true
		window_title: 'Noise creator'
	)
	app.gg.run()
}