extends Node2D

@onready var slotScene :PackedScene = preload("res://ui_scenes/inventory/inventory_slot.tscn")

@onready var hotbar :Node2D = $Hotbar
@onready var body :Node2D = $Body

func _ready() -> void:
	generateInventory()

func generateInventory():
	for i in range(40):
		var slotIns :InventorySlot = slotScene.instantiate()
		slotIns.position = Vector2((i%10) * 18, (i/10) * 20)
		slotIns.slot = i
		if i <10:
			hotbar.add_child(slotIns)
		else:
			body.add_child(slotIns)
	
	InventoryManager.updateInventory()
