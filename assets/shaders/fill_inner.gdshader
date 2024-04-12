shader_type canvas_item;
render_mode unshaded;

uniform float fill_amount : hint_range(0.0, 1.0);

varying vec4 modulate_color;

void vertex() {
	modulate_color = COLOR;
}

vec2 scale(vec2 uv, float x, float y) {
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}

void fragment() {
	float scale_amount = tan((1.0 - fill_amount) * PI / 2.0) * 2.0;
	vec4 color = texture(TEXTURE, UV);
	vec4 scale_color = texture(TEXTURE, scale(UV, scale_amount, scale_amount));
	if (scale_color.a > 0.001) {	
		color.a = 0.0;
	}
	COLOR = color * modulate_color;
}