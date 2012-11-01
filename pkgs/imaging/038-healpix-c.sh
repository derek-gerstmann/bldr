#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="healpix-c"

pkg_default="2.20a"
pkg_variants=("2.20a")
pkg_releases=("2011Feb09")

pkg_info="Hierarchical Equal Area isoLatitude Pixelization (HEALpix) of a sphere bindings for CXX."

pkg_desc="Hierarchical Equal Area isoLatitude Pixelization (HEALpix) of a sphere bindings for CXX. 
Software for pixelization, hierarchical indexation, synthesis, analysis, 
and visualization of data on the sphere."

pkg_opts="configure skip-config force-serial-build "
pkg_reqs="zlib cfitsio"
pkg_uses="$pkg_reqs"
pkg_cfg_path="src/C/subs"

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
    export AR="ar -rsv" 
    pkg_opts+="use-build-tree=src/C/osx "
    pkg_opts+="-MHEALPIX_TARGET=osx "
else
    export HEALPIX_TARGET=generic_gcc
    export AR="ar -rsv" 
    pkg_opts+="use-build-tree=src/C/generic_gcc "
    pkg_opts+="-MHEALPIX_TARGET=generic_gcc "
    pkg_opts+="-MOPTS=-fPIC "
fi

pkg_opts+="-MEXTERNAL_CFITSIO=yes "
pkg_opts+="-MCFITSIO_INCDIR=$BLDR_CFITSIO_INCLUDE_PATH "
pkg_opts+="-MCFITSIO_LIBDIR=$BLDR_CFITSIO_LIB_PATH "
pkg_opts+="-MCFITSIO_EXT_LIB=$BLDR_CFITSIO_LIB_PATH/libcfitsio.a "
pkg_opts+="-MCFITSIO_EXT_INC=$BLDR_CFITSIO_INCLUDE_PATH "
hpix_opts=$pkg_opts

####################################################################################################

function bldr_pkg_setup_method()
{
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_vers_dft=""
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
    local use_verbose="false"

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --default)       pkg_vers_dft="$2"; shift 2;;
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

    bldr_setup_pkg                    \
        --info        "$pkg_info"     \
        --description "$pkg_desc"     \
        --category    "$pkg_ctry"     \
        --name        "$pkg_name"     \
        --version     "$pkg_vers"     \
        --default     "$pkg_vers_dft" \
        --file        "$pkg_file"     \
        --url         "$pkg_urls"     \
        --uses        "$pkg_uses"     \
        --requires    "$pkg_reqs"     \
        --options     "$pkg_opts"     \
        --cflags      "$pkg_cflags"   \
        --ldflags     "$pkg_ldflags"  \
        --patch       "$pkg_patches"  \
        --config      "$pkg_cfg"      \
        --config-path "$pkg_cfg_path" \
        --verbose     "$use_verbose"


     bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
     bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bin"
     bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib"
     bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include"
     bldr_log_split

    bldr_log_info "Done setting up package '$pkg_name/$pkg_vers'!"
    bldr_log_split
}

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
     pkg_date=${pkg_releases[$pkg_idx]}
     pkg_file="Healpix_${pkg_vers}_${pkg_date}.tar.gz"
     pkg_urls="http://downloads.sourceforge.net/project/healpix/Healpix_${pkg_vers}/${pkg_file}"
          
     pkg_opts=$hpix_opts
     pkg_opts+="-MBINDIR=${BLDR_LOCAL_PATH}/$pkg_ctry/$pkg_name/$pkg_vers/bin "
     pkg_opts+="-MLIBDIR=${BLDR_LOCAL_PATH}/$pkg_ctry/$pkg_name/$pkg_vers/lib "
     pkg_opts+="-MINCDIR=${BLDR_LOCAL_PATH}/$pkg_ctry/$pkg_name/$pkg_vers/include "

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
