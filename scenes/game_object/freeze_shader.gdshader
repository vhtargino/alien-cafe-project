shader_type canvas_item;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 blue_color = vec4(0.0, 0.0, 1.0, texture_color.a); // Azul com mesma opacidade
	vec4 final_color = mix(texture_color, blue_color, 0.5); // 50% de blend
	COLOR = final_color;
}
