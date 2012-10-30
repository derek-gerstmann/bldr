#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="healpix-cxx"

pkg_default="2.20a"
pkg_variants=("2.20a")
pkg_releases=("2011Feb09")

pkg_info="Hierarchical Equal Area isoLatitude Pixelization (HEALpix) of a sphere bindings for CXX."

pkg_desc="Hierarchical Equal Area isoLatitude Pixelization (HEALpix) of a sphere bindings for CXX. 
Software for pixelization, hierarchical indexation, synthesis, analysis, 
and visualization of data on the sphere."

pkg_opts="configure skip-config force-serial-build migrate-build-tree"
pkg_reqs="zlib cfitsio"
pkg_uses="$pkg_reqs"
pkg_cfg_path="src/cxx"

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

export EXTERNAL_CFITSIO=yes
if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
    export HEALPIX_TARGET=osx
    pkg_opts+="use-build-tree=src/cxx/osx "
    pkg_opts+="-MHEALPIX_TARGET=osx "
else
    export HEALPIX_TARGET=generic_gcc
    pkg_opts+="use-build-tree=src/cxx/generic_gcc "
    pkg_opts+="-MHEALPIX_TARGET=generic_gcc "
    pkg_opts+="-MOPTS=-fPIC"
fi

pkg_opts+="-MEXTERNAL_CFITSIO=yes "
pkg_opts+="-MCFITSIO_INCDIR=$BLDR_CFITSIO_INCLUDE_PATH "
pkg_opts+="-MCFITSIO_LIBDIR=$BLDR_CFITSIO_LIB_PATH "
pkg_opts+="-MCFITSIO_EXT_LIB=$BLDR_CFITSIO_LIB_PATH/libcfitsio.a "
pkg_opts+="-MCFITSIO_EXT_INC=$BLDR_CFITSIO_INCLUDE_PATH "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
     pkg_date=${pkg_releases[$pkg_idx]}
     pkg_file="Healpix_${pkg_vers}_${pkg_date}.tar.gz"
     pkg_urls="http://downloads.sourceforge.net/project/healpix/Healpix_${pkg_vers}/${pkg_file}"
     
     pkg_cflags=$hpix_cflags
     pkg_cflags+="-MBINDIR=${BLDR_LOCAL_PATH}/$pkg_ctry/$pkg_name/$pkg_vers/bin "
     pkg_cflags+="-MLIBDIR=${BLDR_LOCAL_PATH}/$pkg_ctry/$pkg_name/$pkg_vers/lib "
     pkg_cflags+="-MINCDIR=${BLDR_LOCAL_PATH}/$pkg_ctry/$pkg_name/$pkg_vers/include "

     bldr_register_pkg                \
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
 
     let pkg_idx++
done

####################################################################################################
