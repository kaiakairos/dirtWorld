extends Resource
class_name ItemComponent

var item : Item

func onSelectedItem(data:Dictionary[String,Variant]) -> bool: # When we swap to the item in our hotbar / inventory
	return true

func onStartUsing(data:Dictionary[String,Variant]) -> bool: # When we press MOUSE 1
	return true

func whileUsing(data:Dictionary[String,Variant]) -> bool: # While we are pressing MOUSE 1
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
