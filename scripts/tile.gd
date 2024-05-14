extends Node

class_name Tile

var type: String
var position: Vector2i
var piece: Piece

func _init(_type: String, _position: Vector2i, _piece: Piece = null): 
	type = _type
	position = _position
	piece = _piece
	
