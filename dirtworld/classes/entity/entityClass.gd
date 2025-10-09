extends CharacterBody2D
class_name Entity

@export var world :World
var worldContainer :WORLDCONTAINER

@export var entityName :String = "Entity"
@export var entitySlots :int = 1

@export_group("Display")
@export var entitySpace :Vector2i = Vector2i(8,8)

@export_group("Stats")
@export var baseMaxHealth :int = 25
var health :int = baseMaxHealth

@export var defaultDamage :int = 10
var damage :int = defaultDamage

@export_subgroup("Movement")
@export var defaultSpeed :int = 80
var speed :int = defaultSpeed

@export var defaultJumpHeight :int = 200
var jumpheight :int = defaultJumpHeight

@export var defaultAcceleration :int = 250
var acceleration :int = defaultAcceleration

@export var defaultDeceleration :int = 250
var deceleration :int = defaultDeceleration

@export var defaultGravity :int = 600
var gravity :int = defaultGravity

@export_subgroup("Status")
@export var statusImmunities :Array[String] = []


signal statsReset
signal statsUpdated

###############################################
############ BASIC FUNCTIONS ##################
###############################################

func _ready() -> void:
	if !is_instance_valid(world):
		printerr("Entity spawned with no world assigned.")
		queue_free()
		return
	worldContainer = world.worldContainer
	health = baseMaxHealth # not inside set stats because we don't want this to be repeated
	setStats()
	onReady()

func _process(delta: float) -> void:
	onProcess(delta)
	onFrameBehaviors()
	if state == null:
		return
	var transition = getStateTransition(delta)
	if transition != null:
		setState(transition)

######################################################
################ STATUS EFFECTS ######################
######################################################

func setStats() -> void:
	speed = defaultSpeed
	jumpheight = defaultJumpHeight
	damage = defaultDamage
	acceleration = defaultAcceleration
	deceleration = defaultDeceleration
	gravity = defaultGravity
	emit_signal("statsReset")

func onFrameBehaviors() -> void:
	# this is for doing specific things like status
	# sliding on ice, conveyor belts pushing, etc.
	# it will run AFTER entity onProcess
	pass

func onStatusUpdate() -> void:
	setStats() # reset stats
	# maybe then we cycle through each status with something like
	# for status in appliedEffects:
	#	status.onStatusUpdate(entity) # pass in the entity, the status itself will do the stat changing
	
	emit_signal("statsUpdated")
	
######################################################
############### STATE MACHINE STUFF ##################
######################################################

var state :int= 0
var previous_state :int= -1
var states := {}

func setState(new_state:int) -> void:
	previous_state = state
	state = new_state
	
	if previous_state != -1:
		exitState(previous_state,new_state)
	
	if new_state != -1:
		enterState(new_state,previous_state)

func addState(state_name:String) -> void:
	states[state_name] = states.size()

###################################################
################# COPY BELOW ######################
###################################################

func onReady() -> void:
	pass

func onProcess(delta:float) -> void:
	pass

func getStateTransition(delta:float):
	return null

func enterState(new_state:int,old_state:int) -> void:
	pass

func exitState(old_state:int, new_state:int) -> void:
	pass

func onDeath() -> void:
	queue_free()
