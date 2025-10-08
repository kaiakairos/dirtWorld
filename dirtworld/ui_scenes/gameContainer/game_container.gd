extends Node2D
class_name GameContainer

## Objects ##
@onready var world :World = $ViewportContainer/Viewport/World
@onready var viewport :SubViewport = $ViewportContainer/Viewport
@onready var lightViewport :SubViewport = $LightViewportContainer/LightViewport
@onready var lightDrawer :LIGHTDRAWER = $LIGHTDRAWER
	# Debug
@onready var fpsLabel :Label = $fpsLabel

# Lighting
var lightRenderSize :int = 64

func _ready() -> void:
	get_viewport().size_changed.connect(changeWindowSize)
	
	#world.setLightMask(viewport.get_texture())
	lightDrawer.material.set_shader_parameter("lightingMask",viewport.get_texture())
	
func _process(delta: float) -> void:
	fpsLabel.text = "fps: " + str( int( 1.0 / delta ) )
	
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	
func changeWindowSize():
	var rect :Rect2 = get_viewport_rect()
	var width :int= int(rect.size.x)
	viewport.size.x = width
	lightViewport.size.x = width
	lightRenderSize = (width / 8) + 14
