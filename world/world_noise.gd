class_name WorldNoise
extends RefCounted

static func _generate_noise():
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = randi()
	return noise

static var temperature: FastNoiseLite = _generate_noise()
static var continent: FastNoiseLite = _generate_noise()
static var vegetation: FastNoiseLite = _generate_noise()

static func _get_scaled_noise_on(noise: FastNoiseLite, position: Vector2i, scale: float, limits: Vector2):
	var value: float = noise.get_noise_2d(float(position.x), float(position.y)) * scale
	if value > limits.x: value = limits.x
	if value < limits.y: value = limits.y
	return value

static func get_temperature_at(position: Vector2i) -> float:
	return _get_scaled_noise_on(temperature, position, 1.5, Vector2(1.0, -1.0))

static func get_temperature_category(position: Vector2i) -> int:
	return Temperature.get_category_index(get_temperature_at(position))


static func get_continent_at(position: Vector2i) -> float:
	return _get_scaled_noise_on(continent, position, 2, Vector2(1.0, -1.0))
	
static func get_continent_category(position: Vector2i) -> int:
	return Continentality.get_category_index(get_continent_at(position))


static func get_vegetation_at(position: Vector2i) -> float:
	return _get_scaled_noise_on(vegetation, position, 2, Vector2(1.0, -1.0))
	
static func get_vegetation_category(position: Vector2i) -> int:
	return Vegetation.get_category_index(get_vegetation_at(position))
