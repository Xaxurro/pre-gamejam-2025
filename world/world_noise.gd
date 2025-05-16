class_name WorldNoise
extends RefCounted

func _generate_noise():
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = randi()
	return noise

var temperature: FastNoiseLite = _generate_noise()
var continent: FastNoiseLite = _generate_noise()
var decoration: FastNoiseLite = _generate_noise()

func _get_scaled_noise_on(noise: FastNoiseLite, x: int, y: int, scale: float):
	var value: float = noise.get_noise_2d(float(x), float(y)) * scale
	value = value * 1000
	value = int(value)
	return float(value) / 1000

func get_temperature(x: int, y: int):
	var value = _get_scaled_noise_on(temperature, x, y, 5)
	return Temperature.get_category(value)

func get_continent(x: int, y: int):
	var value = _get_scaled_noise_on(continent, x, y, 5)
	return Continentality.get_category(value)

func get_decoration(x: int, y: int):
	var value = _get_scaled_noise_on(decoration, x, y, 5)
	return Continentality.get_category(value)
