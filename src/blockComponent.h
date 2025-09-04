#ifndef BLOCKCOMPONENT_H
#define BLOCKCOMPONENT_H

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER;
class BLOCKCOMPONENT : public Resource {
    GDCLASS(BLOCKCOMPONENT, Resource)

private:

protected:
    static void _bind_methods();

public:
    BLOCKCOMPONENT(); // initialize function
    ~BLOCKCOMPONENT();

    std::string id; // used to check if components of type exist

    // simulation functions

    virtual void onSimulationTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    virtual void onRandomTick(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    virtual void onBreak(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    virtual void onPlace(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);
    virtual void onBlockUpdate(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);

    // blah blah


};

}

#endif
