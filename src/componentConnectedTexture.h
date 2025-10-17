#ifndef COMPONENTCONNECTEDTEXTURE_H
#define COMPONENTCONNECTEDTEXTURE_H

#include "blockComponent.h"
#include <godot_cpp/variant/string.hpp>

namespace godot {

class BLOCKCONTAINER;
class WORLDCONTAINER;
class COMPONENTCONNECTEDTEXTURE : public BLOCKCOMPONENT {
    GDCLASS(COMPONENTCONNECTEDTEXTURE, BLOCKCOMPONENT)

private:
                    //  0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    int vecFindX[16] = {1,0,2,3,1,0,2,3,1,0,2, 3, 1, 0, 2, 3 };
    int vecFindY[16] = {1,1,1,1,0,0,0,0,2,2,2, 2, 3, 3, 3, 3 };

protected:
    static void _bind_methods();

public:
    COMPONENTCONNECTEDTEXTURE(); // initialize function
    ~COMPONENTCONNECTEDTEXTURE();

    std::string id; // used to check if components of type exist
    Vector2i getImageRect(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);



};

}

#endif
