#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="eq"
pkg_vers="1.4.9"

pkg_info="Equalizer is a middleware library used to create and deploy parallel OpenGL-based applications."

pkg_desc="Equalizer is a middleware library used to create and deploy parallel OpenGL-based applications. 

It enables applications to benefit from multiple graphics cards, processors and computers to scale 
the rendering performance, visual quality and display size. An Equalizer application runs unmodified 
on any visualization system, from a simple workstation to large scale graphics clusters, 
multi-GPU workstations and Virtual Reality installations"

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="https://github.com/Eyescale/Equalizer.git"
pkg_opts="cmake keep"
pkg_reqs="szip/latest zlib/latest"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg:-DSZIP_INCLUDE_DIR=$BLDR_LOCAL_PATH/science/szip/latest/include"
pkg_cfg="$pkg_cfg:-DSZIP_LIBRARY=$BLDR_LOCAL_PATH/system/szip/latest/lib/libsz.a"

pkg_cfg="$pkg_cfg:-DZLIB_INCLUDE_DIR=$BLDR_LOCAL_PATH/system/zlib/latest/include"
pkg_cfg="$pkg_cfg:-DZLIB_LIBRARY=$BLDR_LOCAL_PATH/system/zlib/latest/lib/libz.a"

pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_ZLIB=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_Z_LIB_SUPPORT=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_ZLIB_SUPPORT=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_SZIP_SUPPORT=ON"
pkg_cfg="$pkg_cfg:-DHDF5_BUILD_HL_LIB=ON"
pkg_cfg="$pkg_cfg:-DHDF5_DISABLE_COMPILER_WARNINGS=ON"
pkg_cfg="$pkg_cfg:-DHDF5_DISABLE_COMPILER_WARNINGS=ON"
pkg_cfg="$pkg_cfg -DCMAKE_CXX_FLAGS='-I$BLDR_LOCAL_PATH/science/szip/latest/include -I$BLDR_LOCAL_PATH/science/szip/latest/src'"
pkg_cfg="$pkg_cfg -DCMAKE_CPP_FLAGS='-I$BLDR_LOCAL_PATH/science/szip/latest/include -I$BLDR_LOCAL_PATH/science/szip/latest/src'"
pkg_cfg="$pkg_cfg -DCMAKE_C_FLAGS='-I$BLDR_LOCAL_PATH/science/szip/latest/include -I$BLDR_LOCAL_PATH/science/szip/latest/src'"
hdf5_cfg="$pkg_cfg"

####################################################################################################

function bldr_pkg_install_method()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -c 'skip-compile' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile $pkg_cfg_path)
    bldr_pop_dir

    bldr_log_info "Moving to build path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$make_path' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"

    mv "../release_docs/USING_CMake.txt" "../release_docs/Using_CMake.txt"
    bldr_log_split
    bldr_pop_dir

    # call the standard BLDR compile method
    #
    bldr_install_pkg         --category    "$pkg_ctry"    \
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
                             --patch       "$pkg_patches" \
                             --verbose     "$use_verbose"
}

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "science"      \
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

####################################################################################################

pkg_name="hdf5-threadsafe"
pkg_cfg="$hdf5_cfg:-DHDF5_ENABLE_THREADSAFE=ON"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "science"      \
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

pkg_name="hdf5-threadsafe-16"
pkg_cfg="$hdf5_cfg:-DHDF5_ENABLE_THREADSAFE=ON:-DH5_USE_16_API=ON"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "science"      \
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

pkg_name="hdf5-parallel"
pkg_cfg="$hdf5_cfg:-DHDF5_ENABLE_PARALLEL=ON"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "science"      \
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

pkg_name="hdf5-parallel-16"
pkg_cfg="$hdf5_cfg:-DHDF5_ENABLE_PARALLEL=ON:-DH5_USE_16_API=ON"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "science"      \
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
