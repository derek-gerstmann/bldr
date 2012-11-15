#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="mongo-cpp"

pkg_default="2.2.1"
pkg_variants=("2.2.1")

pkg_info="C++ driver for MongoDB."

pkg_desc="C++ driver for MongoDB."

pkg_opts="scons use-prefix-path use-scons-build-target=mongoclient skip-install"
pkg_opts+="-EBLDR_MONGO_CPP_INCLUDE_PATH=$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include/mongo "

pkg_uses=""
pkg_reqs=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg_path=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="mongodb-linux-x86_64-$pkg_vers.tgz"
    pkg_urls="http://downloads.mongodb.org/cxx-driver/$pkg_file"
    
    pkg_reqs="boost/1.49 "
    pkg_reqs+="mongo-db/$pkg_vers "
    pkg_uses=$pkg_reqs

    bldr_satisfy_pkg                    \
        --category    "$pkg_ctry"       \
        --name        "$pkg_name"       \
        --version     "$pkg_default"    \
        --requires    "$pkg_reqs"       \
        --uses        "$pkg_uses"       \
        --options     "$pkg_opts"

    pkg_cfg+="--extrapath=$BLDR_BOOST_BASE_PATH,$BLDR_MONGO_DB_BASE_PATH "
    
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


