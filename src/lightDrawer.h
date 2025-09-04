#ifndef LIGHTDRAWER_H
#define LIGHTDRAWER_H

#include <godot_cpp/classes/sprite2d.hpp>
#include "worldContainer.h"
#include <godot_cpp/classes/image.hpp>
#include <godot_cpp/variant/color.hpp>
#include <godot_cpp/classes/image_texture.hpp>

namespace godot {

class LIGHTDRAWER : public Sprite2D {
    GDCLASS(LIGHTDRAWER, Sprite2D)

private:
    Ref<Image> img;

protected:
    static void _bind_methods();

public:
    LIGHTDRAWER();
    ~LIGHTDRAWER();

    void drawLight(WORLDCONTAINER *worldContainer, int worldX, int worldY);


};

}

#endif
