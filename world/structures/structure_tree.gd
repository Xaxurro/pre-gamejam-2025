class_name StructureTree
extends Structure

func _init(position: Vector2i):
	super._init(position)
	dimensions = Vector2i(1, 2)
	can_walk = false
	texture = load("res://assets/structures/tree.png")
