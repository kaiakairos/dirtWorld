extends Node2D

@export var worldContainer :WORLDCONTAINER
var tickTimer :float = 0.0
var tick :int = 0 # the game loop tick
const TICKRATE :int = 10

var positionLastFrame :Vector2i = Vector2i.ZERO # debug
var renderDistance :Vector2i = Vector2i(8,5) # test commit :)

func _ready() -> void:
	worldContainer.setBlockContainer(BlockManager.blockContainer)
	worldContainer.initializeArray(32,32)
	worldContainer.debugWorldGen()

func _process(delta: float) -> void:
	
	
	# all debug shit
	var dir :Vector2 = Vector2.ZERO
	dir.x =Input.get_axis("ui_left","ui_right")
	dir.y = Input.get_axis("ui_up","ui_down")
	$testCamera.position += dir * 120 * delta
	
	$testCamera/Label.text = "fps: " + str( int( 1.0 / delta ) )
	
	
	var trackingPosition = Vector2i($testCamera.global_position)
	trackingPosition = trackingPosition/64
	if positionLastFrame != trackingPosition:
		worldContainer.chunkLoadArea(trackingPosition.x,trackingPosition.y,renderDistance.x,renderDistance.y)
		worldContainer.unloadChunks(trackingPosition.x,trackingPosition.y,renderDistance.x,renderDistance.y)
		positionLastFrame = trackingPosition
		
	# advance game tick
	tickTimer += delta
	if tickTimer > 1.0 / float(TICKRATE):
		tickTimer -= 1.0 / float(TICKRATE)
		gameTick(delta)

func gameTick(delta:float) -> void:
	tick += 1
	worldContainer.simulateLoadedChunks(tick)
	
	
