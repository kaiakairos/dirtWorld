#ifndef COMPONENTSPAWNBLOCKENTITY_H
#define COMPONENTSPAWNBLOCKENTITY_H

#include "blockComponent.h"
#include <godot_cpp/variant/string.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER;
class COMPONENTSPAWNBLOCKENTITY : public BLOCKCOMPONENT {
    GDCLASS(COMPONENTSPAWNBLOCKENTITY, BLOCKCOMPONENT)

private:

protected:
    static void _bind_methods();

public:
    COMPONENTSPAWNBLOCKENTITY();
    ~COMPONENTSPAWNBLOCKENTITY();

    std::string id; // used to check if components of type exist

    void onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onLoaded(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);


// values
std::string blockEntityID;
String poop;

void setBlockEntityId(String newBlockEntityId);

int requiredInfo;

void setRequiredInfo(int newRequiredInfo);



};
}
#endif
