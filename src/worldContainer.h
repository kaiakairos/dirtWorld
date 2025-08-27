#ifndef WORLDCONTAINER_H
#define WORLDCONTAINER_H

#include <godot_cpp/classes/node.hpp>
#include <algorithm>
#include <memory>
#include <godot_cpp/variant/utility_functions.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER : public Node {
    GDCLASS(WORLDCONTAINER, Node)

private:
    std::string *tileData;


protected:
    static void _bind_methods();

public:
    WORLDCONTAINER();
    ~WORLDCONTAINER();
    
    BLOCKCONTAINER *blockContainer;
    void setBlockContainer(BLOCKCONTAINER *container);
    
    int worldWidth; // make sure these are always divisable by 8 
    int worldHeight;
    
    void initializeArray(int width, int height);
   
    int convertCoord(int x, int y);

    void setTileData(int x, int y, std::string newTile);
    std::string getTileData(int x, int y);

    void createNewChunk(int chunkX, int chunkY);

    void debugWorldGen();

};

}

#endif