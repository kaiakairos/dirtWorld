extends Node

var allItems :Dictionary[String,Item] = {}

func _ready() -> void:
	loadItemResourcesFromDirectory("res://data/items/")
	print(allItems)

func loadItemResourcesFromDirectory(directory:String) -> void:
	var files = ResourceLoader.list_directory(directory)
	for filename in files:
		if !filename.ends_with(".tres"):
			if filename.ends_with("/"): # is another directory
				loadItemResourcesFromDirectory(directory + filename) # recursively parse other directory
				continue # skip non-resources
			continue # skip non-resources
		
		var itemResource :Item = load(directory + filename)
		allItems[itemResource.itemStringID] = itemResource

func getItem(itemID:String) -> Item:
	return allItems[itemID]

func generateNewItemInstance(itemID:String) -> ItemInstance:
	var instance = ItemInstance.new()
	instance.itemID = itemID
	instance.initialize()
	return instance

func getItemTexture(itemID:String) -> Texture2D:
	return allItems[itemID].itemTexture
