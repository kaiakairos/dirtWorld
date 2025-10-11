extends Node

var inventory : Dictionary[int,ItemInstance]= {}

func _ready() -> void:
	initializeInventory(5)
	addItemByID("balls")
	addItemByID("printer")

func initializeInventory(slots:int) -> void:
	for i in range(slots):
		inventory[i] = null

func addItemByID(itemID:String) -> void:
	var slot = getFirstEmptySlot()
	if slot == -1:
		return
	inventory[slot] = ItemManager.generateNewItemInstance(itemID)

func getFirstEmptySlot() -> int:
	for slot in inventory.size():
		if inventory[slot] == null:
			return slot
	return -1
