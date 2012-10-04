#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="vmmlib"
pkg_vers="trunk"
pkg_info="vmmlib is a templatized C++ vector and matrix math library."

pkg_desc="vmmlib is a templatized C++ vector and matrix math library. 

Its basic functionality includes a vector and a matrix class, with additional functionality 
for the often-used 3d and 4d vectors and 3x3 and 4x4 matrices.

More advanced functionality include solvers, frustum computations and frustum culling classes, 
and spatial data structures.

It is implemented using C++ templates, making it versatile, and being a header library, it 
is very easy to integrate into other ( your ) libraries and programs. There is no need to 
build and install a library, just include the headers and you’re set.

The BSD license allows the usage both in open source and commercial closed source software."

pkg_opts="cmake skip-boot skip-boot skip-config skip-compile skip-install migrate-build-headers"
pkg_reqs="tar"
pkg_uses="$pkg_reqs"
pkg_cfg=""
pkg_patch=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
     pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.bz2"
     pkg_urls="git://github.com/VMML/vmmlib.git"

     bldr_register_pkg                 \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
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
done

####################################################################################################
