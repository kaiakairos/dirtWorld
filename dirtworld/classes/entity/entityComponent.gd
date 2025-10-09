extends Node
class_name EntityComponent

@export var entity : Entity
var world : World
var worldContainer :WORLDCONTAINER

func _enter_tree() -> void:
	world = entity.world
	worldContainer = entity.worldContainer
