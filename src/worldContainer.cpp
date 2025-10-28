#include "worldContainer.h"
#include <godot_cpp/core/class_db.hpp>
#include "chunk.h"
#include "blockContainer.h"

#include <godot_cpp/classes/fast_noise_lite.hpp>

using namespace godot;

void WORLDCONTAINER::_bind_methods() {
    ClassDB::bind_method(D_METHOD("setBlockContainer","container"), &WORLDCONTAINER::setBlockContainer);
    ClassDB::bind_method(D_METHOD("initializeArray","width","height"), &WORLDCONTAINER::initializeArray);

    ClassDB::bind_method(D_METHOD("debugWorldGen","seed"), &WORLDCONTAINER::debugWorldGen);

    ClassDB::bind_method(D_METHOD("chunkLoadArea","centerChunkX","centerChunkY","loadWidth","loadHeight"), &WORLDCONTAINER::chunkLoadArea);
    ClassDB::bind_method(D_METHOD("unloadChunks","centerChunkX","centerChunkY","loadWidth","loadHeight"), &WORLDCONTAINER::unloadChunks);
    ClassDB::bind_method(D_METHOD("getLoadedChunks"), &WORLDCONTAINER::getLoadedChunks);

    ClassDB::bind_method(D_METHOD("simulateLoadedChunks","gameTick"), &WORLDCONTAINER::simulateLoadedChunks);
    ClassDB::bind_method(D_METHOD("simulateRandomTick","gameTick","attemptCount"), &WORLDCONTAINER::simulateRandomTick);

    ClassDB::bind_method(D_METHOD("editBlock","changeX","changeY","blockID"), &WORLDCONTAINER::editBlock);
    ClassDB::bind_method(D_METHOD("applyManualChanges"), &WORLDCONTAINER::applyManualChanges);
    ClassDB::bind_method(D_METHOD("getBlock","x","y"), &WORLDCONTAINER::getBlock);
    ClassDB::bind_method(D_METHOD("getBG","x","y"), &WORLDCONTAINER::getBG);

    ClassDB::bind_method(D_METHOD("breakBlock","tileX","tileY"), &WORLDCONTAINER::breakBlock);

    ClassDB::bind_method(D_METHOD("setInfoData","tileX","tileY","newInfo"), &WORLDCONTAINER::setInfoData);
    ClassDB::bind_method(D_METHOD("getInfoData","tileX","tileY"), &WORLDCONTAINER::getInfoData);

    ClassDB::bind_method(D_METHOD("setBGAmbientOcclusionImage","image"), &WORLDCONTAINER::setBGAmbientOcclusionImage);
    ClassDB::bind_method(D_METHOD("setBGCutOutImage","image","otherimage"), &WORLDCONTAINER::setBGCutOutImage);

    ClassDB::bind_method(D_METHOD("setLightData","x","y","r","g","b"), &WORLDCONTAINER::setLightData);

    ADD_SIGNAL(MethodInfo("queue_delete_chunk", PropertyInfo(Variant::VECTOR2I, "delete_pos"))); // creates a signal for us
    ADD_SIGNAL(MethodInfo("dropGroundItem", PropertyInfo(Variant::STRING, "itemID"),PropertyInfo(Variant::INT, "amount"),PropertyInfo(Variant::INT, "tileX"),PropertyInfo(Variant::INT, "tileY")));
}

WORLDCONTAINER::WORLDCONTAINER() {
    bitmap.instantiate();
    totalTileCount = 0;
}

WORLDCONTAINER::~WORLDCONTAINER() {
	// Add your cleanup here.
}

void WORLDCONTAINER::setBlockContainer(BLOCKCONTAINER *container){
    blockContainer = container;
}

void WORLDCONTAINER::setBGAmbientOcclusionImage(Ref<Image> newImage){
    BGAmbientOcclusionImage = newImage;
}

Ref<Image> WORLDCONTAINER::getBGAmbientOcclusionImage(){
    return BGAmbientOcclusionImage;
}

void WORLDCONTAINER::setBGCutOutImage(Ref<Image> newImage, Ref<Image> otherImage){
    BGCutOutImage = newImage;
    BGCutOutEdge = otherImage;
}

Ref<Image> WORLDCONTAINER::getBGCutOutImage(){
    return BGCutOutImage;
}

Ref<Image> WORLDCONTAINER::getBGCutOutEdgeImage(){
    return BGCutOutEdge;
}

