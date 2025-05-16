class_name Tile extends Node2D

const TILE_PIXEL_SIZE = 16

var should_render: bool = true
var texture: Texture2D
var temperature
var grid_x: int
var grid_y: int
var can_walk: bool

func _init(x: int, y: int):
	grid_x = x
	grid_y = y

static func new_tile(x: int, y: int, world_noise: WorldNoise):
	var continentality = world_noise.get_continent(x, y)
	var temperature = world_noise.get_temperature(x, y)
	
	if continentality == Continentality.MOUNTAIN:
		return TileMountain.new(x, y, temperature)
	if continentality == Continentality.PLAINS:
		return TilePlains.new(x, y, temperature)
	if continentality == Continentality.OCEAN:
		return TileOcean.new(x, y, temperature)
	return TilePlains.new(x, y, Temperature.MILD)

func is_type(other_tile: Script) -> bool:
	return self.get_script() == other_tile

func _ready():
	position = Vector2(grid_x * TILE_PIXEL_SIZE, grid_y * TILE_PIXEL_SIZE)

func _draw():
	if should_render and texture:
		draw_texture(texture, Vector2(0, 0))
