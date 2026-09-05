extends Node2D

@onready var lit_point_light = $LitPointLight2D
@onready var area = $LitPointLight2D/Area2D
@onready var collision = $LitPointLight2D/Area2D/CollisionShape2D
# @onready var circle = $LitPointLight2D/Area2D/CollisionShape2D/CircleShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("lit pl ", lit_point_light)
	print("area ", area)
	print("collision ", collision)
	# print("cricle ", circle)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
