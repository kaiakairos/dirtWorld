extends Entity
class_name Player

@export var playerInputComponent :PlayerInputComponent
@export var usingItemComponent :UsingItemComponent

var focusPosition :Vector2 = Vector2.ZERO

var camOffset :Vector2 = Vector2.ZERO

@export_group("Sprite References")
@export var itemOrigin :Node2D
@export var itemSprite :Sprite2D

func onReady() -> void:
	addState("normalMovement")
	addState("dead")
	
	setState(states.normalMovement)
	
	setPlayerColor(Color(1.0, 0.886, 0.306, 1.0))

func onProcess(delta:float) -> void:
	match state:
		states.normalMovement:
			normalMovement(delta)
	
	# all debug shit
	var dir :Vector2 = Vector2.ZERO
	dir.x =Input.get_axis("ui_left","ui_right")
	dir.y = Input.get_axis("ui_up","ui_down")
	camOffset += dir * 120 * delta
	
	world.camera.global_position = global_position + Vector2(0,-12) + camOffset
	world.setLightPosition()
	focusPosition = get_local_mouse_position() # change later for controller support
	normalAnimation(delta)
	
	usingItemComponent.data["focusPosition"] = focusPosition
	usingItemComponent.data["focusedTile"] = Vector2i(to_global(focusPosition)/8.0)
	## hardcoded piece of shit, will change soon.
	if Input.is_action_just_pressed("selectItem1"):
		usingItemComponent.setItem(InventoryManager.inventory[0])
	elif Input.is_action_just_pressed("selectItem2"):
		usingItemComponent.setItem(InventoryManager.inventory[1])
	elif Input.is_action_just_pressed("selectItem3"):
		usingItemComponent.setItem(InventoryManager.inventory[2])
	elif Input.is_action_just_pressed("selectItem4"):
		usingItemComponent.setItem(InventoryManager.inventory[3])
	elif Input.is_action_just_pressed("selectItem5"):
		usingItemComponent.setItem(InventoryManager.inventory[4])
	
	usingItemComponent.usingItem = Input.is_action_pressed("useItem")
	
	usingItemComponent.tick(delta)

func _on_using_item_component_item_changed() -> void:
	toggleHeldItemVisibility(false)
	setItemAnimAimMode(0)
	stopItemAnimation()
	if is_instance_valid(usingItemComponent.equippedItem):
		itemSprite.texture = ItemManager.getItemTexture(usingItemComponent.equippedItem.itemID)
		
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
	
	animTick += delta # animation tick ( framerate )
	if animTick > animTickInterval:
		$AnimationPlayer.advance(animTick)
		animTick -= animTickInterval
	
	var dirX :int = playerInputComponent.getDirX() # flipping character
	if dirX != 0:
		$Sprite.scale.x = dirX
	
	var mousePos :Vector2 = focusPosition
	eyeballAnimation(delta,mousePos)
	
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
	
	var g = $rayCasts/floorSlideDetect2.is_colliding() or $rayCasts/floorSlideDetect3.is_colliding()
	if g and velocity.y > -1.0:
		if dirX != 0:
			$AnimationPlayer.speed_scale = max(0.5,abs(velocity.x) / 120.0)
			playAnimation("walk")
		else:
			#$AnimationPlayer.speed_scale = 1.0
			playAnimation("idle")
	else:
		#$AnimationPlayer.speed_scale = 1.0
		if velocity.y > 5.0:
			playAnimation("fall")
		else:
			playAnimation("jump")
	
	var armTarget :Vector2 = mousePos
	if armAllowFullRotation:
		armTarget = focusPosition.normalized() * $Sprite.scale
	match armAim:
		armAimMode.BOTH:
			$Sprite/Torso/Arms/MainArmPivot.rotation = armTarget.angle()
			$Sprite/Torso/Arms/BackArmPivot.rotation = armTarget.angle()
		armAimMode.MAIN:
			$Sprite/Torso/Arms/MainArmPivot.rotation = armTarget.angle()
			$Sprite/Torso/Arms/BackArmPivot.rotation = lerp_angle($Sprite/Torso/Arms/BackArmPivot.rotation,0.0,0.15)
		armAimMode.BACK:
			$Sprite/Torso/Arms/MainArmPivot.rotation = lerp_angle($Sprite/Torso/Arms/MainArmPivot.rotation,0.0,0.15)
			$Sprite/Torso/Arms/BackArmPivot.rotation = armTarget.angle()
		armAimMode.NONE:
			$Sprite/Torso/Arms/MainArmPivot.rotation = lerp_angle($Sprite/Torso/Arms/MainArmPivot.rotation,0.0,0.15)
			$Sprite/Torso/Arms/BackArmPivot.rotation = lerp_angle($Sprite/Torso/Arms/BackArmPivot.rotation,0.0,0.15)

