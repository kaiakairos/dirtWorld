#ifndef WORLDCONTAINER_H
#define WORLDCONTAINER_H

#include <godot_cpp/classes/node.hpp>
#include <algorithm>
#include <memory>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/classes/bit_map.hpp>
#include <godot_cpp/variant/packed_string_array.hpp>
#include <unordered_map>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER : public Node {
    GDCLASS(WORLDCONTAINER, Node)

private:
    std::string *tileData;
    std::tuple<float, float, float> *lightData;
    int *infoData;
    std::string *bgData;

    int totalTileCount;

    // gulp
    int connectFindX[256] = {3, 2, 0, 1, 3, 8, 5, 4, 3, 8, 5, 4, 3, 3, 0, 4, 3, 2, 0, 1, 3, 2, 5, 6, 3, 8, 5, 4, 3, 8, 0, 9, 3, 2, 0, 1, 3, 8, 0, 7, 3, 8, 5, 4, 3, 3, 5, 9, 3, 2, 0, 1, 3, 2, 0, 1, 3, 2, 0, 4, 3, 8, 5, 4, 3, 2, 0, 1, 3, 8, 5, 4, 3, 2, 5, 6, 3, 8, 0, 9, 3, 2, 0, 1, 3, 2, 5, 6, 3, 2, 5, 6, 3, 2, 0, 1, 3, 2, 0, 1, 3, 8, 5, 7, 3, 2, 5, 6, 3, 8, 5, 6, 3, 2, 0, 1, 3, 2, 0, 1, 3, 2, 5, 6, 3, 2, 5, 6, 3, 2, 0, 1, 3, 8, 5, 4, 3, 8, 0, 7, 3, 3, 5, 9, 3, 2, 0, 1, 3, 2, 5, 6, 3, 8, 5, 7, 3, 8, 5, 5, 3, 2, 0, 1, 3, 8, 5, 7, 3, 8, 0, 7, 3, 3, 0, 2, 3, 2, 0, 1, 3, 2, 5, 1, 3, 8, 5, 7, 3, 8, 0, 7, 3, 2, 0, 1, 3, 8, 5, 4, 3, 2, 0, 1, 3, 8, 5, 4, 3, 2, 0, 1, 3, 2, 5, 6, 3, 2, 0, 1, 3, 2, 5, 6, 3, 2, 0, 1, 3, 8, 0, 7, 3, 8, 0, 1, 3, 8, 0, 7, 3, 2, 0, 1, 3, 2, 0, 1, 3, 2, 0, 1, 3, 2, 0, 1};

    int connectFindY[256] = {3, 3, 3, 3, 2, 3, 3, 3, 0, 0, 0, 0, 1, 4, 4, 4, 3, 3, 3, 3, 2, 2, 3, 3, 0, 0, 0, 0, 1, 1, 4, 0, 3, 3, 3, 3, 2, 3, 2, 3, 0, 0, 0, 0, 1, 4, 1, 2, 3, 3, 3, 3, 2, 2, 2, 2, 0, 0, 0, 0, 1, 1, 1, 1, 3, 3, 3, 3, 2, 3, 3, 3, 0, 0, 0, 0, 1, 2, 4, 1, 3, 3, 3, 3, 2, 2, 3, 3, 0, 0, 0, 0, 1, 1, 4, 4, 3, 3, 3, 3, 2, 3, 3, 3, 0, 0, 0, 0, 1, 2, 1, 4, 3, 3, 3, 3, 2, 2, 2, 2, 0, 0, 0, 0, 1, 1, 1, 1, 3, 3, 3, 3, 2, 3, 3, 3, 0, 0, 0, 0, 1, 4, 2, 3, 3, 3, 3, 3, 2, 2, 3, 3, 0, 0, 0, 0, 1, 1, 2, 4, 3, 3, 3, 3, 2, 3, 3, 3, 0, 0, 0, 0, 1, 4, 1, 4, 3, 3, 3, 3, 2, 2, 3, 2, 0, 0, 0, 0, 1, 1, 1, 1, 3, 3, 3, 3, 2, 3, 3, 3, 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 3, 2, 2, 3, 3, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 2, 3, 2, 3, 0, 0, 0, 0, 1, 2, 1, 2, 3, 3, 3, 3, 2, 2, 2, 2, 0, 0, 0, 0, 1, 1, 1, 1};

protected:
    static void _bind_methods();

public:
    WORLDCONTAINER();
    ~WORLDCONTAINER();

    Ref<BitMap> bitmap;
    Ref<Image> BGAmbientOcclusionImage;



    void setBGAmbientOcclusionImage(Ref<Image> newImage);
    Ref<Image> getBGAmbientOcclusionImage();

    Ref<Image> BGCutOutImage;
    Ref<Image> BGCutOutEdge;
    void setBGCutOutImage(Ref<Image> newImage, Ref<Image> otherImage);
    Ref<Image> getBGCutOutImage();
    Ref<Image> getBGCutOutEdgeImage();

    BLOCKCONTAINER *blockContainer;
    void setBlockContainer(BLOCKCONTAINER *container);
    
    int worldWidth; // make sure these are always divisable by 8 
    int worldHeight;

    int widthInChunks;
    int heightInChunks;
    
    void initializeArray(int width, int height);

    PackedStringArray getWorldStrings();
    void loadFromStrings(String tileString, String infoString, String bgString);

    void forceAllChunksToDraw();

   
    int convertCoord(int x, int y);
    Vector2i reverseCoordCoversion(int index);

    void setTileData(int x, int y, std::string newTile);
    std::string getTileData(int x, int y);

    void setLightData(int x, int y, float r, float g, float b);
    std::tuple<float, float, float> getLightData(int x, int y);
    void setLightDataTuple(int x, int y, std::tuple<float, float, float> newValue);

    void setInfoData(int x, int y, int newInfo);
    int getInfoData(int x, int y);

    void setBGData(int x, int y, std::string newBG);
    std::string getBGData(int x, int y);

    void createNewChunk(int chunkX, int chunkY);

    void debugWorldGen(int seed);

    Dictionary loadedChunks;
    void chunkLoadArea(int centerChunkX, int centerChunkY, int loadWidth, int loadHeight);
    void unloadChunks(int centerChunkX, int centerChunkY, int loadWidth, int loadHeight);
    Dictionary getLoadedChunks();

    //simulation

    std::unordered_map<int, std::string> blockChangeQueue;
    void addBlockChangeToQueue(int changeX, int changeY, std::string blockID);
    std::unordered_map<int, bool> parseAndApplyQueuedChanges();

    void simulateLoadedChunks(int gameTick);
    void simulateRandomTick(int gameTick, int attemptCount);

    void updateChunks(std::unordered_map<int, bool> changedTiles);

    // simulation one timers

    void breakBlock(int tileX, int tileY);

    void spawnItem(String itemID, int amount, int x, int y);

    // GDScript Access
    
    std::unordered_map<int, std::string> manualBlockQueue;
    void editBlock(int changeX, int changeY, String blockID);
    void editBlockManually(int changeX, int changeY, std::string blockID);
    String getBlock(int x, int y);
    String getBG(int x, int y);

    void applyManualChanges();

    // math

    Vector2i getBorderPos(int x, int y);

    Vector2i getPoopPass(int x, int y);

};

}

#endif
