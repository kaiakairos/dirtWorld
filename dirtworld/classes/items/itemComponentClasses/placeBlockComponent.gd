extends ItemComponent
class_name ComponentPlaceBlock

# Returning TRUE means we continue to the next component when running code. 
# This can give certain components priority, by returning FALSE instead we can stop other components
# from running. For example: this is useful for food than can be both eaten and planted.

# 'data' dictionary holds passed in information. data.world should always get the world,
# and data.entity should get the user of the item. for functions relating to ground items,
# data.itemEntity should get the ground item.

## set component variables HERE
# @export values will be saved, regular ones will not be

@export var blockToPlace :String = "stone"
var timer :float = 0.0

func onSelectedItem(data:Dictionary[String,Variant]) -> bool: # When we swap to the item in our hotbar / inventory
	var player :Player= data.entity
	player.setItemSpriteData(item.itemStringID,Vector2(0,6),Vector2(1.5,1.5))
	player.setItemAnimAimMode(1,false)
	player.playItemAnim("placeHold",true)
	player.toggleHeldItemVisibility(true)
	player.setItemAnimSpeed(2.0)
	return true

func onStartUsing(data:Dictionary[String,Variant]) -> bool: # When we press MOUSE 1
	timer = -1.0
	return false

func whileUsing(data:Dictionary[String,Variant]) -> bool: # While we are pressing MOUSE 1
	timer -= data["delta"]
	if timer <= 0.0:
		if checkIfPlace(data):
			var player :Player= data.entity
			player.playItemAnim("place",true)
			InventoryManager.consumeSelectedItem()
			return false
	return true 

func onStopUsing(data:Dictionary[String,Variant]) -> bool: # When we stop pressing MOUSE 1
	return true

func whileNotUsing(data:Dictionary[String,Variant]) -> bool: # While we are NOT pressing MOUSE 1
	return true

func onDrop(data:Dictionary[String,Variant]) -> bool: # When we drop the item on the floor.
	return true
	
func whileOnGround(data:Dictionary[String,Variant]) -> bool: # While the item is on the ground.
	return true

func onPickedUp(data:Dictionary[String,Variant]) -> bool: # When item is picked up off the ground.
	return true

func checkIfPlace(data:Dictionary[String,Variant]) -> bool:
	var tile :Vector2i = data["focusedTile"]
	var worldContainer :WORLDCONTAINER = data["world"].worldContainer
	var existingTile :String = worldContainer.getBlock(tile.x,tile.y)
	if !BlockManager.isBlockReplaceable(existingTile):
		return false
	
	if worldContainer.getBG(tile.x,tile.y) != "air":
		placeForReal(tile,worldContainer)
		return true # placed on wall successfully
	
	var checks :Array[Vector2i] = [Vector2i.RIGHT,Vector2i.LEFT,Vector2i.DOWN,Vector2i.UP]
	for vec in checks:
		var sideTile :String = worldContainer.getBlock(tile.x + vec.x,tile.y + vec.y)
		if !BlockManager.isBlockReplaceable(sideTile):
			placeForReal(tile,worldContainer)
			return true # placed successfully
	

	
	return false

func placeForReal(tile:Vector2i,worldContainer:WORLDCONTAINER) -> void:
	worldContainer.editBlock(tile.x,tile.y,blockToPlace)
	worldContainer.applyManualChanges()
	worldContainer.placeBlock(tile.x,tile.y)
	timer = 0.15
