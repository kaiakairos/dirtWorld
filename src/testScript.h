#ifndef TESTSCRIPT_H
#define TESTSCRIPT_H

#include <godot_cpp/classes/sprite2d.hpp>

namespace godot {

class TestScript : public Sprite2D {
    GDCLASS(TestScript, Sprite2D)

private:
    double timeTicks;
    double strength;

    double time_emit;

protected:
    static void _bind_methods();

public:
    TestScript();
    ~TestScript();

    void _process(double delta) override;

    void set_strength(double new_strength);
	double get_strength();

};

}

#endif