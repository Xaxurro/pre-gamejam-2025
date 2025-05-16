class_name TilePebble
extends Tile

var has_peebles
func _init(x: int, y: int):
	super._init(x, y)
	can_walk = false
	texture = load("res://assets/tiles/pebble/enabled.png")
	
	has_peebles = true
