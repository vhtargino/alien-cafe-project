shader_type canvas_item;

uniform float speed : hint_range(0.1, 10.0) = 2.0;      // Velocidade da oscilação
uniform float intensity : hint_range(0.0, 1.0) = 0.5;   // O quanto o alpha varia
uniform float base_alpha : hint_range(0.0, 1.0) = 1.0;  // Alpha médio

void fragment() {
    float alpha_mod = sin(TIME * speed) * intensity;
    float final_alpha = clamp(base_alpha + alpha_mod, 0.0, 1.0);
    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = tex_color * final_alpha;
}
