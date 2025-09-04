extends Node2D

@export var worldContainer :WORLDCONTAINER
var tickTimer :float = 0.0
var tick :int = 0 # the game loop tick
const TICKRATE :int = 15

var positionLastFrame :Vector2i = Vector2i.ZERO # debug
var renderDistance :Vector2i = Vector2i(8,5) # test commit :)

# light 
var lightRender :int = 64

func _ready() -> void:
	worldContainer.setBlockContainer(BlockManager.blockContainer)
	worldContainer.initializeArray(32,32)
	worldContainer.debugWorldGen()
	
	get_viewport().size_changed.connect(changeWindowSize)

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
		print(trackingPosition)
		# debug light update
		#$LIGHTDRAWER.position = trackingPosition * 64
		
		
		positionLastFrame = trackingPosition
		
	# advance game tick
	tickTimer += delta
	if tickTimer > 1.0 / float(TICKRATE):
		tickTimer -= 1.0 / float(TICKRATE)
		gameTick(delta)
	
	var l :Vector2i = (positionLastFrame * 8) - Vector2i(28,20)
	$LIGHTDRAWER.drawLight($WORLDCONTAINER,l.x + (32 - (lightRender/2)),l.y,lightRender,50)
	

func gameTick(delta:float) -> void:
	tick += 1
	worldContainer.simulateLoadedChunks(tick)

func changeWindowSize():
	var rect :Rect2 = get_viewport_rect()
	var width :int= int(rect.size.x)
	lightRender = (width / 8) + 14
