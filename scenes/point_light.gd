class_name PointLight extends PointLight2D

@export var max_radius : float = 256.0
@export var min_radius : float = 0.0
@export var time_grow : float = 3.0
@export var time_shrink : float = 1.0

var radius : float  

func _ready() -> void:
	
	while true:
		var tween = create_tween()
		tween.tween_method(
			func (a): radius = a			
			, min_radius, max_radius, time_grow)
		tween.chain().tween_method(
			func (a): radius = a			
			,  max_radius, min_radius, time_shrink)
		await tween.finished

func _process(_delta: float) -> void:
	scale = Vector2(radius / 64.0, radius / 64.0)
