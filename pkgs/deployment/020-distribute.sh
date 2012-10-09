#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="deployment"
pkg_name="distribute"

pkg_default="0.6.28"
pkg_variants=("0.6.28")

pkg_info="Distribute is a fork of the Setuptools project for Python."

pkg_desc="Distribute is a fork of the Setuptools project for Python."

pkg_opts="python skip-compile skip-install keep-existing-install"

pkg_reqs="python"
pkg_uses="python"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_site=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib/python2.7/site-packages
     export PYTHONPATH=$PYTHONPATH:$pkg_site

     if [[ -d $pkg_site ]]; then
	bldr_remove_dir $pkg_site
     fi
     bldr_make_dir $pkg_site
     bldr_log_split
     
     pkg_file="distribute-$pkg_vers.tar.gz"
     pkg_urls="http://pypi.python.org/packages/source/d/distribute/$pkg_file"

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

