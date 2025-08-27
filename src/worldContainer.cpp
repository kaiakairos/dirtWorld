#include "worldContainer.h"
#include <godot_cpp/core/class_db.hpp>
#include "chunk.h"
#include "blockContainer.h"

using namespace godot;

void WORLDCONTAINER::_bind_methods() {
    ClassDB::bind_method(D_METHOD("setBlockContainer","container"), &WORLDCONTAINER::setBlockContainer);
    ClassDB::bind_method(D_METHOD("initializeArray","width","height"), &WORLDCONTAINER::initializeArray);

    ClassDB::bind_method(D_METHOD("debugWorldGen"), &WORLDCONTAINER::debugWorldGen);
}

WORLDCONTAINER::WORLDCONTAINER() {
}

WORLDCONTAINER::~WORLDCONTAINER() {
	// Add your cleanup here.
}

void WORLDCONTAINER::setBlockContainer(BLOCKCONTAINER *container){
    blockContainer = container;
}

void WORLDCONTAINER::initializeArray(int width, int height){
    worldWidth = width;
    worldHeight = height;

    tileData = new std::string[worldWidth * worldHeight];
    for(int x = 0; x < worldWidth; x++){
        for(int y = 0; y < worldHeight; y++){
            setTileData(x,y,"stone");
        }
    }

}

void WORLDCONTAINER::debugWorldGen(){

    for(int x = 0; x < worldWidth; x++){
        for(int y = 0; y < worldHeight; y++){
            if(x < y){
                setTileData(x,y,"dirt");
            }
            
        }
    }

    createNewChunk(0,0); // debug

}

int WORLDCONTAINER::convertCoord(int x, int y){
    int arraySize = worldWidth * worldHeight;
    int xyToLarge = (x * worldHeight) + y;
    xyToLarge = std::clamp(xyToLarge,0,arraySize-1);
    return xyToLarge;
}

void WORLDCONTAINER::setTileData(int x, int y, std::string newTile){
    tileData[convertCoord(x,y)] = newTile;
}

std::string WORLDCONTAINER::getTileData(int x, int y){
    return tileData[convertCoord(x,y)];
}

void WORLDCONTAINER::createNewChunk(int chunkX, int chunkY){
    CHUNK *newChunk = memnew(CHUNK);
    
    newChunk->setBlockContainer(blockContainer);
    newChunk->setPosition(chunkX,chunkY);
    newChunk->drawTiles(this);
    
    add_child(newChunk);

}