extends Node2D

@export var world :World
var showing :bool = false

@export var messageContainer :Node2D
@onready var chatMessage :PackedScene = preload("res://ui_scenes/chatbox/chat_message.tscn")

var lastChats :PackedStringArray = [""]
var lastChatSearcher :int = 0

func _process(delta: float) -> void:
	if showing:
		if Input.is_action_just_pressed("chatbox"):
			interpretChat()
			$TextEdit.text = ""
			hide()
			showing = false
		if Input.is_action_just_pressed("ui_up"):
			lastChatSearcher -= 1
			if lastChatSearcher < 0:
				lastChatSearcher = 0
			$TextEdit.text = lastChats[lastChatSearcher]
			$TextEdit.set_caret_column($TextEdit.text.length())
	else:
		if Input.is_action_just_pressed("chatbox"):
			enable()

func enable() -> void:
	show()
	await get_tree().process_frame
	showing = true
	lastChatSearcher = lastChats.size()
	$TextEdit.grab_focus()

func interpretChat() -> void:
	var chat :String = $TextEdit.text
	chat = chat.replace("\n","") # remove enters
	
	var sliceArray :PackedStringArray = chat.split(" ",false)
	if sliceArray.size() == 0:
		return
	
	if chat != lastChats[lastChats.size()- 1]: # don't append chats that are previous chats
		lastChats.append(chat) # append chat to history
	
	match sliceArray[0]:
		"give":
			var amount :int = 1
			if sliceArray.size() < 2:
				sendError("ERROR: Missing item name!!")
				return
			if sliceArray.size() >= 3:
				amount = int(sliceArray[2])
			InventoryManager.addItemByID(sliceArray[1],amount)
			sendChat("Added " + str(amount) +" "+ sliceArray[1] + " to your inventory!")
		"fullbright":
			$"../../../LightMask/LIGHTDRAWER".visible = !$"../../../LightMask/LIGHTDRAWER".visible
			sendChat("Toggled lighting!")
		"zoom":
			if sliceArray.size() < 2:
				sendError("ERROR: Missing zoom value!!")
				return
			if float(sliceArray[1]) == 0.0:
				if sliceArray[1] == "0" or sliceArray[1] == "0.0":
					sendError("ERROR: Zoom can't be zero!")
				else:
					sendError("ERROR: Zoom value must be a float!")
				return
			world.setCameraZoom(float(sliceArray[1]))
			sendChat("Changed camera zoom to " + sliceArray[1])
		"save":
			world.saveWorld()
			sendChat("Saved world! (Debug)")
		"load":
			world.loadWorld()
			sendChat("Loaded World! (Debug)")
		_:
			sendError("ERROR: Unknown command...")

func sendChat(chatMessage:String) -> void:
	printMessage(chatMessage,Color.WHITE)

func sendError(chatMessage:String) -> void:
	printMessage(chatMessage,Color.RED)

func printMessage(message:String,color:Color) -> void:
	
	var ins :ChatMessage= chatMessage.instantiate()
	ins.setText(message)
	ins.modulate = color
	
	for i in messageContainer.get_children():
		i.position.y -= ins.getLineCount() * ins.getLineHeight()
	
	messageContainer.add_child(ins)
