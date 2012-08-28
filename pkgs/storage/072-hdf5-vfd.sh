#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="1.8.8"
pkg_ver_list=("$pkg_vers" "1.8.9")
pkg_ctry="storage"
pkg_name="hdf5-vfd"

pkg_info="HDF5-VFD is a modified HDF5 source package that provides additional internal support for MPI virtual file drivers."

pkg_desc="HDF5-VFD is a modified HDF5 source package that provides additional internal support for MPI virtual file drivers."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="https://hpcforge.org/frs/download.php/41/$pkg_file"
pkg_opts="cmake"
pkg_reqs="szip/latest zlib/latest openmpi/1.6 gfortran/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_vers"    \
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg:-DMPI_COMPILER=$BLDR_OPENMPI_BIN_PATH/mpicc"
pkg_cfg="$pkg_cfg:-DHDF5_BUILD_TOOLS=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_PARALLEL=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_HSIZET=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_LARGE_FILE=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_ZLIB=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_Z_LIB_SUPPORT=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_SZIP=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_SZIP_SUPPORT=ON"
pkg_cfg="$pkg_cfg:-DHDF5_ENABLE_HL_LIB=ON"
pkg_cfg="$pkg_cfg:-DHDF5_BUILD_CPP_LIB=OFF"
pkg_cfg="$pkg_cfg:-DZLIB_INCLUDE_DIR=$BLDR_ZLIB_INCLUDE_PATH"
pkg_cfg="$pkg_cfg:-DZLIB_LIBRARY=$BLDR_ZLIB_LIB_PATH/libz.a"
pkg_cfg="$pkg_cfg:-DSZIP_INCLUDE_DIR=$BLDR_SZIP_INCLUDE_PATH/include"
pkg_cfg="$pkg_cfg:-DSZIP_LIBRARY=$BLDR_SZIP_LIB_PATH/libsz.a"

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
           --patch)         pkg_patches="$2"; shift 2;;
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

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local build_path=$(bldr_locate_build_path $pkg_cfg_path)
    bldr_pop_dir

    bldr_log_info "Moving to build path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path"

    if [ -f "../release_docs/USING_CMake.txt" ]
    then
        mv "../release_docs/USING_CMake.txt" "../release_docs/Using_CMake.txt"
        bldr_log_split
    fi
    bldr_pop_dir

    # call the standard BLDR install method
    #
    bldr_install_pkg               \
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
      --config      "$pkg_cfg"     \
      --config-path "$pkg_cfg_path"\
      --patch       "$pkg_patches" \
      --verbose     "$use_verbose"
}

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in "${pkg_ver_list[@]}"
do
    pkg_file="$pkg_name-$pkg_vers.tar.bz2"
    pkg_urls="https://hpcforge.org/frs/download.php/57/$pkg_file"

    #
    # hdf5 - standard
    #
    pkg_cfg="$hdf5_cfg"
    if [ $BLDR_SYSTEM_IS_OSX == false ]
    then
        pkg_cfg="$pkg_cfg:-DHDF5_BUILD_FORTRAN=ON"
    fi

    bldr_build_pkg                 \
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

    #
    # hdf5 - threadsafe (re-entrant methods wrapped in mutex locks) 
    #
    ts_name="$pkg_name-threadsafe"
    pkg_cfg="$hdf5_cfg:-DHDF5_ENABLE_THREADSAFE=ON"
    bldr_build_pkg                 \
      --category    "$pkg_ctry"    \
      --name        "$ts_name"     \
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

done
