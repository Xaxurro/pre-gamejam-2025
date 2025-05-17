class_name Entity
extends CharacterBody2D

var dimensions: Vector2i = Vector2i(0, 0)

var should_render: bool = true
var texture: Texture2D

func _init(position: Vector2i):
	self.z_index = 1
	self.position = position

func is_type(other_tile: Script) -> bool:
	return self.get_script() == other_tile

func _ready():
	self.position = Vector2(position.x * Tile.TILE_PIXEL_SIZE, position.y * Tile.TILE_PIXEL_SIZE)

func _draw():
	if should_render and texture:
		draw_texture(texture, Vector2(-1 * Tile.TILE_PIXEL_SIZE * (dimensions.x - 1), -1 * Tile.TILE_PIXEL_SIZE * (dimensions.y - 1)))
