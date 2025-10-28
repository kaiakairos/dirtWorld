#include "blockObject.h"
#include <godot_cpp/core/class_db.hpp>

#include "blockComponent.h"
#include <godot_cpp/variant/utility_functions.hpp>

#include "blockContainer.h"
#include "worldContainer.h"

using namespace godot;

void BLOCKOBJECT::_bind_methods() {
    ClassDB::bind_method(D_METHOD("setTextureImage","newImage"), &BLOCKOBJECT::setTextureImage);
    ClassDB::bind_method(D_METHOD("getTextureImage"), &BLOCKOBJECT::getTextureImage);

    ClassDB::bind_method(D_METHOD("initializeComponentArray","size"), &BLOCKOBJECT::initializeComponentArray);
    ClassDB::bind_method(D_METHOD("addComponent","component","index"), &BLOCKOBJECT::addComponent);

    ClassDB::bind_method(D_METHOD("printComponentArray"), &BLOCKOBJECT::printComponentArray);

    ClassDB::bind_method(D_METHOD("setIsTransparent","isItIdk"), &BLOCKOBJECT::setIsTransparent);
    ClassDB::bind_method(D_METHOD("setLightPassThrough","newValue"), &BLOCKOBJECT::setLightPassThrough);
    ClassDB::bind_method(D_METHOD("setLightEmission","r","g","b"), &BLOCKOBJECT::setLightEmission);

    ClassDB::bind_method(D_METHOD("getImageRectGD","x","y","blockID","container","worldContainer"), &BLOCKOBJECT::getImageRectGD);
}

BLOCKOBJECT::BLOCKOBJECT() {
	// Initialize any variables here.
}

BLOCKOBJECT::~BLOCKOBJECT() {
	// Add your cleanup here.
}

void BLOCKOBJECT::setTextureImage(Ref<Image> newImage){
    textureImage = newImage;
}
Ref<Image> BLOCKOBJECT::getTextureImage(){
    return textureImage;
}

void BLOCKOBJECT::initializeComponentArray(int size){
    //components = new BLOCKCOMPONENT*[size];
    componentCount = size;
}

void BLOCKOBJECT::addComponent(BLOCKCOMPONENT *newComponent,int index){
   // components[index] = newComponent;
   components.append(newComponent);
}

void BLOCKOBJECT::printComponentArray(){ // debug
    for(int i = 0; i < componentCount; i ++){
        godot::UtilityFunctions::print(components[i]);
    }
}

void BLOCKOBJECT::simulateTickComponents(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    for(int i = 0; i < componentCount; i ++){
        Ref<BLOCKCOMPONENT> g = components[i];
        //godot::UtilityFunctions::print(g);
        g->onSimulationTick(x,y,blockID,container,worldContainer);
    }
}

void BLOCKOBJECT::simulateBreakComponents(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    for(int i = 0; i < componentCount; i ++){
        Ref<BLOCKCOMPONENT> g = components[i];
        //godot::UtilityFunctions::print(g);
        g->onBreak(x,y,blockID,container,worldContainer);
    }
}

void BLOCKOBJECT::simulateRandomComponents(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    for(int i = 0; i < componentCount; i ++){
        Ref<BLOCKCOMPONENT> g = components[i];
        //godot::UtilityFunctions::print(g);
        g->onRandomTick(x,y,blockID,container,worldContainer);
    }
}

Vector2i BLOCKOBJECT::getImageRect(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    Vector2i vec = Vector2i(0,0);
    for(int i = 0; i < componentCount; i ++){
        Ref<BLOCKCOMPONENT> g = components[i];
        Vector2i newVec = g->getImageRect(x,y,blockID,container,worldContainer);
        if (newVec != Vector2i(0,0)){
            vec = newVec;
        }
    }
    return vec;
}

Vector2i BLOCKOBJECT::getImageRectGD(int x, int y, String blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer){
    Vector2i vec = Vector2i(0,0);
    std::string newID = blockID.ascii().get_data();
    for(int i = 0; i < componentCount; i ++){
        Ref<BLOCKCOMPONENT> g = components[i];
        Vector2i newVec = g->getImageRect(x,y,newID,container,worldContainer);
        if (newVec != Vector2i(0,0)){
            vec = newVec;
        }
    }
    return vec;
}

///////// LIGHT STUFF //////////////
void BLOCKOBJECT::setIsTransparent(bool yeah){
    isTransparent = yeah;
}

bool BLOCKOBJECT::getIsTransparent(){
    return isTransparent;
}

void BLOCKOBJECT::setLightPassThrough(float newValue){
    lightPassThrough = newValue;
}

float BLOCKOBJECT::getLightPassThrough(){
    return lightPassThrough;
}

void BLOCKOBJECT::setLightEmission(float r, float g, float b){
    lightEmission = std::make_tuple(r,g,b);
}

std::tuple<float,float,float> BLOCKOBJECT::getLightEmission(){
    return lightEmission;
}
