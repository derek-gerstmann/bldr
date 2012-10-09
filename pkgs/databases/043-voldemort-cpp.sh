#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="databases"
pkg_name="voldemort-cpp"

pkg_default="0.96"
pkg_variants=("0.96")

pkg_info="The Voldemort CPP client provides a Thrift interface to Voldemort Server."

pkg_desc="The Voldemort CPP client provides a Thrift interface to Voldemort Server."

pkg_opts="configure "
pkg_opts+="force-bootstrap "
pkg_opts+="use-build-tree=clients/cpp "
pkg_opts+="use-base-dir=clients/cpp "

vdm_reqs="boost protobuf expat"
pkg_uses=""

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default"\
    --requires    "$vdm_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--with-boost=$BLDR_BOOST_BASE_PATH "
pkg_cfg+="--with-boost-asio=boost_system "
#pkg_cfg+="--with-boost-unit-test-framework=boost_unit_test_framework "
pkg_cfg+="--with-boost-thread=boost_thread "
pkg_cfg_path="clients/cpp"

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="voldemort-$pkg_vers.tar.gz"
    pkg_urls="https://github.com/downloads/voldemort/voldemort/$pkg_file"
    pkg_reqs="$vdm_reqs voldemort/$pkg_vers"

    bldr_register_pkg                 \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_default"\
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

