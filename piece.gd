extends CharacterBody2D

class_name Piece

var coordinate: Vector2i :set = set_coordinate

func set_coordinate(value: Vector2i) -> void:
	coordinate = value
	global_position = Vector2(value.x * 32 + 16, value.y * 32 + 16)
