#ifndef CHUNK_H
#define CHUNK_H

#include <godot_cpp/classes/node2d.hpp>
#include "blockObject.h"
#include <godot_cpp/classes/sprite2d.hpp>
#include <utility>
#include <godot_cpp/classes/image.hpp>
#include <godot_cpp/variant/rect2i.hpp>
#include <godot_cpp/variant/vector2i.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER;
class CHUNK : public Node2D {
    GDCLASS(CHUNK, Node2D)

private:
    int tileSize;

protected:
    static void _bind_methods();

public:
    CHUNK();
    ~CHUNK();

    BLOCKCONTAINER *blockContainer;
    void setBlockContainer(BLOCKCONTAINER *container);

    int positionX; // chunks BIG position
    int positionY;
    void setPosition(int x, int y);
    
    std::pair<int, int> localCoordToWorld(int x, int y);

    void drawTiles(WORLDCONTAINER *worldContainer);

};

}

#endif