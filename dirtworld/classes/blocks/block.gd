extends Resource
class_name Block

@export var blockID :String = ""
@export var texture :Texture2D

@export var toughness:int

@export var components :Array[BLOCKCOMPONENT]

@export var lightEmission : Color = Color.BLACK
@export var isTransparent : bool
@export var lightPassThrough : float = 0.86
