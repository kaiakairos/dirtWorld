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
        g->onSimulationTick(x,y,blockID,container,worldContainer); // calling this causes crash
    }
}