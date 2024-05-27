extends Node2D
class_name Piece

var coordinate: Vector2i: set = set_coordinate
var resource: CharacterResource: set = set_character
var sprite: Sprite2D 
var map_tile_size: int = 32

func set_coordinate(_coordinate: Vector2i) -> void:
	coordinate = _coordinate
	var coordinate_x = _coordinate.x * map_tile_size + (map_tile_size / 2)
	var coordinate_y = _coordinate.y * map_tile_size + (map_tile_size / 2)
	global_position = Vector2(coordinate_x, coordinate_y)

func set_character(_resource: CharacterResource) -> void:
	sprite = $Sprite
	resource = _resource
	sprite.texture = resource.texture
