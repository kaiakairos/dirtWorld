#ifndef COMPONENTRANDOMIZEDTEXTURE_H
#define COMPONENTRANDOMIZEDTEXTURE_H

#include "blockComponent.h"
#include <godot_cpp/variant/string.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER;
class COMPONENTRANDOMIZEDTEXTURE : public BLOCKCOMPONENT {
    GDCLASS(COMPONENTRANDOMIZEDTEXTURE, BLOCKCOMPONENT)

private:

protected:
    static void _bind_methods();

public:
    COMPONENTRANDOMIZEDTEXTURE();
    ~COMPONENTRANDOMIZEDTEXTURE();

    std::string id; // used to check if components of type exist

    void onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    Vector2i getImageRect(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);

// values
int range;
int gap;

void setRange(int newRange);
void setGap(int newGap);



};
}
#endif
