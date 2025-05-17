class_name TilePlains
extends Tile

func _init(position: Vector2i, new_temperature: int):
	super._init(position)
	can_walk = true
	temperature = new_temperature
	if temperature == Temperature.HOT:
		texture = load("res://assets/tiles/biomes/plains/hot/base.png")
	if temperature == Temperature.MILD:
		texture = load("res://assets/tiles/biomes/plains/mild/base.png")
	if temperature == Temperature.COLD:
		texture = load("res://assets/tiles/biomes/plains/cold/base.png")
