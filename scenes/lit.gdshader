shader_type canvas_item;
render_mode blend_mix;

// Global uniform to set the actual visible color of your cone lights
uniform vec4 cone_light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV);
}

void light() {
	// 1. Calculate relative 2D pixel-to-light vectors natively
	vec2 light_vec = LIGHT_POSITION.xy - LIGHT_VERTEX.xy; 
	float dist_to_light = length(light_vec);
	vec2 dir_to_light = normalize(light_vec);
	
	// 2. THE COLOR HACK CHECK
	// Normal lights cap at 1.0. If Blue is larger, it's one of our custom cone lights!
	if (LIGHT_COLOR.b > 1.0) {
		
		// UNPACK THE DATA FOR THIS SPECIFIC LIGHT INSTANCE
		// R = Raw Arc Angle (e.g., 60.0)
		// G = Raw Rotation Angle in Radians (e.g., -1.57)
		// B = Raw Intensity Radius in Pixels (e.g., 350.0)
		// A = Raw Falloff Exponent (e.g., 2.0)
		
		float cone_angle_deg   = LIGHT_COLOR.r;
		float cone_dir_rad     = LIGHT_COLOR.g;
		float light_radius     = LIGHT_COLOR.b; 
		float falloff_exponent = LIGHT_COLOR.a;

		// Calculate the forward directional layout of this specific light node instance
		vec2 cone_forward = vec2(cos(cone_dir_rad), sin(cone_dir_rad));
		
		// 3. Parametric Arc Segment Check
		float half_angle_rad = radians(cone_angle_deg) * 0.5;
		float dot_product = dot(-dir_to_light, cone_forward);
		float angle_to_frag = acos(clamp(dot_product, -1.0, 1.0));
		
		float visibility = 0.0;
		
		if (dist_to_light <= light_radius && angle_to_frag <= half_angle_rad) {
			visibility = 1.0;
			
			// Individual smooth falloff math
			float falloff = 1.0 - pow(dist_to_light / light_radius, falloff_exponent);
			visibility *= clamp(falloff, 0.0, 1.0);
			
			// 4. Built-in Godot 4 Real-time 2D SDF Shadows
			vec2 sdf_pos = screen_uv_to_sdf(SCREEN_UV);
			float sdf_dist = texture_sdf(sdf_pos);
			
			if (sdf_dist < 0.0) {
				visibility = 0.0; // Pixel is inside an obstacle barrier
			} else {
				float shadow_test = texture_sdf(screen_uv_to_sdf(SCREEN_UV)); 
				if (shadow_test < dist_to_light) {
					visibility = 0.0; // Blocked by an occluding wall
				}
			}
		}
		
		// Output the custom cone result using our uniform color mapping
		LIGHT += cone_light_color * visibility * LIGHT_ENERGY * COLOR;

	} else {
		// 5. STANDARD LIGHT RECOVERY
		// Normal torches and ambient lights bypass the cone math entirely.
		LIGHT += LIGHT_COLOR * LIGHT_ENERGY * COLOR;
	}
}
