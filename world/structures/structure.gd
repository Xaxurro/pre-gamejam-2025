class_name Structure
extends Node2D

var dimensions: Vector2i = Vector2i(0, 0)

var should_render: bool = true
var texture: Texture2D
var grid_position: Vector2i
var can_walk: bool


func _init(position: Vector2i):
	self.z_index = 1
	grid_position = position

func is_type(other_tile: Script) -> bool:
	return self.get_script() == other_tile

func _ready():
	position = Vector2(grid_position.x * Tile.TILE_PIXEL_SIZE, grid_position.y * Tile.TILE_PIXEL_SIZE)

func _draw():
	if should_render and texture:
		draw_texture(texture, Vector2(-1 * Tile.TILE_PIXEL_SIZE * (dimensions.x - 1), -1 * Tile.TILE_PIXEL_SIZE * (dimensions.y - 1)))
