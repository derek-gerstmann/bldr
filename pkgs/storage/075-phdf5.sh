#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="1.8.9"
pkg_vers_list=("$pkg_vers" "1.8.2" "1.6.10")
pkg_ctry="storage"
pkg_name="phdf5"

pkg_info="The Parallel-HDF5 technology suite includes HDF5 compiled with MPI support to enable distributed parallel file access."

pkg_desc="The Parallel-HDF5 technology suite includes HDF5 compiled with MPI support to enable distributed parallel file access.

The Parallel-HDF5 technology suite includes:

* A versatile data model that can represent very complex data objects and a wide variety of metadata.
* A completely portable file format with no limit on the number or size of data objects in the collection.
* A software library that runs on a range of computational platforms, from laptops to massively parallel systems, and implements a high-level API with C, C++, Fortran 90, and Java interfaces.
* A rich set of integrated performance features that allow for access time and storage space optimizations.
* Tools and applications for managing, manipulating, viewing, and analyzing the data in the collection."

pkg_file="hdf5-$pkg_vers.tar.gz"
pkg_urls="http://www.hdfgroup.org/ftp/HDF5/releases/$pkg_name-$pkg_vers/src/$pkg_file"
pkg_opts="configure disable-xcode-cflags disable-xcode-ldflags"
pkg_reqs="szip/latest zlib/latest openmpi/1.6 gfortran/latest"
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

pkg_cfg="CC=mpicc FC=mpif90"
pkg_cfg="$pkg_cfg --enable-parallel"
pkg_cfg="$pkg_cfg --enable-fortran"
pkg_cfg="$pkg_cfg --enable-hl"
pkg_cfg="$pkg_cfg --enable-filters=all"
pkg_cfg="$pkg_cfg --enable-static-exec"
pkg_cfg="$pkg_cfg --with-pthread=\"/usr\""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
    pkg_cfg="$pkg_cfg --enable-linux-lfs"
    pkg_cflags="$pkg_cflags -fPIC"
fi

pkg_cfg="$pkg_cfg --with-szlib=\"$BLDR_SZIP_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-zlib=\"$BLDR_ZLIB_BASE_PATH\""

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
                             --config-path "$pkg_cfg_path"\
                             --patch       "$pkg_patches" \
                             --verbose     "$use_verbose"
}

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_name="phdf5"
    pkg_file="hdf5-$pkg_vers.tar.gz"
    pkg_urls="http://www.hdfgroup.org/ftp/HDF5/releases/$pkg_name-$pkg_vers/src/$pkg_file"

    #
    # phdf5 - parallel HDF5 (using MPI collective IO)
    #
    pkg_name="phdf5"
    pkg_cfg="$hdf5_cfg"

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

    #
    # phdf5 - parallel HDF5 w/v1.6 legacy API methods
    #
    if [[ $(echo $pkg_vers | grep -m1 -c '^1.8' ) > 0 ]]
    then

        pkg_name="phdf5-16"
        pkg_cfg="$hdf5_cfg --with-default-api-version=v16"

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
    fi
done
