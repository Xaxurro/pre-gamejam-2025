class_name TileOcean
extends Tile

func _init(position: Vector2i, new_temperature):
	super._init(position)
	can_walk = false
	temperature = new_temperature
	if temperature == Temperature.HOT:
		texture = load("res://assets/tiles/biomes/ocean/hot/base.png")
	if temperature == Temperature.MILD:
		texture = load("res://assets/tiles/biomes/ocean/mild/base.png")
	if temperature == Temperature.COLD:
		texture = load("res://assets/tiles/biomes/ocean/cold/base.png")
