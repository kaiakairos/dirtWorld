extends Node2D

@export var world :World
var showing :bool = false

func _process(delta: float) -> void:
	if showing:
		if Input.is_action_just_pressed("chatbox"):
			interpretChat()
			$TextEdit.text = ""
			hide()
			showing = false

func enable() -> void:
	show()
	await get_tree().process_frame
	showing = true
	$TextEdit.grab_focus()

func interpretChat() -> void:
	var chat :String = $TextEdit.text
	chat = chat.replace("\n","") # remove enters
	
	var sliceArray :PackedStringArray = chat.split(" ",false)
	if sliceArray.size() == 0:
		return
	
	match sliceArray[0]:
		"give":
			var amount :int = 1
			if sliceArray.size() >= 3:
				amount = int(sliceArray[2])
			InventoryManager.addItemByID(sliceArray[1],amount)
		"fullbright":
			$"../../LightMask/LIGHTDRAWER".visible = !$"../../LightMask/LIGHTDRAWER".visible
		"zoom":
			world.setCameraZoom(float(sliceArray[1]))
		"save":
			world.saveWorld()
		"load":
			world.loadWorld()
