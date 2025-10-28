extends Node

signal clicked

var xValues : Array[int] = []
var yValues : Array[int] = []

func _ready() -> void:
	whatever()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("useItem"):
		var mouse = $BackgroundAmbientOcclusion.get_local_mouse_position()
		mouse = Vector2i(mouse * 2) / 16
		xValues.append(mouse.x)
		yValues.append(mouse.y)
		emit_signal("clicked")


func whatever() -> void:
	#int index = L + (R*2) + (T*4) + (B*8) + (LT * 16) + (RT * 32) + (LB * 64) + (RB * 128);
	for i in range(256):
		
		var s = String.num_int64(i,2)
		
		if s.length() < 8:
			var new :String= ""
			for d in range(8 - s.length()):
				new += "0"
			s = new + s
		
		
		var L :bool = s[7] == "1"
		var R :bool = s[6] == "1"
		var T :bool = s[5] == "1"
		var B :bool = s[4] == "1"
		var LT :bool = s[3] == "1"
		var RT :bool = s[2] == "1"
		var LB :bool = s[1] == "1"
		var RB :bool = s[0] == "1"
		
		$rects/ColorRect.visible = LT
		$rects/ColorRect2.visible = T
		$rects/ColorRect3.visible = RT
		$rects/ColorRect4.visible = L 
		
		$rects/ColorRect6.visible = R
		$rects/ColorRect7.visible = LB
		$rects/ColorRect8.visible = B
		$rects/ColorRect9.visible = RB
		
		await clicked
		
	
	print(xValues)
	print(yValues)
