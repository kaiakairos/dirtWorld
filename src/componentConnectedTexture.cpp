#include "componentConnectedTexture.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;

void COMPONENTCONNECTEDTEXTURE::_bind_methods() {

}

COMPONENTCONNECTEDTEXTURE::COMPONENTCONNECTEDTEXTURE() {


}

COMPONENTCONNECTEDTEXTURE::~COMPONENTCONNECTEDTEXTURE() {
	// Add your cleanup here.
}

Vector2i COMPONENTCONNECTEDTEXTURE::getImageRect(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){

    Vector2i vecPos = Vector2i(0,0);


    int L = container->getBlockIsTransparent( worldContainer->getTileData(x-1,y) );
    int R = container->getBlockIsTransparent( worldContainer->getTileData(x+1,y) );
    int T = container->getBlockIsTransparent( worldContainer->getTileData(x,y-1) );
    int B = container->getBlockIsTransparent( worldContainer->getTileData(x,y+1) );

    int index = L + (R*2) + (T*4) + (B*8); // will give value between 0 and 15. 0 is block is covered, 15 is block is completely free
    vecPos.x = vecFindX[index];
    vecPos.y = vecFindY[index];

    godot::UtilityFunctions::print(index);

   return vecPos;
}
