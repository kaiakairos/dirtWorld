extends Resource
class_name Block

@export var blockID :String = ""
@export var texture :Texture2D

## Tool tier needed to break
@export var toughness:int = 0
@export var health :int = 3
@export var indestructible :bool = false

@export var components :Array[BLOCKCOMPONENT]

@export var lightEmission : Color = Color.BLACK # CHANGE LIGHT TO COMPONENT SYSTEM
@export var isTransparent : bool = false
@export var lightPassThrough : float = 0.86

@export var isReplaceable :bool = false
