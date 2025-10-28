extends ItemComponent
class_name ComponentGlowWhenHeld

# Returning TRUE means we continue to the next component when running code. 
# This can give certain components priority, by returning FALSE instead we can stop other components
# from running. For example: this is useful for food than can be both eaten and planted.

# 'data' dictionary holds passed in information. data.world should always get the world,
# and data.entity should get the user of the item. for functions relating to ground items,
# data.itemEntity should get the ground item.

## set component variables HERE
# @export values will be saved, regular ones will not be
@export var blockID :String = ""
var color :Color = Color.BLACK
@export var multiplier :float = 1.0

func onSelectedItem(data:Dictionary[String,Variant]) -> bool: # When we swap to the item in our hotbar / inventory
	var obj :Block = BlockManager.getBlockOBJ(blockID)
	color = obj.lightEmission
	return true

func onStartUsing(data:Dictionary[String,Variant]) -> bool: # When we press MOUSE 1
	return true

func whileUsing(data:Dictionary[String,Variant]) -> bool: # While we are pressing MOUSE 1
	urghColor(data)
	return true 

func onStopUsing(data:Dictionary[String,Variant]) -> bool: # When we stop pressing MOUSE 1
	return true

func whileNotUsing(data:Dictionary[String,Variant]) -> bool: # While we are NOT pressing MOUSE 1
	urghColor(data)
	return true

func onDrop(data:Dictionary[String,Variant]) -> bool: # When we drop the item on the floor.
	var obj :Block = BlockManager.getBlockOBJ(blockID)
	color = obj.lightEmission
	return true
	
func whileOnGround(data:Dictionary[String,Variant]) -> bool: # While the item is on the ground.
	urghColor(data)
	return true

func onPickedUp(data:Dictionary[String,Variant]) -> bool: # When item is picked up off the ground.
	return true

func urghColor(data:Dictionary[String,Variant]) -> void:
	data.world.appendQueue(Vector2i(data.entity.global_position)/8,color.r * multiplier,color.g * multiplier,color.b * multiplier)
