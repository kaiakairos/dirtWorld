extends EntityComponent
class_name UsingItemComponent

var equippedItem :ItemInstance = null
var usingItem :bool = false
var lastTickUsing :bool = false

var data :Dictionary[String,Variant] = {}

signal itemChanged

func _ready() -> void:
	data["world"] = world
	data["entity"] = entity
	data["focusPosition"] = Vector2.ZERO
	data["delta"] = 0.0
	data["focusedTile"] = Vector2i.ZERO

func setItem(newItem:ItemInstance) -> void:
	equippedItem = newItem
	
	emit_signal("itemChanged")
	if !is_instance_valid(equippedItem):
		print("Unequipped item...")
		return
	equippedItem.runFunctionOnComponents("onSelectedItem",data)
	print("Equipped new item: " + equippedItem.item.itemName)

func tick(delta: float) -> void:
	if !is_instance_valid(equippedItem):
		return
	data["delta"] = delta
	if usingItem:
		if !lastTickUsing:
			equippedItem.runFunctionOnComponents("onStartUsing",data)
		equippedItem.runFunctionOnComponents("whileUsing",data)
	else:
		if lastTickUsing:
			equippedItem.runFunctionOnComponents("onStopUsing",data)
		equippedItem.runFunctionOnComponents("whileNotUsing",data)
	
	lastTickUsing = usingItem
