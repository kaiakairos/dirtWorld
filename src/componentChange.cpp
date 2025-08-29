#include "componentChange.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;

void COMPONENTCHANGE::_bind_methods() {
    ClassDB::bind_method(D_METHOD("setChance","newChance"), &COMPONENTCHANGE::setChance);
    ClassDB::bind_method(D_METHOD("getChance"), &COMPONENTCHANGE::getChance);

    ClassDB::bind_method(D_METHOD("setBlockToChangeInto","newBlock"), &COMPONENTCHANGE::setBlockToChangeInto);
    ClassDB::bind_method(D_METHOD("getBlockToChangeInto"), &COMPONENTCHANGE::getBlockToChangeInto);

    ADD_PROPERTY(PropertyInfo(Variant::INT, "chance"), "setChance", "getChance");
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "blockToChangeInto"), "setBlockToChangeInto", "getBlockToChangeInto");
}

COMPONENTCHANGE::COMPONENTCHANGE() {

    id = "change";
    chance = 10;
    blockToChangeInto = "stone";
    

}

COMPONENTCHANGE::~COMPONENTCHANGE() {
	// Add your cleanup here.
}

void COMPONENTCHANGE::setChance(int newChance){
    chance = newChance;
}
int COMPONENTCHANGE::getChance(){
    return chance;
}

void COMPONENTCHANGE::setBlockToChangeInto(String newBlock){
    hold = newBlock;
    blockToChangeInto = newBlock.ascii().get_data();
}
String COMPONENTCHANGE::getBlockToChangeInto(){
    return hold;
}

void COMPONENTCHANGE::onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    if(std::rand() % chance == 0){
        worldContainer->addBlockChangeToQueue(x,y,blockToChangeInto);
    }
}

void COMPONENTCHANGE::onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    
}

void COMPONENTCHANGE::onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    
}

void COMPONENTCHANGE::onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    
}

void COMPONENTCHANGE::onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    
}