func playAnimation(anim:String) -> void:
	if $AnimationPlayer.current_animation != anim:
		$AnimationPlayer.play(anim)

func setPlayerColor(color:Color) -> void:
	# doing self modulate so armor doesn't get fucked
	$Sprite/Torso.self_modulate = color
	$Sprite/Torso/Head.self_modulate = color
	$Sprite/Legs/LegTop.self_modulate = color
	$Sprite/Legs/LegTop/LegBottom.self_modulate = color
	$Sprite/Legs/LegTop2.self_modulate = color
	$Sprite/Legs/LegTop2/LegBottom.self_modulate = color
	$Sprite/Torso/Arms/MainArmPivot/ArmTop.self_modulate = color
	$Sprite/Torso/Arms/MainArmPivot/ArmTop/Hand.self_modulate = color
	$Sprite/Torso/Arms/BackArmPivot/ArmTop2.self_modulate = color
	$Sprite/Torso/Arms/BackArmPivot/ArmTop2/Hand2.self_modulate = color
	
var blinkTick :float = 0.0
func eyeballAnimation(delta:float,mousePos:Vector2) -> void:
	
	var pupilTarget:Vector2 = (mousePos/200.0) * 3.0
	if pupilTarget.length() > 4.0:
		pupilTarget = pupilTarget.normalized() * 4.0
	elif pupilTarget.length() < 2.0:
		pupilTarget = pupilTarget.normalized() * 2.0
	$Sprite/Torso/Head/Eye/Pupil.position = pupilTarget
	$Sprite/Torso/Head/Eye/Pupil.position.x *= $Sprite.scale.x
	
	blinkTick += delta
	
	if blinkTick >= 4.0:
		$Sprite/Torso/Head/Eye.hide()
	if blinkTick >= 4.1:
		$Sprite/Torso/Head/Eye.show()
		blinkTick = randf_range(-4.0,3.6)

func toggleHeldItemVisibility(vis:bool,forceInstant:bool=false) -> void:
	if vis and !forceInstant:
		await get_tree().create_timer(0.05).timeout
	itemOrigin.visible = vis

func playItemAnim(anim:String,force:bool=false) -> void:
	if $ItemAnimation.current_animation != anim or force:
		if force:
			animTick = 0.0
			stopItemAnimation()
		$ItemAnimation.play(anim)

func setItemAnimSpeed(animSpeed:float) -> void:
	$ItemAnimation.speed_scale = animSpeed

func stopItemAnimation() -> void:
	$ItemAnimation.stop(false)
	print("stopped")

enum armAimMode {NONE, MAIN, BACK, BOTH}
var armAim:int = armAimMode.NONE
var armAllowFullRotation :bool = true
func setItemAnimAimMode(aiming:int,allowFullRotation:bool=true) -> void:
	armAim = aiming
	armAllowFullRotation = allowFullRotation

func setItemSpriteData(itemID:String,pos:Vector2=Vector2.ZERO,size:Vector2=Vector2(1,1),rot:float=0.0) -> void:
	itemSprite.texture = ItemManager.getItemTexture(itemID)
	itemSprite.position = pos
	itemSprite.scale = size
	itemSprite.rotation = rot

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
