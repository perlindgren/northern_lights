extends Node2D

const GROUP := "lit_canvas_modulate"

@onready var dummy_sprite_2d: Sprite2D = $SubViewport/LitSprite2D
@onready var sub_viewport: SubViewport = $SubViewport
@onready var sprite_2d: Sprite2D = $LitSprite2D

@export var pos : Vector2 = Vector2.ZERO
var amibient_light : Color = Color.WHITE

func _ready() -> void:
	var texture_size : Vector2 = sprite_2d.texture.get_size()
	print("sprite_2d ", texture_size)
	var texture : ImageTexture = create_solid_color_texture(texture_size.x, texture_size.y, Color.WHITE)
	dummy_sprite_2d.texture = texture
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	var main_world_2d = get_tree().root.find_world_2d() 
	if main_world_2d:
		print("found world")
		sub_viewport.world_2d = main_world_2d
	else:		
		print("no world found")	
		
	# Wait for two frames to ensure the viewport has finished rendering
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Get the Image object from the viewport texture
	var img: Image = sub_viewport.get_texture().get_image()
	
	# Access individual pixel data or perform actions
	var pixel_color: Color = img.get_pixel(0, 0)
	print("Color at (0, 0): ", pixel_color)
	
	print("get_tree().get_nodes_in_group(GROUP).size()", get_tree().get_nodes_in_group(GROUP).size())
	var lit_canvas_modulate : LitCanvasModulate = get_tree().get_nodes_in_group(GROUP)[0]	
	amibient_light = lit_canvas_modulate.color * lit_canvas_modulate.ambient_energy
	
	print("ambient light ", amibient_light)
	print("res", pixel_color - amibient_light)
	
	# Connect to Godot's frame rendering completion signal
	RenderingServer.frame_post_draw.connect(_on_frame_post_draw)
	
	while true:
		var tween = create_tween()
		tween.tween_method(
			func (a): position.x = a			
			, 128, 256, 3)
		await tween.finished

func create_solid_color_texture(width: int, height: int, color: Color) -> ImageTexture:
	#    Using FORMAT_RGBA8 keeps transparency info if needed
	var img = Image.create_empty(width, height, false, Image.FORMAT_RGBA8)
	img.fill(color)
	return ImageTexture.create_from_image(img)

func _on_frame_post_draw() -> void:
	print("------------")
	# await get_tree().process_frame
	# Get the Image object from the viewport texture
	var img: Image = sub_viewport.get_texture().get_image()
	var pixel_color: Color = img.get_pixel(pos.x, pos.y)
	print("Color at ", pos, ", ", pixel_color, ", res", pixel_color - amibient_light)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	## await get_tree().process_frame
	## Get the Image object from the viewport texture
	#var img: Image = sub_viewport.get_texture().get_image()
	#var pixel_color: Color = img.get_pixel(pos.x, pos.y)
	#print("Color at ", pos, ", ", pixel_color, ", res", pixel_color - amibient_light)
	#pass
