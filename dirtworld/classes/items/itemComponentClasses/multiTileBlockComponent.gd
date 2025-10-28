extends ItemComponent
class_name ComponentMultiTileBlock

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

@export var tileWidth :int = 2
@export var tileHeight :int = 2
@export var offset :Vector2i = Vector2i.ZERO

@export_enum("FLOOR","BACKGROUND","DONTCARE") var placeType :int = 0

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
	
	var ourArray :Array[Vector2i] = []
	for x in range(tileWidth):
		for y in range(tileHeight):
			ourArray.append(Vector2i(x + tile.x + offset.x,y + tile.y + offset.y))
	
	for x in range(tileWidth):
		for y in range(tileHeight):
			var worldX :int = tile.x + x + offset.x
			var worldY :int = tile.y + y + offset.y
			var existingTile :String = worldContainer.getBlock(worldX,worldY)
			if !BlockManager.isBlockReplaceable(existingTile):
				return false
	
			match placeType:
				0:
					if y != tileHeight - 1:
						continue # not floor tile, doesn't matter
					var checkTile :String = worldContainer.getBlock(worldX,worldY + 1)
					if BlockManager.isBlockReplaceable(checkTile):
						return false # don't place ontop of replaceable tiles (change to transparent later?)
				1:
					var bg :String = worldContainer.getBG(worldX,worldY)
					if bg == "air":
						return false
		
	placeForReal(tile,worldContainer)
	
	return true

func placeForReal(tile:Vector2i,worldContainer:WORLDCONTAINER) -> void:
	for x in range(tileWidth):
		for y in range(tileHeight):
			var worldX :int = tile.x + x + offset.x
			var worldY :int = tile.y + y + offset.y
			worldContainer.editBlock(worldX,worldY,blockToPlace)
		
			var info :int = x + (y * tileWidth)
			print(info)
			worldContainer.setInfoData(worldX,worldY,info)
	
	worldContainer.applyManualChanges()
	timer = 0.15
