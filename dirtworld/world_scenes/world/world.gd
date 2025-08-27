extends Node2D

@export var worldContainer :WORLDCONTAINER

func _ready() -> void:
	worldContainer.setBlockContainer(BlockManager.blockContainer)
