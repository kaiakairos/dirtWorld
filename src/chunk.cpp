#include "chunk.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;

void CHUNK::_bind_methods() {
}

CHUNK::CHUNK() {
    tileSize = 12; // dont change

    // create sprites
    tileSprite = memnew(Sprite2D);
    tileSprite->set_centered(false);
    add_child(tileSprite);

}

CHUNK::~CHUNK() {
	// Add your cleanup here.
}

// INITIALIZATION //

void CHUNK::setBlockContainer(BLOCKCONTAINER *container){ // Allows the chunk to access block data
    blockContainer = container;
}

void CHUNK::setPosition(int x, int y){ // sets large chunk coordinate
    positionX = x;
    positionY = y;
}

Vector2i CHUNK::getPosition(){ // gets large chunk coordinate
    return Vector2i(positionX,positionY);
}

// DRAWING //

void CHUNK::drawTiles(WORLDCONTAINER *worldContainer){
    Ref<Image> img = Image::create(tileSize * 8, tileSize * 8, false, Image::FORMAT_RGBA8);

    for(int x = 0; x < 8; x++){
        for(int y = 0; y < 8; y++){

            std::pair<int,int> worldCoord = localCoordToWorld(x,y);
            int worldX = worldCoord.first;
            int worldY = worldCoord.second;

            std::string block = worldContainer->getTileData(worldX,worldY);

            Ref<Image> blockImg = blockContainer->getBlockImage(block); // get block texture

            Vector2i imgPos = Vector2i(x * tileSize,y * tileSize);
            img->blend_rect(blockImg, Rect2i(0,0,tileSize,tileSize), imgPos); 
   
        }
    }

    tileSprite->set_texture(ImageTexture::create_from_image(img));

}

// MATH //

std::pair<int, int> CHUNK::localCoordToWorld(int x, int y){
    std::pair<int, int> coord = {(positionX * 8) + x, (positionY * 8) + y};
    return coord;
}
