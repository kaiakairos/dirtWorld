#include "worldContainer.h"
#include <godot_cpp/core/class_db.hpp>
#include "chunk.h"
#include "blockContainer.h"

using namespace godot;

void WORLDCONTAINER::_bind_methods() {
    ClassDB::bind_method(D_METHOD("setBlockContainer","container"), &WORLDCONTAINER::setBlockContainer);
    ClassDB::bind_method(D_METHOD("initializeArray","width","height"), &WORLDCONTAINER::initializeArray);

    ClassDB::bind_method(D_METHOD("debugWorldGen"), &WORLDCONTAINER::debugWorldGen);

    ClassDB::bind_method(D_METHOD("chunkLoadArea","centerChunkX","centerChunkY","loadWidth","loadHeight"), &WORLDCONTAINER::chunkLoadArea);
    ClassDB::bind_method(D_METHOD("unloadChunks","centerChunkX","centerChunkY","loadWidth","loadHeight"), &WORLDCONTAINER::unloadChunks);
    ClassDB::bind_method(D_METHOD("getLoadedChunks"), &WORLDCONTAINER::getLoadedChunks);

    ClassDB::bind_method(D_METHOD("simulateLoadedChunks","gameTick"), &WORLDCONTAINER::simulateLoadedChunks);

    ADD_SIGNAL(MethodInfo("queue_delete_chunk", PropertyInfo(Variant::VECTOR2I, "delete_pos"))); // creates a signal for us
}

WORLDCONTAINER::WORLDCONTAINER() {
    bitmap.instantiate();
}

WORLDCONTAINER::~WORLDCONTAINER() {
	// Add your cleanup here.
}

void WORLDCONTAINER::setBlockContainer(BLOCKCONTAINER *container){
    blockContainer = container;
}

void WORLDCONTAINER::initializeArray(int width, int height){
    worldWidth = width * 8;
    worldHeight = height * 8;

    widthInChunks = width;
    heighInChunks = height;

    tileData = new std::string[worldWidth * worldHeight];
    lightData = new std::tuple<float,float,float>[worldWidth * worldHeight];
    for(int x = 0; x < worldWidth; x++){
        for(int y = 0; y < worldHeight; y++){
            setTileData(x,y,"stone");
            setLightData(x,y,0.0,0.0,0.0);
        }
    }

}

void WORLDCONTAINER::debugWorldGen(){

    for(int x = 0; x < worldWidth; x++){
        for(int y = 0; y < worldHeight; y++){
            if (y < 38 + (sin(x * 0.1) * 2)){
                setTileData(x,y,"dirt");
            }

            if (y < 32 + (sin(x * 0.15) * 2)) {
                setTileData(x,y,"air");
            }
            
        }
    }

}

int WORLDCONTAINER::convertCoord(int x, int y){
    int arraySize = worldWidth * worldHeight;
    int xyToLarge = (x * worldHeight) + y;
    xyToLarge = std::clamp(xyToLarge,0,arraySize-1);
    return xyToLarge;
}

Vector2i WORLDCONTAINER::reverseCoordCoversion(int index){
    int arraySize = worldWidth * worldHeight;
    
    int x = index / worldHeight;
    int y = index % worldHeight;

    return Vector2i(x,y); // maybe change to pair ?
}

void WORLDCONTAINER::setTileData(int x, int y, std::string newTile){
    tileData[convertCoord(x,y)] = newTile;
}

std::string WORLDCONTAINER::getTileData(int x, int y){
    return tileData[convertCoord(x,y)];
}

void WORLDCONTAINER::setLightData(int x, int y, float r, float g, float b){
    lightData[convertCoord(x,y)] = std::make_tuple(r,g,b);
}

std::tuple<float, float, float> WORLDCONTAINER::getLightData(int x, int y){
    return lightData[convertCoord(x,y)];
}

void WORLDCONTAINER::setLightDataTuple(int x, int y, std::tuple<float, float, float> newValue){
    lightData[convertCoord(x,y)] = newValue;
}

// CHUNK LOADING //

