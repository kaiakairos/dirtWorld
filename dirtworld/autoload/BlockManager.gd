extends Node

@onready var blockContainer :BLOCKCONTAINER = BLOCKCONTAINER.new()

func _ready() -> void:
	# get all blocks in folder
	var directory = ResourceLoader.list_directory("res://data/blocks/resources")
	for filename in directory:
		if !filename.ends_with(".tres"):
			continue # skip non-resources
		
		
		var resource :Block = load("res://data/blocks/resources/" + filename)
		blockContainer.addObjectToDictionary(resource.blockID)
		var blockObject = BlockManager.blockContainer.getObjectFromDictionary(resource.blockID)
		
		print(resource.blockID)
		
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
