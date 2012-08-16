#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="gd"
pkg_vers="2.0.33"

pkg_info="A graphics library for fast image creation"

pkg_desc="GD is a graphics library. It allows your code to quickly draw images complete with 
lines, arcs, text, multiple colors, cut and paste from other images, and flood fills, and 
write out the result as a PNG or JPEG file. This is particularly useful in World Wide Web 
applications, where PNG and JPEG are two of the formats accepted for inline images by most browsers.

gd is not a paint program. If you are looking for a paint program, you are looking in the 
wrong place. If you are not a programmer, you are looking in the wrong place, unless 
you are installing a required library in order to run an application.

gd does not provide for every possible desirable graphics operation. It is not necessary 
or desirable for gd to become a kitchen-sink graphics package, but version 2.0 does include 
most frequently requested features, including both truecolor and palette images, resampling 
(smooth resizing of truecolor images) and so forth."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="https://bitbucket.org/pierrejoye/gd-libgd/get/5551f61978e3.tar.bz2"
pkg_opts="configure"
pkg_reqs="zlib/latest libpng/latest freetype/latest xpm/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################

pkg_cfg="--enable-shared --enable-static"
pkg_cfg="$pkg_cfd --with-png=\"$BLDR_LIBPNG_BASE_DIR\""
pkg_cfg="$pkg_cfd --with-jpeg=\"$BLDR_LIBJPEG_BASE_DIR\""
pkg_cfg="$pkg_cfd --with-freetype=\"$BLDR_FREETYPE_BASE_DIR\""
pkg_cfg="$pkg_cfd --with-xpm=\"$BLDR_XPM_BASE_DIR\""

pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                    \
     --category    "$pkg_ctry"    \
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

