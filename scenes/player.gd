extends CharacterBody2D

@export var speed: float = 400.0

func _physics_process(delta: float) -> void:
	# Gets input vector from arrow keys or WASD (ui_left, ui_right, etc.)
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Apply velocity and move
	velocity = direction * speed
	move_and_slide()
