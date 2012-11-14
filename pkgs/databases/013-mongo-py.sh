#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="mongo-py"

pkg_default="2.3"
pkg_variants=("2.3")

pkg_info="Python driver for MongoDB."

pkg_desc="Python driver for MongoDB."

pkg_opts="python skip-compile skip-install keep-existing-install "

pkg_uses="python mongo-db"
pkg_reqs=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_site=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib/python2.7/site-packages
     export PYTHONPATH=$pkg_site:$PYTHONPATH

     if [[ -d $pkg_site ]]; then
	bldr_remove_dir $pkg_site
     fi
     bldr_make_dir $pkg_site
     bldr_log_split

     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="https://github.com/mongodb/mongo-python-driver/archive/$pkg_vers.tar.gz"

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


