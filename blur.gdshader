shader_type canvas_item;

uniform float blur_strength : hint_range(0.0, 4.0) = 1.2;
uniform float haze_strength : hint_range(0.0, 1.0) = 0.35;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform vec4 haze_color : source_color = vec4(1.0, 1.0, 1.0, 5.0);

uniform float noise_scale : hint_range(1.0, 40.0) = 10.0;
uniform float noise_speed : hint_range(0.0, 3.0) = 0.3;

float rand(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 uv) {
	vec2 i = floor(uv);
	vec2 f = fract(uv);

	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) +
		(c - a) * u.y * (1.0 - u.x) +
		(d - b) * u.x * u.y;
}

void fragment() {
	vec2 uv = SCREEN_UV;

	// --------- Soft Blur Sampling (very light blur) ----------
	vec4 col = vec4(0.0);
	float strength = blur_strength / 800.0; // screen dependent

	col += texture(screen_texture, uv + vec2(-strength, 0.0));
	col += texture(screen_texture, uv + vec2(strength, 0.0));
	col += texture(screen_texture, uv + vec2(0.0, -strength));
	col += texture(screen_texture, uv + vec2(0.0, strength));
	col += texture(screen_texture, uv);
	col /= 5.0;

	// --------- Fog Noise Layer ----------
	float t = TIME * noise_speed;
	float n = noise(uv * noise_scale + vec2(t, t * 0.7));
	float haze = clamp(n * haze_strength, 0.0, 1.0);

	// Mix fog into blurred scene
	vec4 fogged = mix(col, haze_color, haze);

	COLOR = fogged;
}