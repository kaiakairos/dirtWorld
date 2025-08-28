extends Node2D

@export var worldContainer :WORLDCONTAINER
var ticks :float = 0.0
var flip :int = 4

var positionLastFrame :Vector2i = Vector2i.ZERO

func _ready() -> void:
	worldContainer.setBlockContainer(BlockManager.blockContainer)
	worldContainer.initializeArray(32,32)
	worldContainer.debugWorldGen()

func _process(delta: float) -> void:

	var mousePos = Vector2i(get_global_mouse_position())
	mousePos = mousePos/64
	if positionLastFrame != mousePos:
		worldContainer.chunkLoadArea(mousePos.x,mousePos.y,5,4)
		positionLastFrame = mousePos
