#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="atb"

pkg_default="1.1.5"
pkg_variants=("1.1.5")
pkg_distribs=("AntTweakBar_115.zip")

pkg_info="AntTweakBar is a small and easy-to-use C/C++ library for parameter adjusting GUI interfaces."

pkg_desc="AntTweakBar is a small and easy-to-use C/C++ library that allows programmers to 
quickly add a light and intuitive graphical user interface into graphic applications based 
on OpenGL (compatibility and core profiles), DirectX 9, DirectX 10 or DirectX 11 to 
interactively tweak parameters on-screen.

C/C++ variables can be bound to graphical controls that allow users to modify them. Thus, 
variables exposed by programmers can be easily modified. They are displayed into the graphical 
application through one or more embedded windows called tweak bars.

The AntTweakBar library mainly targets graphical applications that need a quick way to tune 
parameters (even in fullscreen mode) and see the result in real-time like 3D demos, games, 
prototypes, inline editors, debug facilities of weightier graphical applications, etc."

pkg_opts="configure "
pkg_opts+="migrate-build-headers "
pkg_opts+="migrate-build-source "
pkg_opts+="migrate-build-bin "
pkg_opts+="use-base-dir=AntTweakBar "
pkg_opts+="use-build-tree=AntTweakBar "

pkg_uses=""
pkg_reqs=""

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
  pkg_opts+="use-build-makefile=Makefile.osx "
else
  pkg_opts+="use-build-makefile=Makefile "
  pkg_uses="freeglut"
fi

pkg_reqs="$pkg_uses"
pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg_path="AntTweakBar/src"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
     pkg_file=${pkg_distribs[$pkg_idx]}
     pkg_urls="http://www.antisphere.com/Tools/AntTweakBar/$pkg_file"

     bldr_register_pkg                \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_default"\
         --info        "$pkg_info"    \
         --description "$pkg_desc"    \
         --file        "$pkg_file"    \
         --url         "$pkg_urls"    \
         --uses        "$pkg_uses"    \
         --requires    "$pkg_reqs"    \
         --options     "$pkg_opts"    \
         --cflags      "$pkg_cflags"  \
         --ldflags     "$pkg_ldflags" \
         --config      "$pkg_cfg"     \
         --config-path "$pkg_cfg_path"

    let pkg_idx++
done

####################################################################################################



