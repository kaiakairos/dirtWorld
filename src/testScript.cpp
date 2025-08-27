#include "testScript.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TestScript::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_strength"), &TestScript::get_strength);
    ClassDB::bind_method(D_METHOD("set_strength", "new_strength"), &TestScript::set_strength); // adds methods to our object

    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "strength"), "set_strength", "get_strength"); // adds export values to our function

    ADD_SIGNAL(MethodInfo("position_changed", PropertyInfo(Variant::OBJECT, "node"), PropertyInfo(Variant::VECTOR2, "new_pos"))); // creates a signal for us
}

TestScript::TestScript() {
	// Initialize any variables here.
	timeTicks = 0.0;
    strength = 1.0;
    time_emit = 0.0;
}

TestScript::~TestScript() {
	// Add your cleanup here.
}

void TestScript::_process(double delta) {
	timeTicks += delta;

	Vector2 new_position = Vector2(strength + (strength * sin(timeTicks * 2.0)), strength + (strength * cos(timeTicks * 1.5)));

	set_position(new_position);

    time_emit += delta;
    if (time_emit > 1.0){

        emit_signal("position_changed", this, new_position);

        time_emit = 0.0;
    }

}

void TestScript::set_strength(double new_strength){

    strength = new_strength;
}

double TestScript::get_strength() {
    return strength;
}