#include "chunk.h"
#include <godot_cpp/core/class_db.hpp>

#include "worldContainer.h"
#include "blockContainer.h"

using namespace godot;

void CHUNK::_bind_methods() {
}

CHUNK::CHUNK() {
    tileSize = 8; // dont change

    // create sprites
    tileSprite = memnew(Sprite2D);
    tileSprite->set_centered(false);
    add_child(tileSprite);

    
    staticBody = memnew(StaticBody2D);
    add_child(staticBody);

}

CHUNK::~CHUNK() {
	//godot::UtilityFunctions::print("hey!");
    //tileSprite->queue_free();
    //staticBody->queue_free();
}

// INITIALIZATION //

void CHUNK::setBlockContainer(BLOCKCONTAINER *container){ // Allows the chunk to access block data
    blockContainer = container;
}

void CHUNK::setPosition(int x, int y){ // sets large chunk coordinate
    positionX = x;
    positionY = y;
    set_position(Vector2i(x * 8 * tileSize,y * 8 * tileSize));
}

Vector2i CHUNK::getPosition(){ // gets large chunk coordinate
    return Vector2i(positionX,positionY);
}

// DRAWING //

void CHUNK::drawTiles(WORLDCONTAINER *worldContainer, Ref<BitMap> bitmap){
    Ref<Image> img = Image::create(tileSize * 8, tileSize * 8, false, Image::FORMAT_RGBA8);

    Ref<Image> colliderImg = Image::create(tileSize * 8, tileSize * 8, false, Image::FORMAT_RGBA8);
    colliderImg->fill(Color::hex(0x00000000));

    for(int x = 0; x < 8; x++){
        for(int y = 0; y < 8; y++){

            std::pair<int,int> worldCoord = localCoordToWorld(x,y);
            int worldX = worldCoord.first;
            int worldY = worldCoord.second;

            std::string block = worldContainer->getTileData(worldX,worldY);

            Ref<Image> blockImg = blockContainer->getBlockImage(block); // get block texture

            Vector2i imgPos = Vector2i(x * tileSize,y * tileSize);
            img->blend_rect(blockImg, Rect2i(0,0,tileSize,tileSize), imgPos);

            // debug collisions, remove later
            if( block != "air" ) {
                colliderImg->fill_rect(Rect2i(x * tileSize,y * tileSize,tileSize,tileSize),Color::hex(0xFFFFFFFF));
            }
        }
    }

    // create colliders

    Array polygons;
    Array sects; // gets ints of how many polygons are in a single area, for shifting positions

    for(int i = 0; i < 4; i++){
        Ref<Image> newCollider = Image::create(tileSize * 8, tileSize * 2, false, Image::FORMAT_RGBA8);
        newCollider->blit_rect(colliderImg,Rect2i(0,tileSize * 2 * i,tileSize * 8, tileSize * 2),Vector2i(0,0));

        bitmap->create_from_image_alpha(newCollider, 0.5);
        Array newPolygons = bitmap->opaque_to_polygons( Rect2(Vector2(0 , 0), Vector2(tileSize * 8, tileSize * 2) ) , 1.0);
        polygons.append_array( newPolygons );
        
        for(int g = 0; g < newPolygons.size(); g++){
            sects.append(i); // probably better way of doing this? saves what sect each polygon is in
        }
        
    }

    for( int i = 0; i < polygons.size(); i++ ){


        CollisionPolygon2D *collider;
        collider = memnew(CollisionPolygon2D);

        PackedVector2Array polygonShape = polygons[i];
        collider->set_polygon( polygonShape );

        int sect = sects[i];

        collider->set_position( Vector2i(0,2 * tileSize * sect) );

        staticBody->add_child(collider);


    }



    tileSprite->set_texture(ImageTexture::create_from_image(img));

}

// MATH //

std::pair<int, int> CHUNK::localCoordToWorld(int x, int y){
    std::pair<int, int> coord = {(positionX * 8) + x, (positionY * 8) + y};
    return coord;
}
