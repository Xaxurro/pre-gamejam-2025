class_name World
extends TileMapLayer

# Size of the map
@export var size: Vector2i
# Seed of the map
@export var seed: int
# If false it will not populate the world with trees and pebbles
@export var should_populate: bool

# this is where tiles are actually stored
# used to access them with [] rather than godot's nodes
var tiles = []

# This is updated on _build_world
# used to get the tile's position within the `tiles` array
var offset := Vector2.ZERO

# *-1 because i want negative coordinates
# + 1 because i want to use the 0 coordinates
func _get_coordinates_array(axis: int):
	return range(axis * -1, axis + 1)

# returns the index with the offset
func _apply_array_x_offset(index: int) -> int:
	return index + int(offset.x)

# returns the index with the offset
func _apply_array_y_offset(index: int) -> int:
	return index + int(offset.y)

# you get the whole row (y-axis tiles)
func _get_tile_row_at(x: int) -> Array:
	return tiles[_apply_array_x_offset(x)]

#You get the tile at said coordinates
func get_tile_at(position: Vector2i) -> Tile:
	return tiles[_apply_array_x_offset(position.x)][_apply_array_y_offset(position.y)]

func _replace_tile(previous_tile: Tile, new_tile_class: Script) -> void:
	# get the position, make the new tile, replace it on the tiles array, remove the old one from the nodes and add the new tile
	var grid_position: Vector2i = previous_tile.grid_position
	var new_tile = new_tile_class.new(grid_position)
	tiles[_apply_array_x_offset(grid_position.x)][_apply_array_y_offset(grid_position.y)] = new_tile
	$Tiles.remove_child(previous_tile)
	previous_tile.queue_free()
	$Tiles.add_child(new_tile)

#TODO: Make an 2D Array for structures, they should be on top of tiles
func _add_structure(source_tile: Tile, new_structure_class: Script) -> void:
	var grid_position: Vector2i = source_tile.grid_position
	var new_structure = new_structure_class.new(grid_position)
	#tiles[_apply_array_x_offset(grid_position.x)][_apply_array_y_offset(grid_position.y)] = new_tile
	$Structures.add_child(new_structure)

func _build_world():
	print_rich("[color=yellow]Building World! ", size, "[/color]")
	offset = size
	
	# start 2d array
	tiles.resize(int(size.x * 2 + 1))
	for i in range(tiles.size()):
		tiles[i] = []
	
	# Loop through the coordinates
	for x in _get_coordinates_array(size.x):
		for y in _get_coordinates_array(size.y):
			var newTile = Tile.new_tile(Vector2i(x, y))		#each tile gets info from world_noise
			_get_tile_row_at(x).append(newTile)				#Add it to the array for logic
			$Tiles.add_child(newTile)						#Add it to the node for render
	print_rich("[color=green]World Builded![/color]")
	Temperature.print_generated_values()
	Continentality.print_generated_values()
	Vegetation.print_generated_values()

func _add_pebbles(position: Vector2i) -> void:
	# gets the tile, if it's not plains or it's not the right Temperature then don't put pebbles
	var target_tile = get_tile_at(position)
	if target_tile is not TilePlains or target_tile.temperature != Temperature.MILD: return
	
	# Get the continentality on it's noisemap
	# then take the difference between the category's upper limit and the tile's continentality
	# if within threshold put pebbles
	const THRESHOLD: float = 0.01
	var continent: float = WorldNoise.get_continent_at(position)
	var ocean: Dictionary = Continentality.get_category(Continentality.OCEAN)
	var is_valid: bool = abs(continent - ocean.upper_limit) <= THRESHOLD
	
	if is_valid: _replace_tile(target_tile, TilePebble)

func _add_tree(position: Vector2i) -> void:
	# gets the tile, if it's not plains or it's not the right Temperature then don't put trees
	var target_tile = get_tile_at(position)
	if target_tile is not TilePlains or target_tile.temperature != Temperature.MILD: return
	
	# Get the continentality on it's noisemap
	# then take the difference between the category's limits and the tile's continentality
	# if within threshold check for vegetation
	const THRESHOLD_CONTINENT: float = 0.10
	var continent: float = WorldNoise.get_continent_at(position)
	var plains: Dictionary = Continentality.get_category(Continentality.PLAINS)
	var is_valid: bool = abs(continent - (plains.upper_limit + plains.lower_limit) / 2) <= THRESHOLD_CONTINENT
	if not is_valid: return
	
	# Get the vegetation on it's noisemap
	# then take the difference between the category's limits and the tile's vegetation
	# if within threshold check put a tree
	const THRESHOLD_VEGETATION: float = 0.25
	var vegetation: float = WorldNoise.get_vegetation_at(position)
	var normal: Dictionary = Vegetation.get_category(Vegetation.NORMAL)
	is_valid = abs(vegetation - (normal.upper_limit + normal.lower_limit) / 2) <= THRESHOLD_VEGETATION
	if is_valid: _add_structure(target_tile, StructureTree)

# Loop through every tile and populate
func _populate_world():
	print_rich("[color=yellow]Populating World![/color]")
	for x in _get_coordinates_array(size.x):
		for y in _get_coordinates_array(size.y):
			var position: Vector2i = Vector2i(x, y)
			_add_pebbles(position)
			_add_tree(position)
	print_rich("[color=green]World Populated![/color]")

func _spawn_player():
	const player_scene = preload("res://entities/player/player.tscn")
	var player_instance = player_scene.instantiate()
	player_instance.global_position = Vector2i(0, 0)
	add_child(player_instance)

func _ready():
	_build_world()
	if should_populate: 
		_populate_world()
	else:
		print_rich("[color=red]SKIPPING POPULATION[/color]")
	_spawn_player()
	
