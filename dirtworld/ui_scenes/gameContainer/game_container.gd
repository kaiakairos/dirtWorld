extends Node2D

func _ready() -> void:
	get_viewport().size_changed.connect(changeWindowSize)

func changeWindowSize():
	var rect :Rect2 = get_viewport_rect()
	var width :int= int(rect.size.x)
	#lightRender = (width / 8) + 14
