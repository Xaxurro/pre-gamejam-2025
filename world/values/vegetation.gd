class_name Vegetation
extends RefCounted

enum {
	A_LOT,
	NORMAL,
	LITTLE
}

static var highest: float = 0.0
static func _set_highest(new_value: float) -> void: highest = new_value
static var lowest: float = 0.0
static func _set_lowest(new_value: float) -> void: lowest = new_value

static func print_generated_values() -> void:
	print("Highest Vegetation:",Vegetation.highest)
	print("Lowest Vegetation:",Vegetation.lowest)

static var limits = {
	Vegetation.A_LOT: {
		upper_limit = 1.0,
		lower_limit = 0.5
	},
	Vegetation.NORMAL: {
		upper_limit = 0.5,
		lower_limit = -0.5
	},
	Vegetation.LITTLE: {
		upper_limit = -0.5,
		lower_limit = -1.0
	}
}

static func get_category(enumeration: int) -> Dictionary:
	return limits[enumeration]

static func get_category_index(value: float) -> int:
	if highest < value: _set_highest(value)
	if lowest > value: _set_lowest(value)
	for index in limits:
		var category: Dictionary = limits[index]
		if value >= category.lower_limit and value <= category.upper_limit:
			return index
	return NORMAL
