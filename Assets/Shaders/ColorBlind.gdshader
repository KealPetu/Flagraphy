shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform int mode : hint_range(0, 3) = 0; // 0:Normal, 1:Prota, 2:Deuta, 3:Trita
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 c = texture(screen_texture, SCREEN_UV);
	
	// Matrices aproximadas para simulación de daltonismo (LMS version simplificada)
	// Protanopia (Rojo debil)
	mat3 prota = mat3(
		vec3(0.567, 0.433, 0.0),
		vec3(0.558, 0.442, 0.0),
		vec3(0.0, 0.242, 0.758)
	);
	
	// Deuteranopia (Verde debil)
	mat3 deuta = mat3(
		vec3(0.625, 0.375, 0.0),
		vec3(0.7, 0.3, 0.0),
		vec3(0.0, 0.3, 0.7)
	);
	
	// Tritanopia (Azul debil)
	mat3 trita = mat3(
		vec3(0.95, 0.05, 0.0),
		vec3(0.0, 0.433, 0.567),
		vec3(0.0, 0.475, 0.525)
	);
	
	vec3 final_color = c.rgb;
	
	if (mode == 1) {
		final_color = final_color * prota;
	} else if (mode == 2) {
		final_color = final_color * deuta;
	} else if (mode == 3) {
		final_color = final_color * trita;
	}
	
	// Mezclar el color original con el procesado según la intensidad
	c.rgb = mix(c.rgb, final_color, intensity);
	
	COLOR = c;
}