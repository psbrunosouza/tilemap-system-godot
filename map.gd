extends TileMap

var character_scene = preload("res://piece.tscn")

@export var grid_size_x: int = 12
@export var grid_size_y: int = 9
var center_offset_x: int
var center_offset_y: int
var tilemap_dict: Dictionary
var selected_character: Piece

func _ready() -> void:
	selected_character = character_scene.instantiate()
	get_node('.').add_child(selected_character)
	generate_tilemap()
	var tilemap_first_item = tilemap_dict.keys()[0]
	set_object_on_tilemap_position(tilemap_dict[tilemap_first_item]["position"])
	
func _process(_delta) -> void:
	var tile_position = local_to_map(get_global_mouse_position())
	hover_tilemap(tile_position)

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var tile_position = local_to_map(get_global_mouse_position())
			
			if tilemap_dict.has(str(tile_position)):
				if not has_selected_character():
					select_tile(tile_position)
				else:
					set_object_on_tilemap_position(tile_position)
			
func generate_tilemap() -> void:
	center_offset_x = int((get_viewport_rect().size.x / 32 - grid_size_x) / 2)
	center_offset_y = int((get_viewport_rect().size.y / 32 - grid_size_y) / 2)
	
	for x in grid_size_x: 
		for y in grid_size_y:
			var tile_position = Vector2(x + center_offset_x, y + center_offset_y)
			
			tilemap_dict[str(tile_position)] = {
				"type": "grass",
				"position": tile_position,
				"object": null
			}
			
			set_cell(0, tile_position, 0, Vector2i(0,0), 0)

func hover_tilemap(_tile_position: Vector2i) -> void:
	for x in grid_size_x: 
		for y in grid_size_y:
			erase_cell(1, Vector2(x + center_offset_x, y + center_offset_y)) 
	
	if tilemap_dict.has(str(_tile_position)):
		set_cell(1, _tile_position, 1, Vector2i(0,0), 0)
	

func select_tile(_position: Vector2) -> void:
	var object = get_object_on_tilemap_position(_position)
	
	if object == null:
		return
	
	store_character(object)

func set_object_on_tilemap_position(_position: Vector2) -> void:
	if selected_character.coordinate != Vector2i.ZERO:
		var previous_position = selected_character.coordinate
		tilemap_dict[str(previous_position)]["object"] = null
		
	tilemap_dict[str(_position)]["object"] = selected_character
	selected_character.coordinate = _position
	selected_character = null

func get_object_on_tilemap_position(_position: Vector2) -> Node: 
	return tilemap_dict[str(_position)]["object"]

func has_selected_character() -> bool:
	return selected_character != null
		
func store_character(_character: CharacterBody2D) -> void:
	selected_character = _character

func clear_character() -> void:
	selected_character = null
