#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="storage"
pkg_name="fastquery"

pkg_default="0.8.1.9"
pkg_variants=("0.8.1.9")

pkg_info="FastQuery provides parallel indexing and searching capability for array data."

pkg_desc="FastQuery provides parallel indexing and searching capability for array data."

pkg_opts="configure enable-static enable-shared "

pkg_reqs="mxml fastbit phdf5 pnetcdf openmpi szip zlib"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_default" \
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--enable-parallel"
pkg_cfg+="--enable-hdf5"
pkg_cfg+="--enable-pnetcdf"
pkg_cfg+="--with-mxml=\"$BLDR_MXML_BASE_PATH\" "
pkg_cfg+="--with-fastbit=\"$BLDR_FASTBIT_BASE_PATH\" "
pkg_cfg+="--with-mpi=\"$BLDR_OPENMPI_BASE_PATH\" "
pkg_cfg+="--with-szip=\"$BLDR_SZIP_BASE_PATH\" "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="https://codeforge.lbl.gov/frs/download.php/393/$pkg_file"

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

