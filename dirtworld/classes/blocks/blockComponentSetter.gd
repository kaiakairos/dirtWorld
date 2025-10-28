@tool
extends Resource
class_name BlockComponentSetter

@export var componentType :BLOCKCOMPONENT: set = componentChanged

## [ name of function, data to insert ]. can only handle functions that take ONE value.
@export var setValues :Dictionary[StringName,Variant]

func createComponent(componentArray:Array[BLOCKCOMPONENT]) -> void:
	for function in setValues.keys():
		componentType.call(function,setValues[function])
	componentArray.append(componentType)

func componentChanged(newComponent:BLOCKCOMPONENT) -> void:
	componentType = newComponent
	if componentType == null:
		return
	var type :String = componentType.get_class()
	match type:
		"COMPONENTCHANGE":
			setValues = {"setBlockToChangeInto":"stone","setChance":100}
		"COMPONENTDROPITEM":
			setValues = {"setItemID":"stone","setAmountMin":1,"setAmountMax":1}
		"COMPONENTGROWGRASS":
			setValues = {"setBlockToGrowOn":"dirt","setSpreadchance":1000,"setNeedsAir":true}
		"COMPONENTMULTITILETEXTURE":
			setValues = {"setHeightInTiles":2,"setWidthInTiles":2,"setShouldBreakItself":true}
