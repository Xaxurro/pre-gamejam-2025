class_name TileMountain
extends Tile

func _init(x: int, y: int, new_temperature):
	super._init(x, y)
	can_walk = false
	temperature = new_temperature
	if temperature == Temperature.HOT:
		texture = load("res://assets/tiles/biomes/mountain/hot/base.png")
	if temperature == Temperature.MILD:
		texture = load("res://assets/tiles/biomes/mountain/mild/base.png")
	if temperature == Temperature.COLD:
		texture = load("res://assets/tiles/biomes/mountain/cold/base.png")
