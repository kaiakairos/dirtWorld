#include "blockComponent.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void BLOCKCOMPONENT::_bind_methods() {

    ClassDB::bind_method(D_METHOD("setID","newID"), &BLOCKCOMPONENT::setID);
    ClassDB::bind_method(D_METHOD("getID"), &BLOCKCOMPONENT::getID);

    ADD_PROPERTY(PropertyInfo(Variant::STRING, "ID"), "setID", "getID");

}

BLOCKCOMPONENT::BLOCKCOMPONENT() {
	// Initialize any variables here.
}

BLOCKCOMPONENT::~BLOCKCOMPONENT() {
	// Add your cleanup here.
}

void BLOCKCOMPONENT::setID(String newID){

    id = newID;
}

String BLOCKCOMPONENT::getID() {
    return id;
}


