extends Entity

@export var playerInputComponent :PlayerInputComponent

func onReady() -> void:
	addState("normalMovement")
	addState("dead")
	
	setState(states.normalMovement)
	
	setPlayerColor(Color(1.0, 0.886, 0.306))

func onProcess(delta:float) -> void:
	match state:
		states.normalMovement:
			normalMovement(delta)
	
	world.camera.global_position = global_position + Vector2(0,-12)
	world.setLightPosition()
	normalAnimation(delta)

#######################################################
################### MOVEMENT TYPES ####################
########################################################


func normalMovement(delta:float) -> void:
	var input :Dictionary[String,Variant] = playerInputComponent.getInput()
	
	var floorStates :Dictionary[String,Variant] = getOnFloor(delta)
	
	if input.dirX == 0:
		var decel = deceleration * delta
		if !$rayCasts/floorSlideDetect.is_colliding() and floorStates.onFloor:
			decel = 9999
		velocity.x = move_toward(velocity.x,0,decel)
	else:
		velocity.x = move_toward(velocity.x,speed * input.dirX,acceleration * delta)
	
	velocity.y += gravity * delta
	if input.isJumping and floorStates.ableToJump: # replace with our own function
		velocity.y = jumpheight * -1
		playerInputComponent.forceEndJumpBuffer()
		position.y = floorStates.lastYOnFloor
		floorTimer = -1.0
	
	move_and_slide()

var floorTimer :float = 0.0 # coyoteTime
var lastYOnFloor :float = 0.0
func getOnFloor(delta:float) -> Dictionary[String,Variant]:
	var onFloor :bool= is_on_floor()
	floorTimer -= delta
	if onFloor:
		lastYOnFloor = position.y
		floorTimer = 0.1
	
	return {
		"onFloor":onFloor,
		"ableToJump":floorTimer > 0.0,
		"lastYOnFloor":lastYOnFloor,
	}

##########################################################
###################### ANIMATION ############################
##########################################################

var animTick :float = 0.0
var animTickInterval :float = 0.0625#0.0416

func normalAnimation(delta:float)->void: # absolute awful hack job of a script
	
	var floorStates :Dictionary[String,Variant] = getOnFloor(delta)
	
	animTick += delta
	if animTick > animTickInterval:
		$AnimationPlayer.advance(animTick)
		animTick -= animTickInterval
	
	var mousePos :Vector2 = get_local_mouse_position()
	
	var dirX :int = playerInputComponent.getDirX()
	
	$Sprite/Torso/Head/Eye/Pupil.position = (mousePos/200.0) * 3.0
	
	if dirX != 0:
		$Sprite.scale.x = dirX
	
	$Sprite/Torso/Head/Eye/Pupil.position.x *= $Sprite.scale.x
	mousePos.x = abs(mousePos.x)
	mousePos.y *= 0.4
	var targetAngle :float = mousePos.angle()
	
	$Sprite/Torso.rotation = lerp_angle($Sprite/Torso.rotation,clamp(targetAngle,0.0,PI/8),0.25)
	$Sprite/Torso/Head.rotation =  lerp_angle($Sprite/Torso/Head.rotation,clamp(targetAngle,-PI/6,PI/8),0.25)
	
	if !floorStates.onFloor:
		if velocity.y > 0: # falling
			$Sprite/Torso.rotation = lerp_angle($Sprite/Torso.rotation,-0.3,0.1)
			$Sprite/Torso/Head.rotation = lerp_angle($Sprite/Torso/Head.rotation,-PI/6,0.01)
		else: # jump
			$Sprite/Torso.rotation = lerp_angle($Sprite/Torso.rotation,PI/10,0.1)
			$Sprite/Torso/Head.rotation = lerp_angle($Sprite/Torso/Head.rotation,PI/6,0.1)
	else:
		$Sprite/Torso.rotation = lerp_angle($Sprite/Torso.rotation,clamp(targetAngle,0.0,PI/8),0.25)
		$Sprite/Torso/Head.rotation =  lerp_angle($Sprite/Torso/Head.rotation,clamp(targetAngle,-PI/6,PI/8),0.25)
	
	if $rayCasts/floorSlideDetect.is_colliding():
		if dirX != 0:
			$AnimationPlayer.speed_scale = max(0.5,abs(velocity.x) / 120.0)
			playAnimation("walk")
		else:
			#$AnimationPlayer.speed_scale = 1.0
			playAnimation("idle")
	else:
		$AnimationPlayer.speed_scale = 1.0
		if velocity.y > 0.0:
			playAnimation("fall")
		else:
			playAnimation("jump")

func playAnimation(anim:String) -> void:
	if $AnimationPlayer.current_animation != anim:
		$AnimationPlayer.play(anim)
		$AnimationPlayer.advance(animTick)

func setPlayerColor(color:Color):
	# do self modulate for armor later
	$Sprite/Torso.self_modulate = color
	$Sprite/Torso/Head.self_modulate = color
	$Sprite/Legs/LegTop.self_modulate = color
	$Sprite/Legs/LegTop/LegBottom.self_modulate = color
	$Sprite/Legs/LegTop2.self_modulate = color
	$Sprite/Legs/LegTop2/LegBottom.self_modulate = color
	
	
	

########################################################
################################## STATES ##############
########################################################

func getStateTransition(delta:float):
	return null

func enterState(new_state:int,old_state:int) -> void:
	pass

func exitState(old_state:int, new_state:int) -> void:
	pass

func onDeath() -> void:
	pass
