extends CharacterBody2D

@export var speed: float = 400.0
@export var acceleration: float = 1000.0
@export var friction : float = 1000.0

@onready var hitbox  = $"Area2D"
@onready var ray: RayCast2D = $RayCast2D

var lit_by_lights: Array[Area2D] = []

func _ready() -> void:
	# Connect Area2D signals from the Sprite's hitbox
	hitbox.area_entered.connect(_on_light_entered)
	hitbox.area_exited.connect(_on_light_exited)
	print("hitbox ", hitbox)

func _on_light_entered(area: Area2D) -> void:
	print("_on_light_entered ", area)
	if area.is_in_group("PointLight"):
		lit_by_lights.append(area)
		print("Sprite stepped into the light!")

func _on_light_exited(area: Area2D) -> void:
	print("_on_light_exited ", area)
	if area in lit_by_lights:
		lit_by_lights.erase(area)
		if lit_by_lights.is_empty():
			print("Sprite is hidden in darkness.")

func check_if_lit() -> bool:
	for light_area in lit_by_lights:
		# Point the raycast from the player's center to the light source center
		ray.global_position = global_position
		ray.target_position = light_area.global_position - global_position
		
		print("ray from ", ray.global_position)
		print("ray to ", ray.target_position)
		
		ray.force_raycast_update()
		
		# If the ray didn't hit a wall, the light path is clear!
		if not ray.is_colliding():
			return true
			
	return false

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
	
	if check_if_lit():
		print("is lit")
		modulate = Color(1, 0, 0, 1)
	else:
		modulate = Color.WHITE