void WORLDCONTAINER::initializeArray(int width, int height){
    worldWidth = width * 8;
    worldHeight = height * 8;

    widthInChunks = width;
    heightInChunks = height;


    totalTileCount = worldWidth * worldHeight;

    tileData = new std::string[totalTileCount];
    lightData = new std::tuple<float,float,float>[totalTileCount];
    infoData = new int[totalTileCount];
    bgData = new std::string[totalTileCount];
    for(int x = 0; x < worldWidth; x++){
        for(int y = 0; y < worldHeight; y++){
            setTileData(x,y,"air");
            setLightData(x,y,0.0,0.0,0.0);
            setInfoData(x,y,std::rand() % 4);
            setBGData(x,y,"air");
        }
    }

}

void WORLDCONTAINER::debugWorldGen(int seed){

    Ref<FastNoiseLite> noise = memnew(FastNoiseLite);
    noise->set_seed(seed);

    for(int x = 0; x < worldWidth; x++){

        int surfaceHeight = 32 + (noise->get_noise_1d(x) * 12);

        for(int y = 0; y < worldHeight; y++){

            if (y > surfaceHeight){
                setTileData(x,y,"grass");
            }

            if (y > surfaceHeight + 1){
                setTileData(x,y,"dirt");
            }

            if (y > surfaceHeight + 6){
                setTileData(x,y,"stone");
                setBGData(x,y,"stone");
            }

            if (noise->get_noise_2d(x,y) > 0.2){
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

/////////////////////////
// SETTERS AND GETTERS //
/////////////////////////

// tile

void WORLDCONTAINER::setTileData(int x, int y, std::string newTile){
    tileData[convertCoord(x,y)] = newTile;
}

std::string WORLDCONTAINER::getTileData(int x, int y){
    return tileData[convertCoord(x,y)];
}


// light

void WORLDCONTAINER::setLightData(int x, int y, float r, float g, float b){
    lightData[convertCoord(x,y)] = std::make_tuple(r,g,b);
}

std::tuple<float, float, float> WORLDCONTAINER::getLightData(int x, int y){
    return lightData[convertCoord(x,y)];
}

void WORLDCONTAINER::setLightDataTuple(int x, int y, std::tuple<float, float, float> newValue){
    lightData[convertCoord(x,y)] = newValue;
}

// info

void WORLDCONTAINER::setInfoData(int x, int y, int newInfo){
    infoData[convertCoord(x,y)] = newInfo;
}

int WORLDCONTAINER::getInfoData(int x, int y){
    return infoData[convertCoord(x,y)];
}

// bg

void WORLDCONTAINER::setBGData(int x, int y, std::string newBG){
    bgData[convertCoord(x,y)] = newBG;
}

std::string WORLDCONTAINER::getBGData(int x, int y){
    return bgData[convertCoord(x,y)];
}

///////////////////
// CHUNK LOADING //
///////////////////

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

            if( coord.x >= widthInChunks || coord.y >= heightInChunks ){
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

    updateChunks(changedTiles);

    blockChangeQueue.clear();

}

void WORLDCONTAINER::simulateRandomTick(int gameTick, int attemptCount){

    int sector = gameTick % 4;

    for(int i=0; i < attemptCount; i++){
        int worldX = std::rand() % worldWidth;
        int worldY = std::rand() % worldHeight;

        std::string blockID = getTileData(worldX,worldY);
        Ref<BLOCKOBJECT> block = blockContainer->getObjectFromString(blockID);
        block->simulateRandomComponents(worldX,worldY,blockID,blockContainer,this);
    }


}

void WORLDCONTAINER::updateChunks(std::unordered_map<int, bool> changedTiles){
    

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



        // check to redraw side chunk if on edge tile. probably better way to do this, so try redoing this later.
        if (coords.x % 8 == 0){ // left side of chunk
            if( loadedChunks.has( Vector2i(x-1,y) ) ){
                CHUNK *chunkObj = Object::cast_to<CHUNK>( loadedChunks[Vector2i(x-1,y)] );
                if(!chunksToUpdate.has(chunkObj)){
                    chunksToUpdate.append(chunkObj); // collect chunks
                }
            }
        }



        if (coords.x % 8 == 7){ // right side of chunk
            if( loadedChunks.has( Vector2i(x+1,y) ) ){
                CHUNK *chunkObj = Object::cast_to<CHUNK>( loadedChunks[Vector2i(x+1,y)] );
                if(!chunksToUpdate.has(chunkObj)){
                    chunksToUpdate.append(chunkObj); // collect chunks
                }
            }
        }

        if (coords.y % 8 == 0){ // top side of chunk
            if( loadedChunks.has( Vector2i(x,y-1) ) ){
                CHUNK *chunkObj = Object::cast_to<CHUNK>( loadedChunks[Vector2i(x,y-1)] );
                if(!chunksToUpdate.has(chunkObj)){
                    chunksToUpdate.append(chunkObj); // collect chunks
                }
            }
        }
        if (coords.y % 8 == 7){ // bottom side of chunk
            if( loadedChunks.has( Vector2i(x,y+1) ) ){
                CHUNK *chunkObj = Object::cast_to<CHUNK>( loadedChunks[Vector2i(x,y+1)] );
                if(!chunksToUpdate.has(chunkObj)){
                    chunksToUpdate.append(chunkObj); // collect chunks
                }
            }
        }

        // should add checks for corners too eventually

    }

    for( int i = 0; i < chunksToUpdate.size(); i++ ){
        CHUNK *chunkObj = Object::cast_to<CHUNK>( chunksToUpdate[i] );
        chunkObj->drawTiles(this,bitmap);
    }
    
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

// SIM ONE TIMERS

void WORLDCONTAINER::breakBlock(int tileX, int tileY){
    std::string blockID = getTileData(tileX,tileY);
    Ref<BLOCKOBJECT> blockObj = blockContainer->getObjectFromString(blockID);
    blockObj->simulateBreakComponents(tileX,tileY,blockID,blockContainer,this);
}


void WORLDCONTAINER::spawnItem(String itemID, int amount, int x, int y){
    emit_signal("dropGroundItem", itemID, amount, x, y);
}


// GDScript Editing

void WORLDCONTAINER::editBlock(int changeX, int changeY, String blockID){
    std::string newID = blockID.ascii().get_data();
    manualBlockQueue[convertCoord(changeX,changeY)] = newID;
}

void WORLDCONTAINER::editBlockManually(int changeX, int changeY, std::string blockID){
    manualBlockQueue[convertCoord(changeX,changeY)] = blockID;
}

String WORLDCONTAINER::getBlock(int x, int y){
    return getTileData(x,y).c_str();
}

String WORLDCONTAINER::getBG(int x, int y){
    return getBGData(x,y).c_str();
}

void WORLDCONTAINER::applyManualChanges(){
    std::unordered_map<int, bool> changedIndexes;
    for (auto i : manualBlockQueue){
        tileData[i.first] = i.second;
        changedIndexes[i.first] = true;
    }   
    updateChunks(changedIndexes);

    manualBlockQueue.clear();

}

// math

Vector2i WORLDCONTAINER::getBorderPos(int x, int y){

    Vector2i vecPos = Vector2i(0,0);


    int L = blockContainer->getBlockIsTransparent( getTileData(x-1,y) );
    int R = blockContainer->getBlockIsTransparent( getTileData(x+1,y) );
    int T = blockContainer->getBlockIsTransparent( getTileData(x,y-1) );
    int B = blockContainer->getBlockIsTransparent( getTileData(x,y+1) );

    int LT = blockContainer->getBlockIsTransparent( getTileData(x-1,y-1) );
    int RT = blockContainer->getBlockIsTransparent( getTileData(x+1,y-1) );
    int LB = blockContainer->getBlockIsTransparent( getTileData(x-1,y+1) );
    int RB = blockContainer->getBlockIsTransparent( getTileData(x+1,y+1) );

    int index = L + (R*2) + (T*4) + (B*8) + (LT * 16) + (RT * 32) + (LB * 64) + (RB * 128);
    vecPos.x = connectFindX[index];
    vecPos.y = connectFindY[index];

    return vecPos;
}

Vector2i WORLDCONTAINER::getPoopPass(int x, int y){ // function for wall border cutout

    Vector2i vecPos = Vector2i(0,0);


    int L = getBGData(x-1,y) != "air" || !blockContainer->getBlockIsTransparent( getTileData(x-1,y) );
    int R = getBGData(x+1,y) != "air" || !blockContainer->getBlockIsTransparent( getTileData(x+1,y) );
    int T = getBGData(x,y-1) != "air" || !blockContainer->getBlockIsTransparent( getTileData(x,y-1) );
    int B = getBGData(x,y+1) != "air" || !blockContainer->getBlockIsTransparent( getTileData(x,y+1) );

    int LT = getBGData(x-1,y-1)  != "air" || !blockContainer->getBlockIsTransparent( getTileData(x-1,y-1) );
    int RT = getBGData(x+1,y-1)  != "air" || !blockContainer->getBlockIsTransparent( getTileData(x+1,y-1) );
    int LB = getBGData(x-1,y+1)  != "air" || !blockContainer->getBlockIsTransparent( getTileData(x-1,y+1) );
    int RB = getBGData(x+1,y+1)  != "air" || !blockContainer->getBlockIsTransparent( getTileData(x+1,y+1) );

    int index = L + (R*2) + (T*4) + (B*8) + (LT * 16) + (RT * 32) + (LB * 64) + (RB * 128);
    vecPos.x = connectFindX[index];
    vecPos.y = connectFindY[index];

    return vecPos;
}





