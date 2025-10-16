extends Resource
class_name ItemInstance

## This class is for items in the inventory ##

@export var itemID :String = ""
var item :Item

@export var amount :int = 1
@export var unstackable :bool = false

@export var components :Array[ItemComponent]

func initialize() -> void:
	item = ItemManager.getItem(itemID)
	
	if item == null: # install cs source
		return
	
	if item.maxStackSize == 1:
		unstackable = true
	
	appendComponents()

func appendComponents() -> void:
	for component in item.components:
		var new :ItemComponent= component.duplicate(true)
		new.item = item
		components.append( new )
		
func runFunctionOnComponents(function:StringName,data:Dictionary[String,Variant]) -> void:
	for component in components:
		if !component.call(function,data):
			return # ends if component calls false
