#include "blockObject.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void BLOCKOBJECT::_bind_methods() {
    ClassDB::bind_method(D_METHOD("setTextureImage","newImage"), &BLOCKOBJECT::setTextureImage);
    ClassDB::bind_method(D_METHOD("getTextureImage"), &BLOCKOBJECT::getTextureImage);

    ClassDB::bind_method(D_METHOD("setRandomInt","newInt"), &BLOCKOBJECT::setRandomInt);
    ClassDB::bind_method(D_METHOD("getRandomInt"), &BLOCKOBJECT::getRandomInt);
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

void BLOCKOBJECT::setRandomInt(int newInt){
    randomInt = newInt;
}
int BLOCKOBJECT::getRandomInt(){
    return randomInt;
}
