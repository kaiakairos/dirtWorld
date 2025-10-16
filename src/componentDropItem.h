#ifndef COMPONENTDROPITEM_H
#define COMPONENTDROPITEM_H

#include "blockComponent.h"
#include <godot_cpp/variant/string.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER;
class COMPONENTDROPITEM : public BLOCKCOMPONENT {
    GDCLASS(COMPONENTDROPITEM, BLOCKCOMPONENT)

private:

protected:
    static void _bind_methods();

public:
    COMPONENTDROPITEM(); // initialize function
    ~COMPONENTDROPITEM();

    std::string id; // used to check if components of type exist

    void onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    void onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);

    //component specifics
    String itemID;
    int amountMin;
    int amountMax;

    void setAmountMin(int newAmountMin);

    void setAmountMax(int newAmountMax);

    void setItemID(String newID);

};

}

#endif
