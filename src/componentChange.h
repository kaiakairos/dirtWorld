#ifndef COMPONENTCHANGE_H
#define COMPONENTCHANGE_H

#include "blockComponent.h"
#include <godot_cpp/variant/string.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER;
class COMPONENTCHANGE : public BLOCKCOMPONENT {
    GDCLASS(COMPONENTCHANGE, BLOCKCOMPONENT)

private:

protected:
    static void _bind_methods();

public:
    COMPONENTCHANGE(); // initialize function
    ~COMPONENTCHANGE();

    std::string id; // used to check if components of type exist

    void onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);

    //component specifics
    std::string blockToChangeInto;
    String hold;
    int chance;

    void setChance(int newChance);
    int getChance();

    void setBlockToChangeInto(String newBlock);
    String getBlockToChangeInto();

};

}

#endif