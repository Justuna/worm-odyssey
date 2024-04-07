shader_type canvas_item;
render_mode unshaded;

uniform vec4 background_color : source_color;
uniform float fill_amount : hint_range(0.0, 1.0);
uniform float offset_angle : hint_range(0.0, 360.0);
uniform bool flip_cutoff;

varying vec4 self_modulate_color;

void vertex() {
	self_modulate_color = COLOR;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (fill_amount == 0.0) {
		color.a = 0.0;
	} else if (fill_amount != 1.0) {
		vec2 centered_pos = UV - vec2(0.5, 0.5);
		float angle = mod(atan(centered_pos.y, centered_pos.x) + radians(offset_angle) + 2.0 * PI, 2.0 * PI); 
		float actual_fill_amount = fill_amount;
		if (!flip_cutoff) {
			actual_fill_amount = 1.0 - fill_amount;
		}
		float angle_cutoff = mod(2.0 * PI * actual_fill_amount, 2.0 * PI);
		if (flip_cutoff) {
			if (angle > angle_cutoff) {
				if (color.a > 0.001) {
					color = background_color;
				} else {
					color.a = 0.0;
				}
			}
		} else {
			if (angle < angle_cutoff) {
				if (color.a > 0.001) {
					color = background_color;
				} else {
					color.a = 0.0;
				}
			}
		}
	}
	COLOR = color * self_modulate_color;
}