class_name EntityPlayer
extends Entity

@export var movement_speed: float = 10.0
func _init():
	super._init(Vector2i(0, 0))
	dimensions = Vector2i(1, 1)
	texture = load("res://assets/entities/player/idle/front.png")

func _physics_process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit(0)
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction.y += -1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x += -1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	velocity = direction * movement_speed
	var target_position = global_position + velocity * delta
	var target_grid_position = Vector2i(
		floor(target_position.x / Tile.TILE_PIXEL_SIZE),
		floor(target_position.y / Tile.TILE_PIXEL_SIZE)
	)
	
	var world: World = get_parent()
	var target_tile: Tile = world.get_tile_at(target_grid_position)
	if (target_grid_position.x > abs(world.size.x) or target_grid_position.y > abs(world.size.y)) or target_tile != null and not target_tile.can_walk:
		velocity = Vector2.ZERO
	
	move_and_slide()
