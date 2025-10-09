extends Node2D
class_name World

@export var worldContainer :WORLDCONTAINER
@export var camera : Camera2D
var tickTimer :float = 0.0
var tick :int = 0 # the game loop tick
const TICKRATE :int = 15

var positionLastFrame :Vector2i = Vector2i.ZERO # debug
var renderDistance :Vector2i = Vector2i(8,5)

@onready var gameContainer :GameContainer = get_parent().get_parent().get_parent()

func _ready() -> void:
	worldContainer.setBlockContainer(BlockManager.blockContainer)
	worldContainer.initializeArray(32,32)
	worldContainer.debugWorldGen()

func _process(delta: float) -> void:
	
	# all debug shit
	var dir :Vector2 = Vector2.ZERO
	dir.x =Input.get_axis("ui_left","ui_right")
	dir.y = Input.get_axis("ui_up","ui_down")
	camera.position += dir * 120 * delta
	
	var trackingPosition = Vector2i(camera.global_position)
	trackingPosition = trackingPosition/64
	if positionLastFrame != trackingPosition:
		worldContainer.chunkLoadArea(trackingPosition.x,trackingPosition.y,renderDistance.x,renderDistance.y)
		worldContainer.unloadChunks(trackingPosition.x,trackingPosition.y,renderDistance.x,renderDistance.y)
		print(trackingPosition)
		
		positionLastFrame = trackingPosition
		
	# advance game tick
	tickTimer += delta
	if tickTimer > 1.0 / float(TICKRATE):
		tickTimer -= 1.0 / float(TICKRATE)
		gameTick(delta)
	
	drawLighting()
	

func drawLighting() -> void:
	var l :Vector2i = (positionLastFrame * 8) - Vector2i(28,20)
	var size :int = gameContainer.lightRenderSize
	var worldCoords :Vector2i = Vector2i(l.x + (32 - (size/2)), l.y )
	gameContainer.lightDrawer.drawLight(worldContainer,worldCoords.x,worldCoords.y,size,50)
	#setLightPosition()

func setLightPosition() -> void:
	var l :Vector2i = (positionLastFrame * 8) - Vector2i(28,20)
	var size :int = gameContainer.lightRenderSize
	var worldCoords :Vector2i = Vector2i(l.x + (32 - (size/2)), l.y )
	var pos :Vector2 = worldCoords * 8
	var rect :Rect2 = get_viewport_rect()
	var width :int= int(rect.size.x)
	gameContainer.lightDrawer.position = pos - getTargetPosition() + Vector2(width/2,150)
	gameContainer.lightDrawer.position.x = roundi(gameContainer.lightDrawer.position.x)
	gameContainer.lightDrawer.position.y = roundi(gameContainer.lightDrawer.position.y)
	print(gameContainer.lightDrawer.position)

func gameTick(_delta:float) -> void:
	tick += 1
	worldContainer.simulateLoadedChunks(tick)

func getTargetPosition() -> Vector2:
	return camera.position
