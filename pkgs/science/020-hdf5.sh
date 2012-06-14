#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="hdf5"
pkg_vers="1.8.9"

pkg_info="HDF5 is a unique technology suite that makes possible the management of extremely large and complex data collections."

pkg_desc="HDF5 is a unique technology suite that makes possible the management of extremely large and complex data collections.

The HDF5 technology suite includes:

* A versatile data model that can represent very complex data objects and a wide variety of metadata.
* A completely portable file format with no limit on the number or size of data objects in the collection.
* A software library that runs on a range of computational platforms, from laptops to massively parallel systems, and implements a high-level API with C, C++, Fortran 90, and Java interfaces.
* A rich set of integrated performance features that allow for access time and storage space optimizations.
* Tools and applications for managing, manipulating, viewing, and analyzing the data in the collection."

pkg_file="hdf5-$pkg_vers.tar.gz"
pkg_urls="http://www.hdfgroup.org/ftp/HDF5/current/src/$pkg_file"
pkg_opts="cmake"
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

pkg_name="hdf5-parallel"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_PARALLEL=ON"

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
pkg_cfg="$pkg_cfg:-DH5_USE_16_API=ON"

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