void WORLDCONTAINER::createNewChunk(int chunkX, int chunkY){
    CHUNK *newChunk = memnew(CHUNK);
    
    newChunk->setBlockContainer(blockContainer);
    newChunk->setPosition(chunkX,chunkY);
    newChunk->drawTiles(this,bitmap); // other chunk initialization
    
    add_child(newChunk);

    loadedChunks[Vector2i(chunkX,chunkY)] = newChunk;

}

void WORLDCONTAINER::chunkLoadArea(int centerChunkX, int centerChunkY, int loadWidth, int loadHeight){
    // load width and height are radii. a width of 5 and a height of 4 translate to 11 chunks wide and 9 chunks tall

    int width = (loadWidth * 2) + 1;
    int height = (loadHeight * 2) + 1;

    for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
            Vector2i coord = Vector2i((x + centerChunkX) - loadWidth,(y + centerChunkY) - loadHeight);  

            if( coord.x < 0 || coord.y < 0 ){
                continue; // dont create negative chunks
            }

            if( coord.x >= widthInChunks || coord.y >= heighInChunks ){
                continue; // dont create overflowing chunks
            }

            if( loadedChunks.has(coord) ){
                continue; // dont create chunks that already exist
            }
           
            createNewChunk(coord.x,coord.y);

        }
    }

}


void WORLDCONTAINER::unloadChunks(int centerChunkX, int centerChunkY, int loadWidth, int loadHeight){

    Array chunks = get_children(); // array of all existing chunks

    for( int i = 0; i < get_child_count(); i++ ){ 
        CHUNK *obj = Object::cast_to<CHUNK>(chunks[i]);
        Vector2i key = obj->getPosition();
        if(key.x <  centerChunkX - loadWidth || key.x > centerChunkX + loadWidth || key.y <  centerChunkY - loadHeight || key.y > centerChunkY + loadHeight){
            obj->queue_free();
            loadedChunks.erase(key);
        }
    }

}

Dictionary WORLDCONTAINER::getLoadedChunks(){
    return loadedChunks;
}


///////////////////////////////

// CHUNK SIMULATION //
void WORLDCONTAINER::simulateLoadedChunks(int gameTick){
    int sector = gameTick % 4;

    Array chunks = get_children(); // array of all existing chunks


    for( int i = 0; i < get_child_count(); i++ ){
        CHUNK *chunkObj = Object::cast_to<CHUNK>(chunks[i]);
        int chunkID4 = chunkObj->getID4();

        if(chunkID4 == sector){

            chunkObj->simulateTick(this);
             // probably inefficient to have these seperate since thats 2 whole loops of the object when it could be one. change later

        }
        chunkObj->simulateLight(this);

    }

    std::unordered_map<int, bool> changedTiles;
    changedTiles = parseAndApplyQueuedChanges();

    Array chunksToUpdate;

    for(auto i : changedTiles){ // parse through changed tiles so we redraw chunks
        Vector2i coords = reverseCoordCoversion(i.first);
        int x = coords.x / 8; // gets chunk position
        int y = coords.y / 8;

        if( loadedChunks.has( Vector2i(x,y) ) ){
            CHUNK *chunkObj = Object::cast_to<CHUNK>( loadedChunks[Vector2i(x,y)] );
            if(!chunksToUpdate.has(chunkObj)){
                chunksToUpdate.append(chunkObj); // collect chunks
            }
        }
    }

    for( int i = 0; i < chunksToUpdate.size(); i++ ){
        CHUNK *chunkObj = Object::cast_to<CHUNK>( chunksToUpdate[i] );
        chunkObj->drawTiles(this,bitmap);
    }



    blockChangeQueue.clear();
}

void WORLDCONTAINER::addBlockChangeToQueue(int changeX, int changeY, std::string blockID){
    // we could decide here whether or not to override existing changes
    blockChangeQueue[convertCoord(changeX,changeY)] = blockID;
}

std::unordered_map<int, bool> WORLDCONTAINER::parseAndApplyQueuedChanges(){
    std::unordered_map<int, bool> changedIndexes;
    for (auto i : blockChangeQueue){
        tileData[i.first] = i.second;
        changedIndexes[i.first] = true;
    }   
    return changedIndexes;
}
