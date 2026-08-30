extends StaticBody2D

@export var min_pos : Vector2 = Vector2(400,300)
@export var max_pos : Vector2 = Vector2(450,500)
@export var time_grow : float = 6.0
@export var time_shrink : float = 5.0

var radius : float  

func _ready() -> void:
	
	while true:
		var tween = create_tween()
		tween.tween_method(
			func (p): position = p 			
			, min_pos, max_pos, time_grow)
		tween.chain().tween_method(
			func (p): position = p 			
			,  max_pos, min_pos, time_shrink)
		await tween.finished
