extends Node2D
class_name ChatMessage

var timeAlive :float = 0.0

func _process(delta: float) -> void:
	timeAlive += delta
	if timeAlive > 8.0:
		modulate.a -= delta * 0.25
		if modulate.a <= 0.0:
			queue_free()

func getLineHeight() -> int:
	return $Label.get_line_height()

func getLineCount() -> int:
	return $Label.get_line_count()

func setText(text:String) -> void:
	$Label.text = text
