shader_type canvas_item;

uniform float cone_angle_degrees : hint_range(0.0, 360.0) = 90.0;
uniform float beam_length : hint_range(0.0, 1.0) = 1.0;
uniform float edge_softness : hint_range(0.0, 1.0) = 0.05;

void fragment() {
    // 1. Sample the background texture assigned to PointLight2D
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Center the UV coordinates so (0,0) is in the middle of the texture
    vec2 uv = UV - vec2(0.5);
    
    // Convert Cartesian coordinates (X, Y) to Polar coordinates (Distance, Angle)
    float distance = length(uv);
    float angle = atan(uv.x, -uv.y); // Negative Y points the cone upward
    
    // Convert angle to degrees and mirror it so 0 is dead center
    float angle_deg = abs(degrees(angle));
    
    // Check if the current pixel falls inside our target cone half-angle
    float half_cone = cone_angle_degrees / 2.0;
    
    // Smoothstep creates soft edges
    float cone_mask = smoothstep(half_cone, half_cone - (edge_softness * 50.0), angle_deg);
    
    // Fade the light out cleanly as it reaches the maximum length boundary
    float length_mask = smoothstep(beam_length * 0.5, (beam_length * 0.5) - edge_softness, distance);
    
    // Combine masks to get the final shape
    float final_intensity = cone_mask * length_mask;
    
    // FIX: Multiply our math mask by the actual texture's alpha channel!
    COLOR = vec4(1.0, 1.0, 1.0, final_intensity * tex_color.a);
}
