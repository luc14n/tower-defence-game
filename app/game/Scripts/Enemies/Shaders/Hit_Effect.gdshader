shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0, 1.0, 1.0,1.0);
uniform bool flash_on = false;

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec3 final_rgb = flash_on ? flash_color.rgb : sprite_color.rgb;
	COLOR = vec4(final_rgb, sprite_color.a);
}
