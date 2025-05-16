class_name Continentality
extends RefCounted

enum {
	MOUNTAIN,
	PLAINS,
	OCEAN
}

static var limits = [
	[Continentality.MOUNTAIN, 1.25],
	[Continentality.PLAINS, -0.75],
	[Continentality.OCEAN, -5.0]
]

static func get_category(value: float):
	for pair in limits:
		var category = pair[0]
		var limit = pair[1]
		if value >= limit:
			return category
	return PLAINS
