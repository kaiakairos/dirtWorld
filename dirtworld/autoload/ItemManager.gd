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
				continue # processed this seperate folder
			continue # skip non-resources
		
		var itemResource :Item = load(directory + filename)
		allItems[itemResource.itemStringID] = itemResource

func getItem(itemID:String) -> Item:
	if !allItems.has(itemID):
		itemID = "error"
	return allItems[itemID]

func generateNewItemInstance(itemID:String,amount:int=1) -> ItemInstance:
	var instance = ItemInstance.new()
	instance.itemID = itemID
	instance.amount = amount
	instance.initialize()
	return instance

func getItemTexture(itemID:String) -> Texture2D:
	return getItem(itemID).itemTexture
