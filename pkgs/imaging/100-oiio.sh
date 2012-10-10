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

pkg_default="1.0.8"
pkg_variants=("1.0.8")
pkg_mirrors=("http://nodeload.github.com/OpenImageIO/oiio/zipball/RB-1.0")
pkg_bases=("OpenImageIO-oiio-187bb9b")

pkg_info="OpenImageIO is a library for reading and writing images, and a bunch of related classes, utilities, and applications."

pkg_desc="OpenImageIO is a library for reading and writing images, and a bunch of related classes, utilities, and applications. 
There is a particular emphasis on formats and functionality used in professional, large-scale animation and visual effects 
work for film.  OpenImageIO is used extensively in animation and VFX studios all over the world, 
and is also incorporated into several commercial products."

pkg_reqs="zlib "
pkg_reqs+="bzip2 "
pkg_reqs+="libxml2 "
pkg_reqs+="szip "
pkg_reqs+="hdf5 "
pkg_reqs+="boost "
pkg_reqs+="glew "
pkg_reqs+="lcms2 "
pkg_reqs+="ilmbase "
pkg_reqs+="openexr "
pkg_reqs+="openjpeg "
pkg_reqs+="libpng "
pkg_reqs+="libjpeg "
pkg_reqs+="libtiff "
pkg_reqs+="field3d "
pkg_reqs+="python "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

# pkg_cfg="--disable-dependency-tracking "
# pkg_cfg+="--enable-tiff "
pkg_cfg+="LINKSTATIC=ON "
pkg_cfg+="BUILDSTATIC=ON "
pkg_cfg+="Z_CFLAGS=-I$BLDR_ZLIB_INCLUDE_PATH "
pkg_cfg+="Z_LIBS=-lz "
pkg_cfg+="PNG_CFLAGS=-I$BLDR_LIBPNG_INCLUDE_PATH "
pkg_cfg+="PNG_LIBS=-lpng "
pkg_cfg+="TIFF_CFLAGS=-I$BLDR_LIBTIFF_INCLUDE_PATH "
pkg_cfg+="TIFF_LIBS=-ltiff "

boost_list="$BLDR_BOOST_LIB_PATH/libboost_system.a "
boost_list+="$BLDR_BOOST_LIB_PATH/libboost_regex.a "
boost_list+="$BLDR_BOOST_LIB_PATH/libboost_thread.a "
boost_list+="$BLDR_BOOST_LIB_PATH/libboost_program_options.a"

ilm_list="-L$BLDR_ILMBASE_LIB_PATH "
ilm_list+="$BLDR_ILMBASE_LIB_PATH/libHalf.a "
ilm_list+="$BLDR_ILMBASE_LIB_PATH/libIex.a "
ilm_list+="$BLDR_ILMBASE_LIB_PATH/libImath.a "
ilm_list+="$BLDR_ILMBASE_LIB_PATH/libIlmThread.a"

exr_list="-L$BLDR_OPENEXR_LIB_PATH "
exr_list+="$BLDR_OPENEXR_LIB_PATH/libIlmImf.a"
cm_ldflags="$boost_list $ilm_list $exr_list"

pkg_cfg=""
# -DBUILDSTATIC=ON:-DLINKSTATIC=ON"
pkg_cfg+=":-DCMAKE_MODULE_LINKER_FLAGS=\"$cm_ldflags\""
pkg_cfg+=":-DCMAKE_EXE_LINKER_FLAGS=\"$cm_ldflags\""
pkg_cfg+=":-DIlmbase_Base_Dir=\"$BLDR_ILMBASE_BASE_PATH\""
pkg_cfg+=":-DILMBASE_INCLUDE_DIR=\"$BLDR_ILMBASE_INCLUDE_PATH\""
pkg_cfg+=":-DILMBASE_HALF_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libHalf.a\""
pkg_cfg+=":-DILMBASE_IEX_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libIex.a\""
pkg_cfg+=":-DILMBASE_IMATH_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libImath.a\""
pkg_cfg+=":-DILMBASE_ILMTHREAD_LIBRARIES=\"$BLDR_ILMBASE_LIB_PATH/libIlmThread.a\""
pkg_cfg+=":-DOpenEXR_Base_Dir=\"$BLDR_OPENEXR_BASE_PATH\""
pkg_cfg+=":-DOPENEXR_INCLUDE_DIR=\"$BLDR_OPENEXR_INCLUDE_PATH\""
pkg_cfg+=":-DOPENEXR_ILMIMF_LIBRARIES=\"$BLDR_OPENEXR_LIB_PATH/libIlmImf.a\""

pkg_cfg+=":-DBoost_NO_SYSTEM_PATHS=ON"
pkg_cfg+=":-DBoost_NO_BOOST_CMAKE=ON"
pkg_cfg+=":-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg+=":-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\""
pkg_cfg+=":-DBOOST_ROOT=\"$BLDR_BOOST_BASE_PATH\""
# pkg_cfg+="-DBoost_DEBUG=OFF"
pkg_cfg+=":-DBoost_FOUND=TRUE"
pkg_cfg+=":-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_INCLUDE_PATH\""
pkg_cfg+=":-DBoost_LIBRARY_DIRS=\"$BLDR_BOOST_LIB_PATH\""

pkg_cflags+=" -fPIC "
# pkg_ldflags="$pkg_ldflags $boost_list $ilm_list $exr_list"

# export LDFLAGS=$pkg_ldflags

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.zip"
    pkg_urls=${pkg_mirrors[$pkg_idx]}
    pkg_base=${pkg_bases[$pkg_idx]}
    pkg_opts="cmake force-bootstrap use-base-dir=$pkg_base"
    pkg_cfg_path="$pkg_base/src"

    bldr_register_pkg                 \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_default" \
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


