extends Node2D
class_name Piece

@export var character_resource: CharacterResource: set = set_character
@export var sprite: Sprite2D: set = set_sprite
var coordinate: Vector2i :set = set_coordinate

func set_sprite(_sprite: Sprite2D):
	sprite = _sprite

func set_coordinate(_coordinate: Vector2i) -> void:
	coordinate = _coordinate
	global_position = Vector2(_coordinate.x * 32 + 16, _coordinate.y * 32 + 16)

func set_character(_character: CharacterResource) -> void:
	character_resource = _character
