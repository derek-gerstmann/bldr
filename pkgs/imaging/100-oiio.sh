#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="oiio"
pkg_vers="1.0.8"

pkg_info="OpenImageIO is a library for reading and writing images, and a bunch of related classes, utilities, and applications."

pkg_desc="OpenImageIO is a library for reading and writing images, and a bunch of related classes, utilities, and applications. 
There is a particular emphasis on formats and functionality used in professional, large-scale animation and visual effects 
work for film.  OpenImageIO is used extensively in animation and VFX studios all over the world, 
and is also incorporated into several commercial products."

pkg_file="$pkg_name-$pkg_vers.zip"
pkg_urls="http://nodeload.github.com/OpenImageIO/oiio/zipball/RB-1.0"
pkg_opts="cmake force-bootstrap"
pkg_reqs="zlib/latest libpng/latest libjpeg/latest libtiff/latest openjpeg/latest hdf5/latest f3d/latest lcms2/latest"
pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list="internal/zlib internal/bzip2 internal/libxml2"
dep_list="$dep_list imaging/lcms2 imaging/libpng imaging/libjpeg imaging/libtiff imaging/openjpeg"
dep_list="$dep_list storage/hdf5 storage/netcdf storage/f3d"
for dep_pkg in $dep_list
do
     pkg_reqs="$pkg_reqs $dep_pkg/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

pkg_uses="$pkg_reqs"

pkg_cfg="--disable-dependency-tracking --enable-tiff "
pkg_cfg="$pkg_cfg Z_CFLAGS=-I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_cfg="$pkg_cfg Z_LIBS=-lz"
pkg_cfg="$pkg_cfg PNG_CFLAGS=-I$BLDR_LOCAL_PATH/imaging/libpng/latest/include"
pkg_cfg="$pkg_cfg PNG_LIBS=-lpng"
pkg_cfg="$pkg_cfg TIFF_CFLAGS=-I$BLDR_LOCAL_PATH/imaging/libtiff/latest/include"
pkg_cfg="$pkg_cfg TIFF_LIBS=-ltiff"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "$pkg_ctry"    \
               --name        "$pkg_name"    \
               --version     "$pkg_vers"    \
               --info        "$pkg_info"    \
               --description "$pkg_desc"    \
               --file        "$pkg_file"    \
               --url         "$pkg_urls"    \
               --uses        "$pkg_uses"    \
               --requires    "$pkg_reqs"    \
               --options     "$pkg_opts"    \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"
