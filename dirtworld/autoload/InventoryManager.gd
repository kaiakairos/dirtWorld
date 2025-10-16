extends Node

var inventory : Dictionary[int,ItemInstance]= {}

signal inventoryUpdated
signal selectedItemChanged

var selectedSlot :int = 0

func _ready() -> void:
	initializeInventory(40)
	addItemByID("stone",1)
	addItemByID("balls")
	addItemByID("printer")
	addItemByID("stone",1)
	addItemByID("stone",58)
	

func getItemInSlot(slot:int) -> ItemInstance:
	if !inventory.has(slot):
		return null
	return inventory[slot]

func initializeInventory(slots:int) -> void:
	for i in range(slots):
		inventory[i] = null

func addItemByID(itemID:String,amount:int=1) -> int:
	var item :Item = ItemManager.getItem(itemID)
	var amountLeft :int = amount
	while amountLeft > 0:
		var existingItemStack :ItemInstance = getExistingItemStack(itemID)
		if existingItemStack == null:
			break # cancel the loop and create a new item instance if no stack exists
		existingItemStack.amount += amountLeft
		amountLeft = 0
		if existingItemStack.amount > item.maxStackSize:
			amountLeft = existingItemStack.amount - item.maxStackSize
			existingItemStack.amount = item.maxStackSize
	
	while amountLeft > 0:
		var slot = getFirstEmptySlot()
		if slot == -1:
			break # couldn't find an empty spot
		
		inventory[slot] = ItemManager.generateNewItemInstance(itemID,amountLeft)
		amountLeft = 0
		if inventory[slot].amount > item.maxStackSize:
			amountLeft = inventory[slot].amount - item.maxStackSize
			inventory[slot].amount = item.maxStackSize
	
	updateInventory()
	return amountLeft

func addItemByInstance(itemInstance:ItemInstance) -> int: # returns amount left
	if itemInstance.unstackable:
		# item can't be stacked, so we'll just see if theres an empty spot
		var slot = getFirstEmptySlot()
		if slot == -1:
			return 1 # couldn't find empty spot
		inventory[slot] = itemInstance
		updateInventory()
		return 0 # we succesfully obtained the unstackable item!
	
	# we need some function here to "compare" item instances
	# for now, we will just discard the old ones
	# maybe have item components each have a "check" function?
	
	var leftover :int = addItemByID(itemInstance.itemID,itemInstance.amount)
	return leftover

func getFirstEmptySlot() -> int:
	for slot in inventory.size():
		if inventory[slot] == null:
			return slot
	return -1

func getExistingItemStack(itemID:String) -> ItemInstance:
	for slot in inventory.size():
		if inventory[slot] == null:
			continue # empty item
		if itemID != inventory[slot].itemID:
			continue # not the same item
		if inventory[slot].unstackable:
			continue # marked as unstackable
		if inventory[slot].amount == ItemManager.getItem(itemID).maxStackSize:
			continue # stack already full, don't bother
		
		return inventory[slot]
	return null

func consumeSelectedItem() -> void:
	if !is_instance_valid(inventory[selectedSlot]):
		printerr("Attempting to consume a null item.")
		return 
	inventory[selectedSlot].amount -= 1
	if inventory[selectedSlot].amount == 0:
		inventory[selectedSlot] = null
		updateSelectedSlot(selectedSlot)
	updateInventory()

func updateInventory() -> void:
	emit_signal("inventoryUpdated")

func updateSelectedSlot(newSlot:int) -> void:
	selectedSlot = newSlot
	emit_signal("selectedItemChanged")
