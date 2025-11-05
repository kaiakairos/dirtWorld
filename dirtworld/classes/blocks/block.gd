extends Resource
class_name Block

@export var blockID :String = ""
@export var texture :Texture2D

var components :Array[BLOCKCOMPONENT]
@export var setComponents :Array[BlockComponentSetter]

@export_group("Interact")

@export var toughness:int = 0 # Tool tier needed to break
@export var health :int = 3
@export var indestructible :bool = false
@export var isReplaceable :bool = false

@export_group("Collision")
@export_enum("SOLID","NONE","PLATFORM") var collisionType :int = 0

@export_group("Light")
@export var lightEmission : Color = Color.BLACK # CHANGE LIGHT TO COMPONENT SYSTEM
@export var isTransparent : bool = false
@export var lightPassThrough : float = 0.86

@export_group("Animation")
@export_enum("NONE","SLOW","FAST") var animState :int = 0
@export var animSplit :int = 8
