extends Node2D
class_name GameContainer

## Objects ##
@onready var world :World = $ViewportContainer/Viewport/World
@onready var viewport :SubViewport = $ViewportContainer/Viewport
@onready var viewportContainer :SubViewportContainer = $ViewportContainer
@onready var lightDrawer :LIGHTDRAWER = $LightMask/LIGHTDRAWER
	# Debug
@onready var fpsLabel :Label = $fpsLabel

var camera :Camera2D

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
	
	## UI STUFF ##
	
	if Input.is_action_just_pressed("inventory"):
		$UI/Inventory.toggleInventory()
	
	if is_instance_valid(camera):
		$SubViewportContainer/SubViewport/BackgroundCover.material.set_shader_parameter("urgh",camera.position * 0.1)
		$SubViewportContainer/SubViewport/Parallax2D.scroll_offset = (camera.position * Vector2(-0.35,-0.5)) + Vector2(0,50)
		$SubViewportContainer/SubViewport/Parallax2D2.scroll_offset = (camera.position * -0.20) + Vector2(Time.get_ticks_msec() * 0.006,0)

func changeWindowSize():
	var rect :Rect2 = get_viewport_rect()
	var width :int= int(rect.size.x)
	viewport.size.x = width + (width % 8) # viewport must always be divisible by 4
	viewportContainer.position.x = ((width % 8)/2)  * -1
	lightRenderSize = (width / 8) + 14
	$LightMask.position.x = viewportContainer.position.x
	$UI/RightSide.position.x = rect.size.x
	$SubViewportContainer/SubViewport.size.x = viewport.size.x
	$DropShadow.position = viewportContainer.position + Vector2(0.5,0.5)
