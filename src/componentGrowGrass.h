#ifndef COMPONENTGROWGRASS_H
#define COMPONENTGROWGRASS_H

#include "blockComponent.h"
#include <godot_cpp/variant/string.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER;
class COMPONENTGROWGRASS : public BLOCKCOMPONENT {
    GDCLASS(COMPONENTGROWGRASS, BLOCKCOMPONENT)

private:

protected:
    static void _bind_methods();

public:
    COMPONENTGROWGRASS();
    ~COMPONENTGROWGRASS();

    std::string id; // used to check if components of type exist

    void onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);


    int vecFindX[8] = {1, 1, 0,-1,-1, -1, 0, 1};
    int vecFindY[8] = {0, 1, 1, 1, 0, -1,-1,-1};

// values
std::string blockToGrowOn;

void setBlockToGrowOn(String newBlockToGrowOn);

int spreadchance;

void setSpreadchance(int newSpreadchance);

bool needsAir;

void setNeedsAir(bool newNeedsAir);


};
}
#endif
