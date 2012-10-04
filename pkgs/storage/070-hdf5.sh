#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="1.8.9"
pkg_vers_list=("1.6.10" "1.8.2" "$pkg_vers")
pkg_ctry="storage"
pkg_name="hdf5"

pkg_info="HDF5 is a unique technology suite that makes possible the management of extremely large and complex data collections."

pkg_desc="HDF5 is a unique technology suite that makes possible the management of extremely large and complex data collections.

The HDF5 technology suite includes:

* A versatile data model that can represent very complex data objects and a wide variety of metadata.
* A completely portable file format with no limit on the number or size of data objects in the collection.
* A software library that runs on a range of computational platforms, from laptops to massively parallel systems, and implements a high-level API with C, C++, Fortran 90, and Java interfaces.
* A rich set of integrated performance features that allow for access time and storage space optimizations.
* Tools and applications for managing, manipulating, viewing, and analyzing the data in the collection."

pkg_vers_dft="1.8.9"
pkg_vers_list=("$pkg_vers_dft" "1.8.2" "1.6.10")

pkg_opts="configure skip-xcode-config force-serial-build"
pkg_reqs="szip zlib"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_vers_dft"\
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg="$pkg_cfg --enable-hl"
pkg_cfg="$pkg_cfg --enable-filters=all"
pkg_cfg="$pkg_cfg --enable-static-exec"

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
    pkg_cfg="$pkg_cfg --with-pthread=\"/usr\""
fi

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
    pkg_cfg="$pkg_cfg --with-pthread=\"/usr\""
    pkg_cfg="$pkg_cfg --enable-linux-lfs"
    pkg_cflags="$pkg_cflags -fPIC"
fi

pkg_cfg="$pkg_cfg --with-szlib=\"$BLDR_SZIP_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-zlib=\"$BLDR_ZLIB_BASE_PATH\""

hdf5_cfg="$pkg_cfg"
hdf5_reqs="$pkg_reqs"

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_name="hdf5"
    pkg_file="hdf5-$pkg_vers.tar.gz"
    pkg_urls="http://www.hdfgroup.org/ftp/HDF5/releases/$pkg_name-$pkg_vers/src/$pkg_file"

    #
    # hdf5 - standard
    #
    pkg_name="hdf5"
    pkg_cfg="$hdf5_cfg --enable-cxx"
    if [[ $(echo $pkg_vers | grep -m1 -c '^1.8' ) > 0 ]]
    then
      	if [[ $(echo $pkg_vers | grep -m1 -c '^1.8.2' ) < 1 ]]
        then
            pkg_cfg="$pkg_cfg FC=gfortran"
            pkg_cfg="$pkg_cfg --enable-fortran"
            pkg_reqs="$hdf5_reqs gfortran"
        fi
    else
        pkg_reqs="$hdf5_reqs"      
    fi

    bldr_register_pkg              \
      --category    "$pkg_ctry"    \
      --name        "$pkg_name"    \
      --version     "$pkg_vers"    \
      --default     "$pkg_vers_dft"\
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
    # hdf5 - with legacy v1.6 API methods
    #
    if [[ $(echo $pkg_vers | grep -m1 -c '^1.8' ) > 0 ]]
    then
        pkg_name="hdf5-16"
        pkg_cfg="$hdf5_cfg --enable-cxx"
        pkg_cfg="$pkg_cfg --with-default-api-version=v16"
      
      	if [[ $(echo $pkg_vers | grep -m1 -c '^1.8.2' ) < 1 ]]
        then
            pkg_cfg="$pkg_cfg FC=gfortran"
            pkg_cfg="$pkg_cfg --enable-fortran"
            pkg_reqs="$hdf5_reqs gfortran/latest"
        fi

        bldr_register_pkg                 \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
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


    #
    # hdf5 - threadsafe (re-entrant methods wrapped in mutex locks) 
    #
    pkg_name="hdf5-threadsafe"
    pkg_cfg="$hdf5_cfg --enable-threadsafe"
    pkg_reqs="$hdf5_reqs"      

    bldr_register_pkg              \
      --category    "$pkg_ctry"    \
      --name        "$pkg_name"    \
      --version     "$pkg_vers"    \
      --default     "$pkg_vers_dft"\
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
    # hdf5 - threadsafe w/v1.6 API methods
    #
    if [[ $(echo $pkg_vers | grep -m1 -c '^1.8' ) > 0 ]]
    then
        pkg_name="hdf5-threadsafe-16"
        pkg_cfg="$hdf5_cfg --enable-threadsafe"
        pkg_cfg="$hdf5_cfg --with-default-api-version=v16"
        pkg_reqs="$hdf5_reqs"      

        bldr_register_pkg              \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
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

####################################################################################################
