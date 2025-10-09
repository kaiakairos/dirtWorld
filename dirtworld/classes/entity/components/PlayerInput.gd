extends EntityComponent
class_name PlayerInputComponent

@export var jumpBufferingAmount :float = 0.1
var jumpBuffer :float = 0.0

func _process(delta: float) -> void:
	jumpBuffer -= delta
	if Input.is_action_just_pressed("jump"):
		jumpBuffer = jumpBufferingAmount

func getInput() -> Dictionary[String,Variant]:
	
	var dirY :int = int(Input.get_axis("move_up","move_down"))
	
	var isJumping :bool = jumpBuffer > 0.0
	var isHoldingJump :bool = Input.is_action_pressed("jump")
	
	return {
		"dirX" : getDirX(),
		"dirY" : dirY,
		"isJumping": isJumping,
		"isHoldingJump": isHoldingJump, # for swimming
	}

func forceEndJumpBuffer() -> void:
	jumpBuffer = -1.0

func getDirX() -> int:
	var dirX :int = int(Input.get_axis("move_left","move_right"))
	return dirX
