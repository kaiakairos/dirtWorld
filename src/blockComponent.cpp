#include "blockComponent.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;

void BLOCKCOMPONENT::_bind_methods() {
}

BLOCKCOMPONENT::BLOCKCOMPONENT() {
    id = "blank";
}

BLOCKCOMPONENT::~BLOCKCOMPONENT() {
	// Add your cleanup here.
}

void BLOCKCOMPONENT::onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){

}

void BLOCKCOMPONENT::onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    
}

void BLOCKCOMPONENT::onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    
}

void BLOCKCOMPONENT::onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    
}

void BLOCKCOMPONENT::onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    
}
