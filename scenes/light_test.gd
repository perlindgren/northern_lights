extends Node2D

@onready var lights = $Lights

func _ready() -> void:
	pass
	#for light in lights.get_children():
		#while true:
			#var tween = create_tween()
			#var old_rad = light.radius
			#await tween.tween_method(
				#func (a): light.radius = a			
				#, 0.0, old_rad, 3).finished
