#include "componentGrowGrass.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;
void COMPONENTGROWGRASS::_bind_methods() {
	ClassDB::bind_method(D_METHOD("setBlockToGrowOn","newBlockToGrowOn"), &COMPONENTGROWGRASS::setBlockToGrowOn);
	ClassDB::bind_method(D_METHOD("setSpreadchance","newSpreadchance"), &COMPONENTGROWGRASS::setSpreadchance);
	ClassDB::bind_method(D_METHOD("setNeedsAir","newNeedsAir"), &COMPONENTGROWGRASS::setNeedsAir);
}

COMPONENTGROWGRASS::COMPONENTGROWGRASS() {
	id = "growgrass";
}

COMPONENTGROWGRASS::~COMPONENTGROWGRASS() { //cleanup

}

void COMPONENTGROWGRASS::setBlockToGrowOn(String newBlockToGrowOn){
	blockToGrowOn = newBlockToGrowOn.ascii().get_data();
}
void COMPONENTGROWGRASS::setSpreadchance(int newSpreadchance){
	spreadchance = newSpreadchance;
}
void COMPONENTGROWGRASS::setNeedsAir(bool newNeedsAir){
	needsAir = newNeedsAir;
}

void COMPONENTGROWGRASS::onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}

void COMPONENTGROWGRASS::onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
	if(std::rand() % spreadchance != 0){
		return;
	}

	bool found = false;
	int grab = 0;
	Vector2i rot = Vector2i(0, 0);
	for(int tries = 0; tries < 10; tries++){
		grab = std::rand() % 8;
		rot = Vector2i(vecFindX[grab], vecFindY[grab]);
		if (worldContainer->getTileData(x + rot.x,y+rot.y) == blockToGrowOn){
			found = true;
			break;
		}
	}
	if(!found){
		return;
	}


	// check for air
	if (needsAir){
		int numOfAirBlocks = 0;
		for(int i = 0; i < 4; i++){ // get sides

			Vector2i airCheck = Vector2i( Vector2(0,1).rotated(acos(0.0) * i) );
			std::string thisBlock = worldContainer->getTileData(x + rot.x + airCheck.x,y + rot.y + airCheck.y);
			if(container->getBlockIsTransparent(thisBlock)){
				numOfAirBlocks++;
			}

		}

		if (numOfAirBlocks == 0){
			return;
		}
	}

	worldContainer->addBlockChangeToQueue(x + rot.x,y+rot.y,blockID);

}

void COMPONENTGROWGRASS::onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTGROWGRASS::onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTGROWGRASS::onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
