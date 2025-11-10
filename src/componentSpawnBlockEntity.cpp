#include "componentSpawnBlockEntity.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;
void COMPONENTSPAWNBLOCKENTITY::_bind_methods() {
	ClassDB::bind_method(D_METHOD("setBlockEntityId","newBlockEntityId"), &COMPONENTSPAWNBLOCKENTITY::setBlockEntityId);
	ClassDB::bind_method(D_METHOD("setRequiredInfo","newRequiredInfo"), &COMPONENTSPAWNBLOCKENTITY::setRequiredInfo);
}

COMPONENTSPAWNBLOCKENTITY::COMPONENTSPAWNBLOCKENTITY() {
	id = "spawnblockentity";
}

COMPONENTSPAWNBLOCKENTITY::~COMPONENTSPAWNBLOCKENTITY() { //cleanup 
}
void COMPONENTSPAWNBLOCKENTITY::setBlockEntityId(String newBlockEntityId){
	poop = newBlockEntityId;
	blockEntityID = newBlockEntityId.ascii().get_data();
}
void COMPONENTSPAWNBLOCKENTITY::setRequiredInfo(int newRequiredInfo){
	requiredInfo = newRequiredInfo;
}
void COMPONENTSPAWNBLOCKENTITY::onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTSPAWNBLOCKENTITY::onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTSPAWNBLOCKENTITY::onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTSPAWNBLOCKENTITY::onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTSPAWNBLOCKENTITY::onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTSPAWNBLOCKENTITY::onLoaded(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
	worldContainer->spawnBlockEntity(poop,x,y);
}
