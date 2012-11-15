#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="services"
pkg_name="graphlab"

pkg_default="1.4434"
pkg_variants=("1.4434")

pkg_info="GraphLab is a graph-based, high performance, distributed computation framework written in C++."

pkg_desc="GraphLab is a graph-based, high performance, distributed computation framework written in C++.  

While GraphLab was originally developed for Machine Learning tasks, it has found great success at a 
broad range of other data-mining tasks; out-performing other abstractions by orders of magnitude.

GraphLab Features:
- A unified multicore and distributed API: write once run efficiently in both shared and distributed memory systems
- Tuned for performance: optimized C++ execution engine leverages extensive multi-threading and asynchronous IO
- Scalable: GraphLab intelligently places data and computation using sophisticated new algorithms
- HDFS Integration: Access your data directly from HDFS
- Powerful Machine Learning Toolkits: Turn BigData into actionable knowledge with ease

"

pkg_opts="cmake "
pkg_reqs="zlib openmpi"
pkg_uses="$pkg_uses"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="graphlabapi_v2.$pkg_vers.tar.gz"
    pkg_urls="https://graphlabapi.googlecode.com/files/$pkg_file"

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

