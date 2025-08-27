extends Node

@onready var blockContainer :BLOCKCONTAINER = BLOCKCONTAINER.new()

func _ready() -> void:
	# get all blocks in folder
	var directory = ResourceLoader.list_directory("res://data/blocks/")
	for filename in directory:
		if !filename.ends_with(".tres"):
			continue # skip non-resources
		
		
		var resource :Block = load("res://data/blocks/" + filename)
		blockContainer.addObjectToDictionary(resource.blockID)
		var blockObject = BlockManager.blockContainer.getObjectFromDictionary(resource.blockID)
		var textureImage = resource.texture.get_image()
		textureImage.convert(Image.FORMAT_RGBA8)
		blockObject.setTextureImage( textureImage )
		blockObject.setRandomInt(resource.randomInt)
