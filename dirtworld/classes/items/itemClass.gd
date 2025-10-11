extends Resource
class_name Item

# This is a resource for defining items, not item instances

@export var itemStringID :String = ""
@export var itemName :String = "" # Later we need to change this to be translatable

@export var itemTexture :Texture2D

## Components are duplicated for item instances.
@export var components :Array[ItemComponent]
