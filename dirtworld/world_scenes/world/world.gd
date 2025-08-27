extends Node2D

@export var worldContainer :WORLDCONTAINER
var ticks :float = 0.0

func _ready() -> void:
	worldContainer.setBlockContainer(BlockManager.blockContainer)
	worldContainer.initializeArray(8,8)

func _process(delta: float) -> void:
	ticks += delta
	if ticks > 0.5:
		for i in worldContainer.get_children():
			i.queue_free()
		worldContainer.debugWorldGen()
		ticks = 0.0
