extends PointLight2D

# Customize these uniquely per light instance via the Inspector panel!
@export_range(0.0, 360.0) var fov_angle: float = 60.0
@export var intensity_radius: float = 300.0
@export_range(0.1, 5.0) var falloff_exponent: float = 2.0
@export var follows_mouse: bool = false

func _ready() -> void:
	shadow_enabled = true
	
	# 1. Instantiate the texture container
	var grad = GradientTexture2D.new()
	grad.width = int(intensity_radius * 2)
	grad.height = int(intensity_radius * 2)
	
	# FIX: Create a basic white gradient fill so the texture memory is not null
	var new_gradient = Gradient.new()
	new_gradient.set_color(0, Color.WHITE)
	grad.gradient = new_gradient
	
	# 2. Assign the filled texture safely to the light node
	texture = grad

func _process(_delta: float) -> void:
	if follows_mouse:
		look_at(get_global_mouse_position())
	# print("global_rotation ", global_rotation)
		
	# PACK INDIVIDUAL DATA AS UNCLAMPED FLOATS
	# Because we are setting a Color object directly via GDScript variables, 
	# Godot lets us pass raw, un-clamped floats straight down to the shader.
	color = Color(
		fov_angle,         # R -> e.g., 45.0
		global_rotation,   # G -> e.g., -1.57 (Radians)
		intensity_radius,  # B -> e.g., 300.0 (Triggers the > 1.0 check!)
		falloff_exponent   # A -> e.g., 2.0
	)
