#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="pyfits"

pkg_default="3.1"
pkg_variants=("3.1")

pkg_info="PyFITS provides an interface to FITS formatted files in the Python scripting language."

pkg_desc="PyFITS provides an interface to FITS formatted files in the Python scripting language

It is useful both for interactive data analysis and for writing analysis scripts in 
Python using FITS files as either input or output. PyFITS is a development project 
of the Science Software Branch at the Space Telescope Science Institute.

PyFITS and all necessary modules are included with the stsci_python distribution 
and associated updates to it (though what is included there may not be the very 
latest version). PyFITS does not require PyRAF however. It may be used 
independently so long as numpy is installed."

pkg_opts="python skip-compile skip-install"
pkg_reqs="cfitsio numpy distribute"
pkg_uses="python distribute"

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

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://pypi.python.org/packages/source/p/pyfits/$pkg_file"

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
