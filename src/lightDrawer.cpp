#include "lightDrawer.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void LIGHTDRAWER::_bind_methods() {
    ClassDB::bind_method(D_METHOD("drawLight","worldContainer","worldX","worldY"), &LIGHTDRAWER::drawLight);
}

LIGHTDRAWER::LIGHTDRAWER() {

}

LIGHTDRAWER::~LIGHTDRAWER() {

}

void LIGHTDRAWER::drawLight(WORLDCONTAINER *worldContainer, int worldX, int worldY){ // x y positions are from top corner
    int rangeX = 64; // how big our light sprite is. should be changeable later based on screen ratio
    int rangeY = 64;
    img = Image::create(rangeX,rangeY, false, Image::FORMAT_RGBA8);

    for(int x = 0; x < rangeX; x++  ){
        for(int y = 0; y < rangeY; y++ ){

            std::tuple<float,float,float> rgb = worldContainer->getLightData(x+worldX,y + worldY);

            float r = std::get<0>(rgb);
            float g = std::get<1>(rgb);
            float b = std::get<2>(rgb);

            img->set_pixel(x,y,Color(r,g,b,1.0)); // set pixel

        }
    }
    set_texture(ImageTexture::create_from_image(img));


}
