extends Node

@onready var blockContainer :BLOCKCONTAINER = BLOCKCONTAINER.new()

var allBlocks :Dictionary[String,Block] = {}

func _ready() -> void:
	loadBlocksFromDirectory("res://data/blocks/blockResources/")

func loadBlocksFromDirectory(dir:String) -> void:
	# get all blocks in folder
	print(dir)
	var directory = ResourceLoader.list_directory(dir)
	for filename in directory:
		if !filename.ends_with(".tres"):
			if filename.ends_with("/"): # is another directory
				loadBlocksFromDirectory(dir + filename) # recursively parse other directory
				continue
			continue # skip non-resources
		
		var resource :Block = load(dir + filename)
		var blockID :String = resource.blockID
		blockContainer.addObjectToDictionary(blockID)
		var blockObject = blockContainer.getObjectFromDictionary(blockID)
		
		var textureImage = resource.texture.get_image()
		textureImage.convert(Image.FORMAT_RGBA8)
		blockObject.setTextureImage( textureImage ) 
		
		# initialize component data
		for i in resource.setComponents:
			i.createComponent(resource.components)
		
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
	var blockOBJ :BLOCKOBJECT = blockContainer.getObjectFromDictionary(blockID)
	var img :Image= blockOBJ.getTextureImage()
	var imgPos :Vector2i = blockOBJ.getImageRectGD(x,y,blockID,blockContainer,world)
	var newImage :Image = img.get_region(Rect2i(imgPos.x * 8,imgPos.y * 8,8,8))
	var texture :ImageTexture = ImageTexture.create_from_image(newImage)
	return texture
