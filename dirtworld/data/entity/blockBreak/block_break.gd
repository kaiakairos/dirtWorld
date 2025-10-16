extends Node2D
class_name BlockBreaker

var worldContainer :WORLDCONTAINER

var damage :int = 0

var tile:Vector2i = Vector2i.ZERO

var blockHealth:int = 3

var tick :float = 0.0

var BROKEN :bool = false

func _ready() -> void:
	$origin/BlockTexture.texture = BlockManager.getBlockImageFromWorld(tile.x,tile.y,worldContainer)
	$BlockTexture2.texture = $origin/BlockTexture.texture
	$CPUParticles2D.texture = $origin/BlockTexture.texture
	$BreakParticle.texture = $origin/BlockTexture.texture
	
func _physics_process(delta: float) -> void:
	
	if BROKEN:
		$origin.scale = lerp($origin.scale,Vector2(0.0,0.0),0.1)
		return
	
	tick += delta
	$origin.position = lerp($origin.position,Vector2(4,4),0.2)
	$origin.rotation = lerp($origin.rotation,0.0,0.2)
	$origin.scale = lerp($origin.scale,Vector2(1,1),0.2)
	$origin/BlockTexture.modulate = lerp($origin/BlockTexture.modulate,Color.WHITE,0.2)
	if tick > 1.5:
		damage -= 1
		$origin/Break.frame = clamp(roundi(( float(damage) / float(blockHealth)) * $origin/Break.hframes ),0,$origin/Break.hframes-1)
		damage = max(0,damage)
		tick = 0.0
		if damage == 0:
			queue_free()

func doDamage(amount:int=1):
	
	if BROKEN:
		return
	
	damage += amount
	$origin/Break.frame = clamp(roundi(( float(damage) / float(blockHealth)) * $origin/Break.hframes ),0,$origin/Break.hframes-1)
	tick = -4.0
	$origin.rotation = randf_range(-2.0,2.0)
	$origin.position = Vector2(0.0,1.0).rotated(randf_range(-PI,PI)) + Vector2(4.0,4.0)
	$origin.scale = Vector2(1.1,1.1)
	$origin/BlockTexture.modulate = Color(1.2,1.2,1.2)
	
	$CPUParticles2D.restart(false)
	$CPUParticles2D.emitting = true
	
	if damage >= blockHealth:
		
		worldContainer.breakBlock(tile.x,tile.y)
		
		worldContainer.editBlock(tile.x,tile.y,"air")
		worldContainer.applyManualChanges()
		#$origin.hide()
		$BlockTexture2.hide()
		BROKEN=true
		$BreakParticle.emitting = true
		await get_tree().create_timer(1.0).timeout
		
		queue_free()
