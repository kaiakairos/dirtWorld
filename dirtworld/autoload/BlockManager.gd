extends Node

@onready var blockContainer :BLOCKCONTAINER = BLOCKCONTAINER.new()

var allBlocks :Dictionary[String,Block] = {}

func _ready() -> void:
	# get all blocks in folder
	var directory = ResourceLoader.list_directory("res://data/blocks/resources")
	for filename in directory:
		if !filename.ends_with(".tres"):
			continue # skip non-resources
		
		var resource :Block = load("res://data/blocks/resources/" + filename)
		var blockID :String = resource.blockID
		blockContainer.addObjectToDictionary(blockID)
		var blockObject = BlockManager.blockContainer.getObjectFromDictionary(blockID)
		
		var textureImage = resource.texture.get_image()
		textureImage.convert(Image.FORMAT_RGBA8)
		blockObject.setTextureImage( textureImage )
		
		# add components
		blockObject.initializeComponentArray( resource.components.size() )
		var i:int = 0
		for component in resource.components:
			blockObject.addComponent(component,i)
			i += 1
			
		blockObject.printComponentArray()
		
		# light
		blockObject.setIsTransparent(resource.isTransparent)
		blockObject.setLightPassThrough(resource.lightPassThrough)
		var c :Color= resource.lightEmission
		blockObject.setLightEmission(c.r,c.g,c.b)
		
		allBlocks[blockID] = resource

func isBlockReplaceable(id:String) -> bool:
	return allBlocks[id].isReplaceable

func isBlockIndestructible(id:String) -> bool:
	return allBlocks[id].indestructible

func getBlockHealth(id:String) -> int:
	return allBlocks[id].health

func getBlockImageFromWorld(x:int,y:int,world:WORLDCONTAINER) -> Texture2D:
	# right now just grabs texture from item. In the future this function
	# should be able to distinguish the data and pick the correct part of the image
	var blockID:String = world.getBlock(x,y)
	return allBlocks[blockID].texture
