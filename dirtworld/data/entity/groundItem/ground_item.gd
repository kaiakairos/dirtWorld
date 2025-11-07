extends Entity
class_name GroundItem

@export var itemInstance :ItemInstance = null

var flyTarget :Node2D

var offset :float = 0.0

var data :Dictionary[String,Variant] = {}

var rotSpeed :float = 8.0

func onReady() -> void:
	addState("idle")
	addState("flyingIn")
	addState("dead")
	setState(states.idle)
	
	$Sprite.texture = ItemManager.getItem(itemInstance.itemID).itemTexture
	
	offset = Time.get_ticks_msec()
	
	
	data["entity"] = self
	data["world"] = world
	itemInstance.runFunctionOnComponents("onDrop",data)

func onProcess(delta:float) -> void:
	
	$Sprite.scale.x = move_toward($Sprite.scale.x,0.75,delta * 10.0)
	$Sprite.scale.y = move_toward($Sprite.scale.y,0.75,delta * 10.0)
	
	
	itemInstance.runFunctionOnComponents("whileOnGround",data)
	
	match state:
		states.idle:
			
			velocity.y += gravity * delta
			if is_on_floor():
				velocity.x = move_toward(velocity.x,0.0,delta * 120.0)
				$Sprite.position.y = (sin((Time.get_ticks_msec() + offset) * 0.01) * 2.0) - 2.0
				$Sprite.rotation = lerp_angle($Sprite.rotation,0.0,0.2)
			else:
				velocity.x = move_toward(velocity.x,0.0,delta * 26.0)
				$Sprite.rotate(rotSpeed * delta)
			move_and_slide()
		states.flyingIn:
			if !is_instance_valid(flyTarget):
				setState(states.idle)
				return
			var g :Vector2 = flyTarget.global_position + Vector2(0,-8)
			velocity = (g - global_position).normalized() * 50.0
			global_position.x = move_toward(global_position.x,g.x,100.0*delta)
			global_position.y = move_toward(global_position.y,g.y,100.0*delta)
			

			if to_local(g).length() < 4.0:
				if itemInstance.amount <= 0:
					setState(states.dead)
					queue_free()
				else:
					setState(states.idle)

func getStateTransition(delta:float):
	return null

func enterState(new_state:int,old_state:int) -> void:
	match new_state:
		states.idle:
			$CollisionShape2D.call_deferred("set_disabled",false)
		states.flyingIn:
			$CollisionShape2D.call_deferred("set_disabled",true)

func exitState(old_state:int, new_state:int) -> void:
	pass

func onDeath() -> void:
	queue_free()


func _on_scanner_body_entered(body: Node2D) -> void:
	if body is Player:
		# get picked up by player
		var amountLeftover : int = InventoryManager.addItemByInstance(itemInstance)
		itemInstance = itemInstance.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
		itemInstance.amount = amountLeftover
		flyTarget = body
		setState(states.flyingIn)
