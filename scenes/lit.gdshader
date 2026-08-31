shader_type canvas_item;
render_mode blend_mix;

// Parametric Cone Controls
uniform float cone_angle_deg : hint_range(0.0, 360.0) = 60.0;
uniform float cone_direction_deg : hint_range(0.0, 360.0) = 0.0;
uniform float light_radius : hint_range(0.0, 1000.0) = 300.0;
uniform float attenuation_falloff : hint_range(0.1, 5.0) = 2.0;

void fragment() {
	// Read and pass the Sprite2D's texture pixels to the light processor
	COLOR = texture(TEXTURE, UV);
}

void light() {
	// 1. Calculate relative 2D pixel-to-light vectors
	vec2 light_vec = LIGHT_POSITION.xy - LIGHT_VERTEX.xy; 
	float dist_to_light = length(light_vec);
	vec2 dir_to_light = normalize(light_vec);
	
	// 2. Clear Angular Evaluation
	float angle_rad = radians(cone_angle_deg) * 0.5;
	float dir_rad = radians(cone_direction_deg);
	vec2 cone_forward = vec2(cos(dir_rad), sin(dir_rad));
	
	// Check alignment using dot product
	float dot_product = dot(-dir_to_light, cone_forward);
	float angle_to_frag = acos(clamp(dot_product, -1.0, 1.0));
	
	float visibility = 0.0;
	
	// 3. Radius & Arc Assessment
	if (dist_to_light <= light_radius && angle_to_frag <= angle_rad) {
		visibility = 1.0;
		
		// Falloff Curve
		float falloff = 1.0 - pow(dist_to_light / light_radius, attenuation_falloff);
		visibility *= clamp(falloff, 0.0, 1.0);
		
		// 4. Corrected Godot 4 2D SDF World Occlusion Pipeline
		vec2 sdf_pos = screen_uv_to_sdf(SCREEN_UV);
		float sdf_dist = texture_sdf(sdf_pos);
		
		if (sdf_dist < 0.0) {
			visibility = 0.0; // Pixel is buried inside a collision wall
		} else {
			// Direct analytical blockage comparison
			float shadow_test = texture_sdf(screen_uv_to_sdf(SCREEN_UV)); 
			if (shadow_test < dist_to_light) {
				visibility = 0.0;
			}
		}
	}
	
	// Finalize pixel lighting multiplier
	LIGHT = LIGHT_COLOR * visibility * LIGHT_ENERGY * COLOR;
}
