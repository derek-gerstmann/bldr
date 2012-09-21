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
pkg_base="OpenImageIO-oiio-187bb9b"
pkg_opts="cmake force-bootstrap use-base-dir=$pkg_base"
pkg_cfg_path="$pkg_base/src"
pkg_reqs=""
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs bzip2/latest"
pkg_reqs="$pkg_reqs libxml2/latest"
pkg_reqs="$pkg_reqs szip/latest"
pkg_reqs="$pkg_reqs hdf5/latest"
pkg_reqs="$pkg_reqs boost/latest"
pkg_reqs="$pkg_reqs glew/latest"
pkg_reqs="$pkg_reqs lcms2/latest"
pkg_reqs="$pkg_reqs ilmbase/latest"
pkg_reqs="$pkg_reqs openexr/latest"
pkg_reqs="$pkg_reqs libpng/latest"
pkg_reqs="$pkg_reqs libjpeg/latest"
pkg_reqs="$pkg_reqs libtiff/latest"
pkg_reqs="$pkg_reqs field3d/latest"
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

pkg_cfg="$pkg_cfg --disable-dependency-tracking --enable-tiff "
pkg_cfg="$pkg_cfg LINKSTATIC=ON"
pkg_cfg="$pkg_cfg Z_CFLAGS=-I$BLDR_ZLIB_INCLUDE_PATH"
pkg_cfg="$pkg_cfg Z_LIBS=-lz"
pkg_cfg="$pkg_cfg PNG_CFLAGS=-I$BLDR_LIBPNG_INCLUDE_PATH"
pkg_cfg="$pkg_cfg PNG_LIBS=-lpng"
pkg_cfg="$pkg_cfg TIFF_CFLAGS=-I$BLDR_LIBTIFF_INCLUDE_PATH"
pkg_cfg="$pkg_cfg TIFF_LIBS=-ltiff"

pkg_cfg="$pkg_cfg -DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg -DIlmbase_Base_Dir=\"$BLDR_ILMBASE_BASE_PATH\""
pkg_cfg="$pkg_cfg -DILMBASE_INCLUDE_DIR=\"$BLDR_ILMBASE_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -DILMBASE_HALF_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libHalf.a\""
pkg_cfg="$pkg_cfg -DILMBASE_IEX_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libIex.a\""
pkg_cfg="$pkg_cfg -DILMBASE_IMATH_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libImath.a\""
pkg_cfg="$pkg_cfg -DILMBASE_ILMTHREAD_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libIlmThread.a\""

pkg_cfg="$pkg_cfg -DOpenEXR_Base_Dir=\"$BLDR_OPENEXR_BASE_PATH\""
pkg_cfg="$pkg_cfg -DOPENEXR_INCLUDE_DIR=\"$BLDR_OPENEXR_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -DOPENEXR_ILMIMF_LIBRARIES=\"$BLDR_OPENEXR_LIB_PATH/libIlmImf.a\""

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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_path"
