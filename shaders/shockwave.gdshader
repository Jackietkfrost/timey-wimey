shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size-0.1, size, length(scaledUV - center))) *
		smoothstep(size-thickness-0.1, size-thickness, length(scaledUV - center));
	vec2 disp = normalize(SCREEN_UV - center) * force * mask;
	COLOR = vec4(SCREEN_UV - disp, 0.0, 1.0);
	COLOR = texture(screen_texture, SCREEN_UV - disp);
	//COLOR.rgb = vec3(mask);

	// Called for every pixel the material is visible on.
}
