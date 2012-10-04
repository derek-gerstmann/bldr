#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="scalasca"

pkg_info="Scalasca is a software tool that supports the performance optimization of parallel programs by measuring and analyzing their runtime behavior."

pkg_desc="Scalasca is a software tool that supports the performance optimization of parallel programs by measuring and analyzing their runtime behavior.

The analysis identifies potential performance bottlenecks – in particular those concerning communication and synchronization – and offers guidance in exploring their causes."

pkg_vers_dft="1.4.2"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_reqs=""
#pkg_reqs="$pkg_reqs binutils" 
pkg_reqs="$pkg_reqs papi"
pkg_reqs="$pkg_reqs pdt"
pkg_reqs="$pkg_reqs vtf"
pkg_reqs="$pkg_reqs otf"
pkg_reqs="$pkg_reqs qt4"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_vers_dft"\
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################

pkg_cfg="--enable-all-mpi-wrappers"
pkg_cfg="$pkg_cfg --with-papi=\"$BLDR_PAPI_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-otf=\"$BLDR_OTF_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-vtf=\"$BLDR_VTF_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-pdt=\"$BLDR_PDT_BASE_PATH\""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.bz2"
    pkg_urls="http://www2.fz-juelich.de/zam/datapool/$pkg_name/$pkg_file"

    bldr_register_pkg                \
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
        --config      "$pkg_cfg"     \
        --config-path "$pkg_cfg_path"
done

####################################################################################################
