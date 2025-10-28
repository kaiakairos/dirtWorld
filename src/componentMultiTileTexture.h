#ifndef COMPONENTMULTITILETEXTURE_H
#define COMPONENTMULTITILETEXTURE_H

#include "blockComponent.h"
#include <godot_cpp/variant/string.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER;
class COMPONENTMULTITILETEXTURE : public BLOCKCOMPONENT {
    GDCLASS(COMPONENTMULTITILETEXTURE, BLOCKCOMPONENT)

private:

protected:
    static void _bind_methods();

public:
    COMPONENTMULTITILETEXTURE();
    ~COMPONENTMULTITILETEXTURE();

    std::string id; // used to check if components of type exist

    void onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);

    Vector2i getImageRect(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);

// values
int heightInTiles;

void setHeightInTiles(int newHeightInTiles);

int widthInTiles;

void setWidthInTiles(int newWidthInTiles);

bool shouldBreakItself;

void setShouldBreakItself(int newShouldBreakItself);

};
}
#endif
