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
pkg_vers="1.4.2"

pkg_info="Scalasca is a software tool that supports the performance optimization of parallel programs by measuring and analyzing their runtime behavior."

pkg_desc="Scalasca is a software tool that supports the performance optimization of parallel programs by measuring and analyzing their runtime behavior.

The analysis identifies potential performance bottlenecks – in particular those concerning communication and synchronization – and offers guidance in exploring their causes."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://www2.fz-juelich.de/zam/datapool/$pkg_name/$pkg_file"
pkg_opts="configure"
pkg_reqs=""
pkg_reqs="$pkg_reqs binutils/latest" 
pkg_reqs="$pkg_reqs papi/latest"
pkg_reqs="$pkg_reqs pdt/latest"
pkg_reqs="$pkg_reqs tau/latest"
pkg_reqs="$pkg_reqs vtf/latest"
pkg_reqs="$pkg_reqs otf/latest"
pkg_reqs="$pkg_reqs qt4/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################

pkg_cfg="--enable-static --enable-shared --enable-all-mpi-wrappers"
pkg_cfg="$pkg_cfg --with-papi=\"$BLDR_PAPI_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-otf=\"$BLDR_OTF_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-vtf=\"$BLDR_VTF_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-pdt=\"$BLDR_PDT_BASE_PATH\""

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_warning "$pkg_name isn't supported on MacOSX.  Skipping..."
     bldr_log_split
else
     bldr_build_pkg --category    "$pkg_ctry"    \
                    --name        "$pkg_name"    \
                    --version     "$pkg_vers"    \
                    --info        "$pkg_info"    \
                    --description "$pkg_desc"    \
                    --file        "$pkg_file"    \
                    --url         "$pkg_urls"    \
                    --uses        "$pkg_uses"    \
                    --requires    "$pkg_reqs"    \
                    --options     "$pkg_opts"    \
                    --cflags      "$pkg_cflags"  \
                    --ldflags     "$pkg_ldflags" \
                    --config      "$pkg_cfg"
fi

