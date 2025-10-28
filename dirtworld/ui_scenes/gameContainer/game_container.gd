extends Node2D
class_name GameContainer

## Objects ##
@onready var world :World = $ViewportContainer/Viewport/World
@onready var viewport :SubViewport = $ViewportContainer/Viewport
@onready var viewportContainer :SubViewportContainer = $ViewportContainer
@onready var lightDrawer :LIGHTDRAWER = $LightMask/LIGHTDRAWER
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
	
	## UI STUFF ##
	
	if Input.is_action_just_pressed("inventory"):
		$UI/Inventory.toggleInventory()
	
	if Input.is_action_just_pressed("chatbox") and !$UI/ChatBox.showing:
		$UI/ChatBox.enable()
	
func changeWindowSize():
	var rect :Rect2 = get_viewport_rect()
	var width :int= int(rect.size.x)
	viewport.size.x = width + (width % 8) # viewport must always be divisible by 4
	viewportContainer.position.x = ((width % 8)/2)  * -1
	lightRenderSize = (width / 8) + 14
	$LightMask.position.x = viewportContainer.position.x
