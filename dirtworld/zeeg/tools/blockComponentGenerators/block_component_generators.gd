extends Node

@export var componentName :String = "DirtBreak"
var componentNameALLCAPS :String = ""
## key should be the same of the variable. only use lowercase letters (unless its String)
@export var variables :Dictionary[String,String] = {}

func _ready() -> void:
	componentName = componentName.to_pascal_case() # DirtBreak
	componentNameALLCAPS = "COMPONENT" + componentName.to_upper() # COMPONENTDIRTBREAK
	print(componentName)
	generateHFile()
	generateCPPFile()
	
	# open directory ??d

func generateHFile() -> void:
	var file = FileAccess.open("res://zeeg/tools/blockComponentGenerators/generated/component"+ componentName +".h", FileAccess.WRITE_READ)
	file.store_string("#ifndef " + componentNameALLCAPS + "_H\n")
	file.store_string("#define " + componentNameALLCAPS + "_H\n\n")
	file.store_string('#include "blockComponent.h"' + "\n" + '#include <godot_cpp/variant/string.hpp>' + "\n\n")
	file.store_string("namespace godot {\n\nclass BLOCKCONTAINER;\nclass WORLDCONTAINER;\n")
	file.store_string("class " + componentNameALLCAPS + " : public BLOCKCOMPONENT {\n    GDCLASS(" + componentNameALLCAPS + ", BLOCKCOMPONENT)\n\n")
	file.store_string("private:\n\nprotected:\n    static void _bind_methods();\n\npublic:\n")
	file.store_string("    "+componentNameALLCAPS+"();\n")
	file.store_string("    ~"+componentNameALLCAPS+"();\n\n")
	file.store_string("    std::string id; // used to check if components of type exist\n\n")
	file.store_string("    void onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);\n")
	file.store_string("    void onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);\n")
	file.store_string("    void onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);\n")
	file.store_string("    void onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);\n")
	file.store_string("    void onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);\n")
	file.store_string("    void onLoaded(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);\n")
	
	file.store_string("\n\n// values\n")
	
	for i in variables.keys():
		if variables[i] == "String":
			file.store_string( "std::string " + i + ";\n")
		else:
			file.store_string( variables[i] + " " + i + ";\n")
		file.store_string("\n")
		file.store_string("void set" + i.to_pascal_case() + "(" + variables[i] + " new" + i.to_pascal_case() + ");\n")
		file.store_string("\n")
	
	file.store_string("\n")
	file.store_string("\n")

	file.store_string("};\n")
	file.store_string("}\n")
	file.store_string("#endif\n")
	
	
func generateCPPFile() -> void:
	var file = FileAccess.open("res://zeeg/tools/blockComponentGenerators/generated/component"+ componentName +".cpp", FileAccess.WRITE_READ)
	file.store_string('#include "component' + componentName + '.h"\n')
	file.store_string('#include <godot_cpp/core/class_db.hpp>\n\n')
	file.store_string('#include "worldContainer.h"\n')
	file.store_string('#include "blockContainer.h"\n\n')
	file.store_string('using namespace godot;\n')
	file.store_string('void ' + componentNameALLCAPS + '::_bind_methods() {\n')
	for i in variables.keys():
		file.store_string('	ClassDB::bind_method(D_METHOD("set' + i.to_pascal_case() + '","new' + i.to_pascal_case() + '"), &' + componentNameALLCAPS +  '::set' + i.to_pascal_case() + ');')
		file.store_string('\n')
	file.store_string('}\n\n')
	file.store_string(componentNameALLCAPS + '::' + componentNameALLCAPS + '() {\n')
	file.store_string('	id = "' + componentName.to_lower() + '";\n')
	# set default values here? not sure if its entirely important
	file.store_string('}\n\n')
	file.store_string(componentNameALLCAPS + '::~' + componentNameALLCAPS + '() { //cleanup \n}\n')
	
	for i in variables.keys():
		file.store_string('void ' + componentNameALLCAPS + '::set'+ i.to_pascal_case() + '('+ variables[i] +' new'+ i.to_pascal_case() + '){\n')
		if variables[i] == "String":
			file.store_string('	' + i +' = new' + i.to_pascal_case() + '.ascii().get_data();\n}\n')
		else:
			file.store_string('	' + i +' = new' + i.to_pascal_case() + ';\n}\n')
	
	file.store_string('void ' + componentNameALLCAPS + '::onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}\n')
	file.store_string('void ' + componentNameALLCAPS + '::onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}\n')
	file.store_string('void ' + componentNameALLCAPS + '::onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}\n')
	file.store_string('void ' + componentNameALLCAPS + '::onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}\n')
	file.store_string('void ' + componentNameALLCAPS + '::onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}\n')
	file.store_string('void ' + componentNameALLCAPS + '::onLoaded(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}\n')
	
