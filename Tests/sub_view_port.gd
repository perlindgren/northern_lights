extends SubViewport


# Called when the node enters the scene tree for the first time.

	
@onready var sprite_2d: Sprite2D = $LitSprite2D

func _ready() -> void:
	# Wait for two frames to ensure the viewport has finished rendering
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Get the Image object from the viewport texture
	var img: Image = get_texture().get_image()
	
	# Access individual pixel data or perform actions
	var pixel_color: Color = img.get_pixel(100, 100)
	print("Color at (00, 00): ", pixel_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
