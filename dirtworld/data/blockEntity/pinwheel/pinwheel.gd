extends BlockEntity

# block entity !!
# use 'tilePos' to get the world position
# 'world' and 'worldcontainer' are also available

func onReady() -> void:
	pass

func _process(delta: float) -> void:
	$DirtItem.rotate(8.0 * delta)
