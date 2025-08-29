#ifndef BLOCKCOMPONENT_H
#define BLOCKCOMPONENT_H

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {

class BLOCKCOMPONENT : public Resource {
    GDCLASS(BLOCKCOMPONENT, Resource)

private:

protected:
    static void _bind_methods();

public:
    BLOCKCOMPONENT(); // initialize function
    ~BLOCKCOMPONENT();

    String id;

    void setID(String newID);
    String getID();

};

}

#endif