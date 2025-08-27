extends Node2D

func _ready() -> void:
	var img :Image= BlockManager.blockContainer.getObjectFromDictionary("stone").getTextureImage()
	$Sprite2D.texture = ImageTexture.create_from_image(img)
	
	var img2 :Image= BlockManager.blockContainer.getObjectFromDictionary("dirt").getTextureImage()
	$Sprite2D2.texture = ImageTexture.create_from_image(img2)
	
	print(BlockManager.blockContainer.getObjectFromDictionary("dirt").getRandomInt())
