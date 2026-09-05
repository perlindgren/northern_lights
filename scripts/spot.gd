extends Node2D

@onready var lit_spot = $LitSpotLight2D

@export var rpm : float = 60.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	while true:
		var tween = create_tween()
		tween.tween_method(
			func (a): lit_spot.rotation = a			
			, 0.0, TAU, 1.0 / (rpm / 60.0))
		await tween.finished
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
