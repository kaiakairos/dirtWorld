extends ItemComponent
class_name ComponentMining

# Returning TRUE means we continue to the next component when running code. 
# This can give certain components priority, by returning FALSE instead we can stop other components
# from running. For example: this is useful for food than can be both eaten and planted.

# 'data' dictionary holds passed in information. data.world should always get the world,
# and data.entity should get the user of the item. for functions relating to ground items,
# data.itemEntity should get the ground item.

## set component variables HERE
# @export values will be saved, regular ones will not be

@export var miningLevel :int = 1
@export var miningDelay :float = 0.5
@export var miningDamage :int = 1

var miningTick :float = 0.5

func onSelectedItem(data:Dictionary[String,Variant]) -> bool: # When we swap to the item in our hotbar / inventory
	var player :Player= data.entity
	player.setItemSpriteData(item.itemStringID,Vector2(8,0),Vector2(1.5,1.5),PI/4)
	player.setItemAnimAimMode(0)
	player.toggleHeldItemVisibility(true)
	return true

func onStartUsing(data:Dictionary[String,Variant]) -> bool: # When we press MOUSE 1
	var player :Player= data.entity
	player.setItemAnimSpeed(1.0 / miningDelay)
	player.setItemAnimAimMode(1,false)
	return true

func whileUsing(data:Dictionary[String,Variant]) -> bool: # While we are pressing MOUSE 1
	if miningTick < miningDelay:
		miningTick += data.delta
	
	if miningTick >= miningDelay:
		var blockBreak :BlockBreaker =data.world.getBlockBreak(data["focusedTile"])
		var player :Player= data.entity
		player.playItemAnim("swingPickaxe",true)
		miningTick -= miningDelay
		if !is_instance_valid(blockBreak):
			return true
		blockBreak.doDamage(miningDamage)
		
		
	return true 

func onStopUsing(data:Dictionary[String,Variant]) -> bool: # When we stop pressing MOUSE 1
	var player :Player= data.entity
	player.setItemAnimAimMode(0)
	return true

func whileNotUsing(data:Dictionary[String,Variant]) -> bool: # While we are NOT pressing MOUSE 1
	if miningTick < miningDelay:
		miningTick += data.delta
	return true

func onDrop(data:Dictionary[String,Variant]) -> bool: # When we drop the item on the floor.
	return true
	
func whileOnGround(data:Dictionary[String,Variant]) -> bool: # While the item is on the ground.
	return true

func onPickedUp(data:Dictionary[String,Variant]) -> bool: # When item is picked up off the ground.
	return true
