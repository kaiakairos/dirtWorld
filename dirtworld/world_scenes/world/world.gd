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

@export var blockBreakContainer :Node2D

var randomTickThread: Thread
var threadEnabled:bool = false



func _ready() -> void:
	worldContainer.setBlockContainer(BlockManager.blockContainer)
	worldContainer.initializeArray(64,512)
	worldContainer.debugWorldGen(16)
	worldContainer.setBGAmbientOcclusionImage( load("res://world_scenes/world/chunk/backgroundAmbientOcclusion.png").get_image() )
	worldContainer.setBGCutOutImage( load("res://world_scenes/world/chunk/backgroundCutout.png").get_image(),load("res://world_scenes/world/chunk/backgroundCutoutEdge.png").get_image() )
	
	
	

func _thread_function(userdata):
	
	pass

func _exit_tree():
	pass

func _process(delta: float) -> void:
	
	var trackingPosition = Vector2i(camera.global_position)
	trackingPosition = trackingPosition/64
	if positionLastFrame != trackingPosition:
		worldContainer.chunkLoadArea(trackingPosition.x,trackingPosition.y,renderDistance.x,renderDistance.y)
		worldContainer.unloadChunks(trackingPosition.x,trackingPosition.y,renderDistance.x,renderDistance.y)
		positionLastFrame = trackingPosition
		
	# advance game tick
	
	tickTimer += delta
	
	parseLightQueue()
	if tickTimer > 1.0 / float(TICKRATE):
		tickTimer -= 1.0 / float(TICKRATE)
		gameTick(delta)
		parseLightQueue()
	
	drawLighting()
	
	queueLightChanges = {}

var queueLightChanges :Dictionary[Vector2i,Color]
func appendQueue(vec:Vector2i,r:float,g:float,b:float) -> void:
	queueLightChanges[vec] = Color(r,g,b,1.0)

func parseLightQueue() -> void:
	for i in queueLightChanges.keys():
		var c :Color = queueLightChanges[i]
		worldContainer.setLightData(i.x,i.y,c.r,c.g,c.b)

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
	gameContainer.lightDrawer.position = pos - getTargetPosition() + Vector2(width/2.0,150)
	gameContainer.lightDrawer.position.x = roundi(gameContainer.lightDrawer.position.x)
	gameContainer.lightDrawer.position.y = roundi(gameContainer.lightDrawer.position.y)

func gameTick(_delta:float) -> void:
	tick += 1
	worldContainer.simulateRandomTick(tick,6000)
	worldContainer.simulateLoadedChunks(tick)

func getTargetPosition() -> Vector2:
	return camera.position

@onready var blockBreakScene = preload("res://data/entity/blockBreak/block_break.tscn")
func getBlockBreak(tile:Vector2i) -> BlockBreaker:
	for child in blockBreakContainer.get_children():
		if child.tile == tile:
			return child
	
	var block :String= worldContainer.getBlock(tile.x,tile.y)
	if BlockManager.isBlockIndestructible(block):
		return null
	
	var ins :BlockBreaker= blockBreakScene.instantiate()
	ins.position = tile * 8
	ins.tile = tile
	ins.blockHealth = BlockManager.getBlockHealth(block)
	ins.worldContainer = worldContainer
	blockBreakContainer.add_child(ins)
	return ins

@onready var groundItemScene :PackedScene = preload("res://data/entity/groundItem/ground_item.tscn")
func _on_worldcontainer_drop_ground_item(itemID: String, amount: int,tileX:int,tileY:int) -> void:
	var newItemInstance :ItemInstance = ItemManager.generateNewItemInstance(itemID,amount)
	var groundItem :GroundItem = groundItemScene.instantiate()
	groundItem.itemInstance = newItemInstance
	groundItem.world = self
	groundItem.position = Vector2(tileX * 8,tileY * 8) + Vector2(4,4)
	groundItem.velocity = Vector2(randf_range(-20.0,20.0),-20.0)
	$EntityContainer/GroundItems.add_child(groundItem)
	
func setCameraZoom(v:float) -> void:
	camera.zoom = Vector2(v,v)
