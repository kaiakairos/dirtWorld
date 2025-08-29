#include "blockContainer.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void BLOCKCONTAINER::_bind_methods() {
    ClassDB::bind_method(D_METHOD("addObjectToDictionary","key"), &BLOCKCONTAINER::addObjectToDictionary);
    ClassDB::bind_method(D_METHOD("getObjectFromDictionary","key"), &BLOCKCONTAINER::getObjectFromDictionary);
}

BLOCKCONTAINER::BLOCKCONTAINER() {
}

BLOCKCONTAINER::~BLOCKCONTAINER() {
	// Add your cleanup here.
}

void BLOCKCONTAINER::addObjectToDictionary(String key){
    std::string newkey = key.ascii().get_data();
    Ref<BLOCKOBJECT> poo = memnew(BLOCKOBJECT);
    blockDictionary[newkey] = poo;
}


Ref<BLOCKOBJECT> BLOCKCONTAINER::getObjectFromDictionary(String key){
    std::string newkey = key.ascii().get_data();
    Ref<BLOCKOBJECT> g = blockDictionary[newkey];
    return g;
}

Ref<Image> BLOCKCONTAINER::getBlockImage(std::string blockTag){
    Ref<BLOCKOBJECT> g = blockDictionary[blockTag];
    return g->getTextureImage();
}

Ref<BLOCKOBJECT> BLOCKCONTAINER::getObjectFromString(std::string key){
    Ref<BLOCKOBJECT> g = blockDictionary[key];
    return g;
}