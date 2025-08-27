#ifndef BLOCKCONTAINER_H
#define BLOCKCONTAINER_H

#include <godot_cpp/classes/node.hpp>
#include "blockObject.h"
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/typed_dictionary.hpp>
namespace godot {

class BLOCKCONTAINER : public Node {
    GDCLASS(BLOCKCONTAINER, Node)

private:

protected:
    static void _bind_methods();

public:
    BLOCKCONTAINER();
    ~BLOCKCONTAINER();

    std::unordered_map<std::string, Ref<BLOCKOBJECT>> blockDictionary;

    //Dictionary blockDictionary;

    void addObjectToDictionary(String key); // for interacting with gdscript
    Ref<BLOCKOBJECT> getObjectFromDictionary(String key);

    // the rest will take std::strings and are meant to be used exclusively inside c++

    Ref<Image> getBlockImage(std::string blockTag);


};

}

#endif