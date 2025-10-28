extends Node2D
class_name InventorySlot

@export var slot :int = 0

@onready var sprite :Sprite2D = $ItemSprite
@onready var amount :Label = $amount

@export var heldSlot :bool = false

signal slotLeftClicked(slotObj:InventorySlot)
signal slotRightClicked(slotObj:InventorySlot)

func _ready() -> void:
	if heldSlot:
		slot = InventoryManager.slotType.HELDITEM
		$button.hide()
		$Slot.hide()
	InventoryManager.connect("inventoryUpdated",updateVisuals)
	InventoryManager.connect("selectedItemChanged",selectedSlotChanged)
	
func updateVisuals() -> void:
	var itemInstance :ItemInstance = InventoryManager.getItemInSlot(slot)
	
	if !is_instance_valid(itemInstance):
		sprite.texture = null
		amount.text = ""
		$Slot.frame = 0
		return
	
	var itemDefiner :Item = ItemManager.getItem(itemInstance.itemID)
	sprite.texture = itemDefiner.itemTexture
	amount.text = str(itemInstance.amount)
	if itemInstance.amount == 1 and itemDefiner.maxStackSize == 1:
		amount.text = ""
	$Slot.frame = 1
	
	selectedSlotChanged()

func selectedSlotChanged() -> void:
	$Slot.frame = int( is_instance_valid(InventoryManager.getItemInSlot(slot)) ) + int( slot == InventoryManager.selectedSlot )


func _on_button_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	if !event["pressed"]:
		return
	if event["button_index"] == 1:
		emit_signal("slotLeftClicked",self)
	elif event["button_index"] == 2:
		emit_signal("slotRightClicked",self)
