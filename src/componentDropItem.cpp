#include "componentDropItem.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;

void COMPONENTDROPITEM::_bind_methods() {
    ClassDB::bind_method(D_METHOD("setAmountMin","newAmountMin"), &COMPONENTDROPITEM::setAmountMin);

    ClassDB::bind_method(D_METHOD("setAmountMax","newAmountMax"), &COMPONENTDROPITEM::setAmountMax);

    ClassDB::bind_method(D_METHOD("setItemID","newID"), &COMPONENTDROPITEM::setItemID);
}

COMPONENTDROPITEM::COMPONENTDROPITEM() {

    id = "dropItem";
    amountMin = 1;
    amountMax = 1;
    itemID = "stone";
    

}

COMPONENTDROPITEM::~COMPONENTDROPITEM() {
	// Add your cleanup here.
}

void COMPONENTDROPITEM::setAmountMin(int newAmountMin){
    amountMin = newAmountMin;
}


void COMPONENTDROPITEM::setAmountMax(int newAmountMax){
    amountMax = newAmountMax;
}



void COMPONENTDROPITEM::setItemID(String newID){
    itemID = newID;
}



void COMPONENTDROPITEM::onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){

}

void COMPONENTDROPITEM::onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){

}

void COMPONENTDROPITEM::onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    int range = amountMax - amountMin;
    int amount = amountMin;
    if (range > 0){
        amount = amountMin + (std::rand() % (range + 1));
    }
    worldContainer->spawnItem(itemID,amount,x,y);
}

void COMPONENTDROPITEM::onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){

}

void COMPONENTDROPITEM::onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){

}
