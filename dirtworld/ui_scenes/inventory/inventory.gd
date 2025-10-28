extends Node2D

@onready var slotScene :PackedScene = preload("res://ui_scenes/inventory/inventory_slot.tscn")

@onready var hotbar :Node2D = $Hotbar
@onready var body :Node2D = $Body

var inventoryOpen :bool = true

func _ready() -> void:
	generateInventory()
	toggleInventory()

func generateInventory() -> void:
	for i in range(40):
		var slotIns :InventorySlot = slotScene.instantiate()
		slotIns.position = Vector2((i%10) * 18, (i/10) * 20)
		slotIns.slot = i
		slotIns.connect("slotLeftClicked",slotLeftClicked)
		slotIns.connect("slotRightClicked",slotRightClicked)
		if i <10:
			hotbar.add_child(slotIns)
		else:
			body.add_child(slotIns)
	
	InventoryManager.updateInventory()

func _process(delta: float) -> void:
	$HeldItemSlot.position = get_local_mouse_position()

func slotLeftClicked(slot:InventorySlot) -> void:
	var g : bool = inventoryOpen
	
	if is_instance_valid(InventoryManager.getHeldItemSlot()):
		g = true
	
	if g:
		if !is_instance_valid(InventoryManager.getItemInSlot(slot.slot)) or !is_instance_valid(InventoryManager.getHeldItemSlot()):
			# swap if either spot is empty
			InventoryManager.swapSlots(slot.slot,InventoryManager.slotType.HELDITEM)
			return
		# if we're here, it means both slots have an item in them
		if InventoryManager.getItemInSlot(slot.slot).itemID != InventoryManager.getHeldItemSlot().itemID:
			# items are different, swap
			InventoryManager.swapSlots(slot.slot,InventoryManager.slotType.HELDITEM)
		elif InventoryManager.getItemInSlot(slot.slot).unstackable or InventoryManager.getHeldItemSlot().unstackable:
			# items are the same, but one of them is unstackable, so we swap
			InventoryManager.swapSlots(slot.slot,InventoryManager.slotType.HELDITEM)
		else:
			# items are stackable
			InventoryManager.tranferFromSlotToAnother(InventoryManager.slotType.HELDITEM,slot.slot,InventoryManager.getHeldItemSlot().amount)
	else:
		InventoryManager.updateSelectedSlot(slot.slot)
		
		
func slotRightClicked(slot:InventorySlot) -> void:
	var heldItem :ItemInstance = InventoryManager.getHeldItemSlot()
	if !is_instance_valid(heldItem):
		if !is_instance_valid(InventoryManager.getItemInSlot(slot.slot)):
			return # no item either here or in hand
		# split item here
		var oldItem :ItemInstance = InventoryManager.getItemInSlot(slot.slot)
		if oldItem.amount <= 1:
			InventoryManager.swapSlots(slot.slot,InventoryManager.slotType.HELDITEM)
			return # if there's only 1 amount item, just swap the items
		var newItem :ItemInstance = InventoryManager.duplicateItemInstance(oldItem)
		newItem.amount /= 2
		oldItem.amount -= newItem.amount
		InventoryManager.forceSetHeldItem(newItem)
		
		InventoryManager.updateInventory()
		InventoryManager.updateSelectedSlot(InventoryManager.slotType.HELDITEM)
	else: # there is an item in the held slot
		# drop a single item into the selected slot
		InventoryManager.tranferFromSlotToAnother(InventoryManager.slotType.HELDITEM,slot.slot,1)

func toggleInventory() -> void:
	inventoryOpen = !inventoryOpen
	$Body.visible = inventoryOpen
	
