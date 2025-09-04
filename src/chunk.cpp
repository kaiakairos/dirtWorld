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

    id4 = 0;

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

    id4 = (x % 2)+((y % 2) * 2 );

    set_position(Vector2i(x * 8 * tileSize,y * 8 * tileSize));
}

Vector2i CHUNK::getPosition(){ // gets large chunk coordinate
    return Vector2i(positionX,positionY);
}

int CHUNK::getID4(){
    return id4;
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

    if(true){ // test disable collision
        clearColliders();
        for( int i = 0; i < polygons.size(); i++ ){
            CollisionPolygon2D *collider;
            collider = memnew(CollisionPolygon2D);

            PackedVector2Array polygonShape = polygons[i];
            collider->set_polygon( polygonShape );

            int sect = sects[i];

            collider->set_position( Vector2i(0,2 * tileSize * sect) );

            staticBody->add_child(collider);
        }
    }


    tileSprite->set_texture(ImageTexture::create_from_image(img));

}

void CHUNK::clearColliders(){
    Array children = staticBody->get_children();
    for( int i = 0; i < children.size(); i++ ){
        //CollisionPolygon2D *shape = children[i];
        CollisionPolygon2D *shape = Object::cast_to<CollisionPolygon2D>( children[i] );
        shape->queue_free();
    }
}

// SIMULATE //
void CHUNK::simulateTick(WORLDCONTAINER *worldContainer){
    
    for(int x = 0; x < 8; x++){
        for(int y = 0; y < 8; y++){

            std::pair<int,int> worldCoord = localCoordToWorld(x,y);
            int worldX = worldCoord.first;
            int worldY = worldCoord.second;

            std::string blockString = worldContainer->getTileData(worldX,worldY);
            Ref<BLOCKOBJECT> blockObj = blockContainer->getObjectFromString(blockString);
            blockObj->simulateTickComponents(worldX,worldY,blockString,blockContainer,worldContainer);


        }
    }

}

void CHUNK::simulateLight(WORLDCONTAINER *worldContainer){
    for(int x = 0; x < 8; x++){
        for(int y = 0; y < 8; y++){
            std::pair<int,int> worldCoord = localCoordToWorld(x,y);
            int worldX = worldCoord.first;
            int worldY = worldCoord.second;

            std::string blockString = worldContainer->getTileData(worldX,worldY);
            Ref<BLOCKOBJECT> blockObj = blockContainer->getObjectFromString(blockString);

            std::tuple<float,float,float> lightEmission = blockObj->lightEmission;
            //std::tuple<float,float,float> currentLight = worldContainer->getLightData(worldX,worldY);

            float r = 0.0;
            float g = 0.0;
            float b = 0.0;

            for(int i = 0; i < 4; i++){

                Vector2i pos = Vector2i( Vector2( 1,0 ).rotated(i * acos(0.0) ));

                std::tuple<float,float,float> thisLight = worldContainer->getLightData(worldX + pos.x,worldY + pos.y);

                r = r + std::get<0>(thisLight);
                g = g + std::get<1>(thisLight);
                b = b + std::get<2>(thisLight);
            }

            r = r/4.0;
            g = g/4.0;
            b = b/4.0;

            float passthrough = blockObj->getLightPassThrough();
            r = r*passthrough;
            g = g*passthrough;
            b = b*passthrough;

            r = std::max(r, std::get<0>(lightEmission));
            g = std::max(g, std::get<1>(lightEmission));
            b = std::max(b, std::get<2>(lightEmission));

            worldContainer->setLightDataTuple(worldX, worldY, std::make_tuple(r,g,b));

        }
    }
}

// MATH //

std::pair<int, int> CHUNK::localCoordToWorld(int x, int y){
    std::pair<int, int> coord = {(positionX * 8) + x, (positionY * 8) + y};
    return coord;
}
