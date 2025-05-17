class_name Tile extends Node2D

const TILE_PIXEL_SIZE = 16

var should_render: bool = true
var texture: Texture2D
var temperature
var grid_position: Vector2i
var can_walk: bool

func _init(position: Vector2i):
	grid_position.x = position.x
	grid_position.y = position.y

static func new_tile(position: Vector2i):
	var _noise_continentality = WorldNoise.get_continent_category(position)
	var _noise_temperature = WorldNoise.get_temperature_category(position)
	var _noise_vegetation = WorldNoise.get_vegetation_category(position)
	
	if _noise_continentality == Continentality.MOUNTAIN:
		return TileMountain.new(position, _noise_temperature)
	if _noise_continentality == Continentality.PLAINS:
		return TilePlains.new(position, _noise_temperature)
	if _noise_continentality == Continentality.OCEAN:
		return TileOcean.new(position, _noise_temperature)
	return TilePlains.new(position, Temperature.MILD)

func is_type(other_tile: Script) -> bool:
	return self.get_script() == other_tile

func _ready():
	position = Vector2(grid_position.x * TILE_PIXEL_SIZE, grid_position.y * TILE_PIXEL_SIZE)

func _draw():
	if should_render and texture:
		draw_texture(texture, Vector2(0, 0))
