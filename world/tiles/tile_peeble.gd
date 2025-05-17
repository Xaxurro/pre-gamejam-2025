class_name TilePebble
extends Tile

var has_peebles
func _init(position: Vector2i):
	super._init(position)
	can_walk = false
	texture = load("res://assets/tiles/pebble/enabled.png")
	
	has_peebles = true
