extends TileMap

class_name Map

@export var grid_size_x: int = 12
@export var grid_size_y: int = 12
@export var character_resources: Array[CharacterResource]
@export var character_scene: PackedScene
var center_offset_x: int
var center_offset_y: int
var selected_piece: Piece
var tiles: Array[Tile]

func _ready() -> void:
	generate_tilemap()
	
	for character_resource_index in range(character_resources.size()):
		var character_scene_instance = character_scene.instantiate() as Piece
		character_scene_instance.character_resource = character_resources[character_resource_index] as CharacterResource
		character_scene_instance.sprite.texture = character_scene_instance.character_resource.texture
		add_child(character_scene_instance)
		set_piece(tiles[character_resource_index].position, character_scene_instance, tiles)
	
func _process(_delta) -> void:
	var tile_position = local_to_map(get_global_mouse_position())
	hover_tilemap(tile_position)

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var tile_position = local_to_map(get_global_mouse_position())

			var piece = get_piece(tile_position, tiles)
			
			if piece: 
				selected_piece = piece
				remove_piece(piece.coordinate, tiles)
			else:
				set_piece(tile_position, selected_piece, tiles)
				selected_piece = null
				
					
func generate_tilemap() -> void:
	for x in grid_size_x: 
		for y in grid_size_y:
			var tile_position = Vector2(x, y)
			
			tiles.append(Tile.new("grass", tile_position))
			
			set_cell(0, tile_position, 0, Vector2i(0,0), 0)

func hover_tilemap(_tile_position: Vector2i) -> void:
	for x in grid_size_x: 
		for y in grid_size_y:
			erase_cell(1, Vector2(x + center_offset_x, y + center_offset_y)) 
	
	for tile in tiles:
		if(_tile_position == tile.position):
			set_cell(1, _tile_position, 1, Vector2i(0,0), 0)
			

func remove_piece(_position: Vector2i, _tiles: Array[Tile]) -> void:
	for tile in _tiles:
		if _position == tile.position:
			tile.piece = null

func get_piece(_position: Vector2i, _tiles: Array[Tile]) -> Piece:
	var piece: Piece = null
	
	for tile in _tiles:
		if _position == tile.position and tile.piece != null:
			piece = tile.piece
	
	return piece

func set_piece(_position: Vector2i, _piece: Piece, _tiles: Array[Tile]) -> void:
	if _piece == null: 
		return
	
	for tile in _tiles:
		if tile.position == _position:
			tile.piece = _piece
			tile.piece.coordinate = _position
