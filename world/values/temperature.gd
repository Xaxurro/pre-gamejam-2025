class_name Temperature
extends RefCounted

enum {
	HOT,
	MILD,
	COLD
}

static var limits = [
	[Temperature.HOT, 1.00],
	[Temperature.MILD, -1.00],
	[Temperature.COLD, -5.0]
]

static func get_category(value: float):
	for pair in limits:
		var category = pair[0]
		var limit = pair[1]
		if value >= limit:
			return category
	return MILD
