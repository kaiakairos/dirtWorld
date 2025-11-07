#include "componentRandomizedTexture.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;
void COMPONENTRANDOMIZEDTEXTURE::_bind_methods() {
	ClassDB::bind_method(D_METHOD("setRange","newRange"), &COMPONENTRANDOMIZEDTEXTURE::setRange);
	ClassDB::bind_method(D_METHOD("setGap","newGap"), &COMPONENTRANDOMIZEDTEXTURE::setGap);
}

COMPONENTRANDOMIZEDTEXTURE::COMPONENTRANDOMIZEDTEXTURE() {
	id = "randomizedtexture";
}

COMPONENTRANDOMIZEDTEXTURE::~COMPONENTRANDOMIZEDTEXTURE() { //cleanup 
}
void COMPONENTRANDOMIZEDTEXTURE::setRange(int newRange){
	range = newRange;
}
void COMPONENTRANDOMIZEDTEXTURE::setGap(int newGap){
	gap = newGap;
}
void COMPONENTRANDOMIZEDTEXTURE::onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTRANDOMIZEDTEXTURE::onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTRANDOMIZEDTEXTURE::onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTRANDOMIZEDTEXTURE::onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}
void COMPONENTRANDOMIZEDTEXTURE::onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){}

Vector2i COMPONENTRANDOMIZEDTEXTURE::getImageRect(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
	int value = worldContainer->getRandomArrayNumber(x,y) % range;

    Vector2i v = Vector2i(value * gap,0);
    return v;
}