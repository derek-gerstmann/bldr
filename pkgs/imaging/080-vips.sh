#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="vips"
pkg_vers="7.30.0"

pkg_info="VIPS is an image processing library for large images."

pkg_desc="VIPS is a free image processing system. It is good with large images 
(images larger than the amount of RAM you have available), with many CPUs 
(see Benchmarks for examples of SMP scaling, VIPS is also part of the PARSEC suite), 
for working with colour, for scientific analysis and for general research & 
development. As well as JPEG, TIFF and PNG images, it also supports scientific 
formats like FITS, Matlab, Analyze, PFM, Radiance and OpenSlide."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.vips.ecs.soton.ac.uk/supported/current/$pkg_file"
pkg_opts="configure"
pkg_reqs=""
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs libtiff/latest"
pkg_reqs="$pkg_reqs libpng/latest"
pkg_reqs="$pkg_reqs libjpeg/latest"
pkg_reqs="$pkg_reqs openexr/latest"
pkg_reqs="$pkg_reqs lcms2/latest"
pkg_reqs="$pkg_reqs cfitsio/latest"
pkg_reqs="$pkg_reqs swig/latest"
pkg_reqs="$pkg_reqs fftw/latest"
pkg_reqs="$pkg_reqs orc/latest"
pkg_reqs="$pkg_reqs gettext/latest"
pkg_reqs="$pkg_reqs glib/latest"
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

pkg_cflags=""
pkg_ldflags=""

####################################################################################################

pkg_cfg=""

pkg_cfg="$pkg_cfg --with-tiff-includes=\"$BLDR_LIBTIFF_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg --with-tiff-libraries=\"$BLDR_LIBTIFF_LIB_PATH/libtiff.a\""

pkg_cfg="$pkg_cfg --with-jpeg-includes=\"$BLDR_LIBJPEG_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg --with-jpeg-libraries=\"$BLDR_LIBJPEG_LIB_PATH/libjpeg.a\""

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

####################################################################################################

