#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="cfitsio"

pkg_default="3.310"
pkg_variants=("3.310")

pkg_info="CFITSIO is a library of C and Fortran subroutines for reading and writing data files in FITS (Flexible Image Transport System) data format. "

pkg_desc="CFITSIO is a library of C and Fortran subroutines for reading 
and writing data files in FITS (Flexible Image Transport System) data format. 
CFITSIO provides simple high-level routines for reading and writing 
FITS files that insulate the programmer from the internal complexities 
of the FITS format. CFITSIO also provides many advanced features for 
manipulating and filtering the information in FITS files."

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "
pkg_opts+="force-serial-build "
pkg_opts+="-Mshared "

pkg_reqs="zlib"
pkg_uses="zlib"

pkg_cfg="--enable-reentrant --enable-sse2 --enable-ssse3"

pkg_cflags=""
pkg_ldflags=""
 
####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="cfitsio3310.tar.gz"
     pkg_urls="ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/$pkg_file"

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
done

####################################################################################################

