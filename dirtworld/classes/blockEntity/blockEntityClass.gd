extends Node2D
class_name BlockEntity

var world:World
var worldContainer:WORLDCONTAINER
var tilePos :Vector2i = Vector2i(-1,-1)

@export_enum("DELETE","PAUSEPROCESSING","NOTHING") var unloadBehavior :int = 0

func _ready() -> void:
	world.connect("loadedAreaChanged",onLoadedAreaChanged)
	onReady()

func onReady() -> void:
	pass

func checkIfPos(thisPos:Vector2i) -> bool:
	return thisPos == tilePos

func onLoadedAreaChanged() -> void:
	if unloadBehavior == 2:
		return
		
	if !worldContainer.isTileLoaded(tilePos.x,tilePos.y):
		queue_free()
