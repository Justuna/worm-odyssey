shader_type canvas_item;
render_mode unshaded;

uniform vec4 overlay_color : source_color = vec4(0.0);
uniform float overlay_amount : hint_range(0.0, 1.0);
uniform bool overlay_enabled = true;

uniform vec4 overlay_2_color : source_color = vec4(0.0);
uniform float overlay_2_amount : hint_range(0.0, 1.0);
uniform bool overlay_2_enabled = true;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	if (color.a > 0.0001) {
		if (overlay_enabled) {
			color = mix(color, overlay_color, overlay_amount);
		}
		if (overlay_2_enabled) {
			color = mix(color, overlay_2_color, overlay_2_amount);
		}
	}
	COLOR = color;
}