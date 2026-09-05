extends CharacterBody2D

@export var speed: float = 400.0
@export var acceleration: float = 1000.0
@export var friction : float = 1000.0

@onready var sprite = $Icon

@onready var dangerous = $Dangerous


func _ready() -> void:
	position = Vector2(400,400)
	pass

#func check_if_lit() -> bool:
	
	# print("check_if_lit ", lit_by_lights.size())
	#for light in lit_by_lights:
		## Point the raycast from the player's center to the light source center
		#print("light area ", light)
		#
		#for ray in rays.get_children():
			#ray.target_position = light.global_position - ray.global_position
			#if ray.target_position.length() < light.get_parent().radius:
				#ray.force_raycast_update()
				## If the ray didn't hit a wall, the light path is clear!
				#if not ray.is_colliding():
					#print("distance ", ray.target_position.length())
					#return true
			#
	#return false
	
func _physics_process(delta: float) -> void:
	# Gets input vector from arrow keys or WASD (ui_left, ui_right, etc.)
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		# Accelerate towards the target speed
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.y = move_toward(velocity.y, direction.y * speed, acceleration * delta)
	else:
		# Apply friction to slow down to zero when there is no input
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.y = move_toward(velocity.y, 0, friction * delta)
	move_and_slide()
	
	# print("lit ", sprite.get_luminance(), " pos ", LitManager.sample_luminance(position, 2, 1))
	
	#if check_if_lit():
		#modulate = Color(1, 0, 0, 1)
	#else:
		#modulate = Color.WHITE
