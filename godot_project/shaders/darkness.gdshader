shader_type canvas_item;

uniform vec2 player_pos = vec2(400.0, 225.0);
uniform float radius = 140.0;
uniform vec4 dark_color : source_color = vec4(0.043, 0.059, 0.098, 0.98);

void fragment() {
	vec2 pixel_pos = UV * vec2(800.0, 450.0);
	float d = distance(pixel_pos, player_pos);
	float factor = smoothstep(radius * 0.35, radius, d);
	COLOR = vec4(dark_color.rgb, dark_color.a * factor);
}
