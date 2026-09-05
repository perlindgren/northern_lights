extends Node2D

# Called when the node enters the scene tree for the first time.

const GROUP := "lit_canvas_modulate"

	
@onready var sprite_2d: Sprite2D = $SubViewport/LitSprite2D
@onready var sub_viewport: SubViewport = $SubViewport

func _ready() -> void:
	# Wait for two frames to ensure the viewport has finished rendering
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Get the Image object from the viewport texture
	var img: Image = sub_viewport.get_texture().get_image()
	
	# Access individual pixel data or perform actions
	var pixel_color: Color = img.get_pixel(100, 100)
	print("Color at (00, 00): ", pixel_color)
	
	print("get_tree().get_nodes_in_group(GROUP).size()", get_tree().get_nodes_in_group(GROUP).size())
	var lit_canvas_modulate : LitCanvasModulate = get_tree().get_nodes_in_group(GROUP)[0]	
	var color : Color = lit_canvas_modulate.color
	
	print("color", color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
