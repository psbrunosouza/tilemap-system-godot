extends TileMap

class_name Map

@onready var character_scene = preload("res://scenes/piece.tscn")

@export var piece_resources: Array[CharacterResource] = []
@export var grid_size_x: int = 12
@export var grid_size_y: int = 12

var selected_piece: Piece
var tiles: Array[Tile]
var pieces: Array[Piece]

func _ready() -> void:
	generate_tilemap()
	
	for piece_resource in piece_resources:
		var piece = character_scene.instantiate() as Piece
		piece.set_character(piece_resource)
		add_child(piece)
		pieces.append(piece)
	
	if pieces.is_empty():
		return
	
	set_piece(Vector2(0,0), pieces[0], tiles)
	set_piece(Vector2(1,0), pieces[1], tiles)
	
func _process(_delta) -> void:
	var tile_position = local_to_map(get_global_mouse_position())
	hover_tilemap(tile_position)

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var tile_position = local_to_map(get_global_mouse_position())
			var piece = get_piece(tile_position, tiles)
			select_piece(piece, tile_position)

func select_piece(piece: Piece, coordinate: Vector2i):
	if piece: 
		selected_piece = piece
		remove_piece(piece.coordinate, tiles)
		calculate_possible_movements(selected_piece, selected_piece.coordinate)
	else:
		var can_move = is_able_to_move(selected_piece, selected_piece.coordinate, coordinate)
		if can_move:
			set_piece(coordinate, selected_piece, tiles)
			selected_piece = null
			for x in grid_size_x: 
				for y in grid_size_y:
					erase_cell(2, Vector2(x, y)) 

func calculate_possible_movements(piece: Piece, previous_coordinate: Vector2i) -> void:
	if piece.resource.moves.is_empty():
		return
		
	for move in piece.resource.moves:
		var possible_movement = previous_coordinate + move
		for tile in tiles:
			if(tile.position == possible_movement):
				set_cell(2, tile.position, 2, Vector2i(0,0), 0)

func is_able_to_move(piece: Piece, previous_coordinate: Vector2i, next_coordinate: Vector2i) -> bool:
	if piece.resource.moves.is_empty():
		return false
	
	for move in piece.resource.moves:
		var possible_movement = previous_coordinate + move
		if possible_movement == next_coordinate:
			return true
		
	return false

func generate_tilemap() -> void:
	for x in grid_size_x: 
		for y in grid_size_y:
			var tile_position = Vector2(x, y)
			
			tiles.append(Tile.new("grass", tile_position))
			
			set_cell(0, tile_position, 0, Vector2i(0,0), 0)

func hover_tilemap(_tile_position: Vector2i) -> void:
	for x in grid_size_x: 
		for y in grid_size_y:
			erase_cell(1, Vector2(x, y)) 
	
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

func set_piece(_coordinate: Vector2i, _piece: Piece, _tiles: Array[Tile]) -> void:
	if _piece == null: 
		return
	
	for tile in _tiles:
		if tile.position == _coordinate:
			tile.piece = _piece
			tile.piece.coordinate = _coordinate
