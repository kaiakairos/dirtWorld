extends Node2D

var blockEntityScenes :Dictionary[String,PackedScene] = {
	"pinwheel":load("res://data/blockEntity/pinwheel/pinwheel.tscn"),
}

var existingBlockEntities :Dictionary[Vector2i,BlockEntity]

func _on_worldcontainer_spawn_block_entity(blockEntityID: String, tileX: int, tileY: int) -> void:
	var tile :Vector2i= Vector2i(tileX,tileY)
	if existingBlockEntities.has(tile):
		if is_instance_valid(existingBlockEntities[tile]):
			return # cancel if there's an entity here
		
	var ins :BlockEntity = blockEntityScenes[blockEntityID].instantiate()
	ins.position = (tile * 8) + Vector2i(4,4)
	ins.tilePos = tile
	ins.world = get_parent().get_parent()
	ins.worldContainer = get_parent().get_parent().worldContainer
	add_child(ins)
	existingBlockEntities[tile] = ins
