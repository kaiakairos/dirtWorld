extends Node

var inventory : Dictionary[int,ItemInstance]= {}
const inventoryBodySize :int = 40

signal inventoryUpdated
signal selectedItemChanged

var selectedSlot :int = 0

enum slotType {HELDITEM = 999,EMPTYHAND = 1000}

var tempPreventItemUsage :bool = false

func _ready() -> void:
	initializeInventory(inventoryBodySize)
	addItemByID("testPickaxe")
	addItemByID("dirt",99)
	addItemByID("stone",99)
	addItemByID("grass",99)
	addItemByID("light",99)
	addItemByID("test",99)
	
	inventory[slotType.EMPTYHAND] = ItemManager.generateNewItemInstance("hand")

func _process(delta: float) -> void:
	if tempPreventItemUsage:
		tempPreventItemUsage = Input.is_action_pressed("useItem")

func getItemInSlot(slot:int) -> ItemInstance:
	if !inventory.has(slot):
		return null
	return inventory[slot]

func initializeInventory(slots:int) -> void:
	for i in range(slots):
		inventory[i] = null
	
	inventory[slotType.HELDITEM] = null

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
	for slot in inventoryBodySize:
		if inventory[slot] == null:
			return slot
	return -1

func getExistingItemStack(itemID:String) -> ItemInstance:
	for slot in inventoryBodySize:
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
	
	var slot :int = selectedSlot
	if getHeldItemSlot() != null:
		slot = slotType.HELDITEM
	
	if !is_instance_valid(inventory[slot]):
		printerr("Attempting to consume a null item.")
		return 
	inventory[slot].amount -= 1
	if inventory[slot].amount == 0:
		inventory[slot] = null
		
		# if held slot, remove the ability to use items until button is no longer pressed
		if slot == slotType.HELDITEM:
			tempPreventItemUsage = true
		
		updateSelectedSlot(selectedSlot)
	updateInventory()

func updateInventory() -> void:
	emit_signal("inventoryUpdated")

func updateSelectedSlot(newSlot:int) -> void:
	selectedSlot = newSlot
	emit_signal("selectedItemChanged")

func getHeldItemSlot() -> ItemInstance:
	return inventory[slotType.HELDITEM]

func swapSlots(slot1:int,slot2:int) -> void:
	var save:ItemInstance = inventory[slot1]
	inventory[slot1] = inventory[slot2]
	inventory[slot2] = save
	updateInventory()
	updateSelectedSlot(selectedSlot)

func forceSetHeldItem(item:ItemInstance) -> void:
	inventory[slotType.HELDITEM] = item

func duplicateItemInstance(itemToBeDuped:ItemInstance) -> ItemInstance:
	var newItem :ItemInstance= itemToBeDuped.duplicate()
	newItem.item = itemToBeDuped.item
	newItem.components = itemToBeDuped.components.duplicate()
	return newItem

func tranferFromSlotToAnother(slotFrom:int,slotTo:int,amount:int) -> void:
	var fromItem :ItemInstance = getItemInSlot(slotFrom)
	var toItem :ItemInstance = getItemInSlot(slotTo)
	if !is_instance_valid(toItem):
		# no item in directed slot
		var newItem :ItemInstance = duplicateItemInstance(fromItem)
		newItem.amount = amount
		fromItem.amount -= amount
		inventory[slotTo] = newItem
		if fromItem.amount <= 0:
			inventory[slotFrom] = null
	elif toItem.itemID == fromItem.itemID: # item is of same type
		if toItem.unstackable:
			return
		toItem.amount += amount
		fromItem.amount -= amount
		if toItem.amount > toItem.item.maxStackSize:
			var dif :int = toItem.amount - toItem.item.maxStackSize
			toItem.amount -= dif
			fromItem.amount += dif
		
		if fromItem.amount <= 0:
			inventory[slotFrom] = null
		
	
	
	updateInventory()
