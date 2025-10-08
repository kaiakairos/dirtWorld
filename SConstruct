#!/usr/bin/env python
import os
import sys
from glob import glob

install_path = "dirtworld/bin/"
library_name = "gameContent"

env = SConscript("godot-cpp/SConstruct")

env.Append(CPPPATH=["src/"])
#env.Append(LIBS=["stdc++"])
#env["LINKFLAGS"] = [flag for flag in env.get("LINKFLAGS", []) if flag != "-static-libstdc++"]

env.VariantDir("src/bin/obj", "src", duplicate=0)
sources = Glob("src/*.cpp", strings=True)
sources = ["src/bin/obj/" + os.path.basename(s) for s in sources]

if env["platform"] == "macos":
    library = env.SharedLibrary(
        "{}{}.{}.{}.framework/{}.{}.{}".format( install_path, library_name, ["platform"], env["target"], library_name, env["platform"], env["target"] ),
        source=sources,
    )
else:
    library = env.SharedLibrary(
        "{}{}{}{}".format(install_path, library_name, env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
