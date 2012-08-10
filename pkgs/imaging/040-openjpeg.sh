#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="openjpeg"
pkg_vers="1.5.0"

pkg_info="The OpenJPEG library is an open-source JPEG 2000 library developed in order to promote the use of JPEG 2000."

pkg_desc="The OpenJPEG library is an open-source JPEG 2000 library developed in order to promote the use of JPEG 2000. 

The main part of the project consists in a JPEG 2000 codec compliant with the 
Part 1 of the standard (Class-1 Profile-1 compliance). 

The OpenJPEG library is written in C language, released under the BSD license and targets Win32, 
Unix and Mac OS platforms.  The library is developed by the Communications and Remote Sensing 
Lab (TELE) of the Université catholique de Louvain (UCL), with the support of the CS company, 
the CNES and the intoPIX company.  The JPWL and OPJViewer modules are developed and maintained 
by the Digital Signal Processing Lab (DSPLab) of the University of Perugia (UNIPG).

Thanks to the constant contributions of many developers from the open source community, 
OpenJPEG has gained throughout the years in flexibility and performance. It is integrated 
in many open source applications, such as Second Life and Gimp."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://openjpeg.googlecode.com/files/$pkg_file"
pkg_opts="configure force-bootstrap"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""

dep_list="compression/zlib internal/bzip2 developer/libxml2"
dep_list="$dep_list imaging/lcms2 imaging/libpng imaging/libjpeg imaging/libtiff"
for dep_pkg in $dep_list
do
     pkg_req_name=$(echo "$dep_pkg" | sed 's/.*\///g' )
     pkg_reqs="$pkg_reqs $pkg_req_name/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/$dep_pkg/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/$dep_pkg/latest/lib"
done

pkg_uses="$pkg_reqs"

pkg_cfg="--disable-dependency-tracking"
pkg_cfg="$pkg_cfg --enable-tiff"
pkg_cfg="$pkg_cfg --enable-mj2"
pkg_cfg="$pkg_cfg --enable-jpwl"
pkg_cfg="$pkg_cfg --enable-jpip"
pkg_cfg="$pkg_cfg --enable-jpip-server"
pkg_cfg="$pkg_cfg Z_CFLAGS=-I$BLDR_LOCAL_PATH/compression/zlib/latest/include"
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


