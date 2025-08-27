#ifndef BLOCKOBJECT_H
#define BLOCKOBJECT_H

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/classes/image.hpp>

namespace godot {

class BLOCKOBJECT : public Resource {
    GDCLASS(BLOCKOBJECT, Resource)

private:

protected:
    static void _bind_methods();

public:
    BLOCKOBJECT(); // initialize function
    ~BLOCKOBJECT();

    // define block specific variables in here
    Ref<Image> textureImage;
    int randomInt;

    void setTextureImage(Ref<Image> newImage);
    Ref<Image> getTextureImage();

    void setRandomInt(int newInt); // for testing
    int getRandomInt();

};

}

#endif