extends TileMapLayer

@export var size: Vector2
@export var seed: int

var tiles = []
var offset := Vector2.ZERO

# *-1 because i want negative coordinates
# + 1 because i want to use the 0 coordinates
func _get_coordinates_array(axis: int):
	return range(axis * -1, axis + 1)

func _apply_array_x_offset(index: int) -> int:
	return index + int(offset.x)
	
func _apply_array_y_offset(index: int) -> int:
	return index + int(offset.y)
	
func _get_tile_row_at(x: int) -> Array:
	return tiles[_apply_array_x_offset(x)]

func _get_tile_at(x: int, y: int) -> Tile:
	return tiles[_apply_array_x_offset(x)][_apply_array_y_offset(y)]

func _replace_tile(previous_tile: Tile, new_tile_class: Script) -> void:
	var grid_x: int = previous_tile.grid_x
	var grid_y: int = previous_tile.grid_y
	var new_tile = new_tile_class.new(grid_x, grid_y)
	tiles[_apply_array_x_offset(grid_x)][_apply_array_y_offset(grid_y)] = new_tile
	$Tiles.remove_child(previous_tile)
	previous_tile.queue_free()
	$Tiles.add_child(new_tile)

func _build_world():
	print("Building World!")
	var world_noise: WorldNoise = WorldNoise.new()
	offset = size
	
	# Inicializar la matriz de tiles
	tiles.resize(int(size.x * 2 + 1))
	for i in range(tiles.size()):
		tiles[i] = []
	
	for x in _get_coordinates_array(size.x):
		for y in _get_coordinates_array(size.y):
			var newTile = Tile.new_tile(x, y, world_noise)	#each tile gets info from world_noise
			_get_tile_row_at(x).append(newTile)		#Add it to the array for logic
			$Tiles.add_child(newTile)						#Add it to the node for render
	print("World Builded!")


func _get_tile_neighbours(tile: Tile, radius: int):
	var neighbours: Array[Tile] = []

	var lower_x: int = max(tile.grid_x - radius, -int(size.x))
	var upper_x: int = min(tile.grid_x + radius, int(size.x))
	var lower_y: int = max(tile.grid_y - radius, -int(size.y))
	var upper_y: int = min(tile.grid_y + radius, int(size.y))

	for x in range(lower_x, upper_x+ 1):
		for y in range(lower_y, upper_y + 1):
			if x == tile.grid_x and y == tile.grid_y: continue
			var current_tile = _get_tile_at(x, y)
			neighbours.append(current_tile)

	return neighbours

func _count_neighbours(tile: Tile, radius: int, tile_type: Script, goal: int) -> bool:
	var neighbours: Array[Tile] = []
	var count = 0

	var lower_x: int = max(tile.grid_x - radius, -int(size.x))
	var upper_x: int = min(tile.grid_x + radius, int(size.x))
	var lower_y: int = max(tile.grid_y - radius, -int(size.y))
	var upper_y: int = min(tile.grid_y + radius, int(size.y))
	
	for x in range(lower_x, upper_x+ 1):
		for y in range(lower_y, upper_y + 1):
			if x == tile.grid_x and y == tile.grid_y: continue #exclude from neighbours
			var current_tile = _get_tile_at(x, y)
			if current_tile.is_type(tile_type):
				count += 1
				if count == goal:
					return true
	return false

func _add_pebbles(x: int, y: int):
	var target_tile = _get_tile_at(x, y)
	if target_tile is not TilePlains or target_tile.temperature != Temperature.MILD: return
	const RADIUS: int = 2
	const REQUIRED_WATER: int = 5
	var is_valid: bool = _count_neighbours(target_tile, RADIUS, TileOcean, REQUIRED_WATER)
	if is_valid: _replace_tile(target_tile, TilePebble)

func _populate_world():
	print("Populating World!")
	for x in _get_coordinates_array(size.x):
		for y in _get_coordinates_array(size.y):
			_add_pebbles(x, y)
	
	print("World Populated!")

func _ready():
	_build_world()
	#_populate_world()
