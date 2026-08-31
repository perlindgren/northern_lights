extends PointLight2D


func _process(_delta: float) -> void:
	# Make the PointLight2D look at the cursor to update LIGHT_DIRECTION globally
	look_at(get_global_mouse_position())
	print("global mouse", get_global_mouse_position())
