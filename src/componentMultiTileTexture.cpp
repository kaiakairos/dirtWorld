#include "componentMultiTileTexture.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;
void COMPONENTMULTITILETEXTURE::_bind_methods() {
	ClassDB::bind_method(D_METHOD("setHeightInTiles","newHeightInTiles"), &COMPONENTMULTITILETEXTURE::setHeightInTiles);
	ClassDB::bind_method(D_METHOD("setWidthInTiles","newWidthInTiles"), &COMPONENTMULTITILETEXTURE::setWidthInTiles);
	ClassDB::bind_method(D_METHOD("setShouldBreakItself","newShouldBreakItself"), &COMPONENTMULTITILETEXTURE::setShouldBreakItself);
}

COMPONENTMULTITILETEXTURE::COMPONENTMULTITILETEXTURE() {
	id = "multitiletexture";
}

COMPONENTMULTITILETEXTURE::~COMPONENTMULTITILETEXTURE() { //cleanup 
}
void COMPONENTMULTITILETEXTURE::setHeightInTiles(int newHeightInTiles){
	heightInTiles = newHeightInTiles;
}
void COMPONENTMULTITILETEXTURE::setWidthInTiles(int newWidthInTiles){
	widthInTiles = newWidthInTiles;
}
void COMPONENTMULTITILETEXTURE::setShouldBreakItself(int newShouldBreakItself){
	shouldBreakItself = newShouldBreakItself;
}

Vector2i COMPONENTMULTITILETEXTURE::getImageRect(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){



	int info = worldContainer->getInfoData(x,y);

	Vector2i vecPos = Vector2i(info % widthInTiles,info/widthInTiles);

   return vecPos;
}


void COMPONENTMULTITILETEXTURE::onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTMULTITILETEXTURE::onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTMULTITILETEXTURE::onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){

	if(!shouldBreakItself){
		return;
	}

	int info = worldContainer->getInfoData(x,y);

	Vector2i vecPos = Vector2i(info % widthInTiles,info/widthInTiles);

	for(int mX = 0; mX < widthInTiles; mX++){
		for(int mY = 0; mY < heightInTiles; mY++){

			worldContainer->editBlockManually(x+mX-vecPos.x,y+mY-vecPos.y,"air");

		}
	}



}
void COMPONENTMULTITILETEXTURE::onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTMULTITILETEXTURE::onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
