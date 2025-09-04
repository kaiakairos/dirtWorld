#ifndef BLOCKOBJECT_H
#define BLOCKOBJECT_H

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/classes/image.hpp>


namespace godot {

class BLOCKCONTAINER;
class BLOCKCOMPONENT;
class WORLDCONTAINER;
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
    

    Array components;
    int componentCount;
    void initializeComponentArray(int size);
    void addComponent(BLOCKCOMPONENT *newComponent,int index);

    void setTextureImage(Ref<Image> newImage);
    Ref<Image> getTextureImage();


    void printComponentArray();

    // component sim
    void simulateTickComponents(int x, int y, std::string blockID, BLOCKCONTAINER *container, WORLDCONTAINER *worldContainer);

    // light stuff
    bool isTransparent;
    void setIsTransparent(bool yeah);
    bool getIsTransparent();

    float lightPassThrough;
    void setLightPassThrough(float newValue);
    float getLightPassThrough();

    std::tuple<float,float,float> lightEmission;
    void setLightEmission(float r, float g, float b);
    std::tuple<float,float,float> getLightEmission();

};

}

#endif
