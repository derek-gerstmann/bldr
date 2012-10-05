#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="snu-cl"

pkg_default="1.2b"
pkg_variants=("1.2b")

pkg_info="SnuCL is an OpenCL framework and freely available, open-source software developed at Seoul National University."

pkg_desc=" It naturally extends the original OpenCL semantics to the heterogeneous cluster environment. 
The target cluster consists of a single host node and multiple compute nodes. They are connected by 
an interconnection network, such as Gigabit and InfiniBand switches. The host node contains multiple 
CPU cores and each compute node consists of multiple CPU cores and multiple GPUs. For such clusters, 
SnuCL provides an illusion of a single heterogeneous system for the programmer. A GPU or a set of 
CPU cores becomes an OpenCL compute device. SnuCL allows the application to utilize compute devices 
in a compute node as if they were in the host node. Thus, with SnuCL, OpenCL applications written 
for a single heterogeneous system with multiple OpenCL compute devices can run on the cluster without 
any modifications. SnuCL achieves both high performance and ease of programming in a heterogeneous 
cluster environment.

SnuCL consists of SnuCL runtime and compiler. The SnuCL compiler is based on the OpenCL C 
compiler in SNU-SAMSUNG OpenCL framework. Currently, the SnuCL compiler supports x86, ARM, 
and PowerPC CPUs, AMD GPUs, and NVIDIA GPUs. "

pkg_reqs="openmpi"
pkg_uses="$pkg_uses"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_default"    \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    export SNUCLROOT="${BLDR_BUILD_PATH}/$pkg_ctry/$pkg_name/$pkg_vers"
    
    pkg_file="SnuCL-$pkg_vers.tar.gz"
    pkg_urls="http://aces.snu.ac.kr/download.php?p=snucl&ver=1.2b&email=derek.gerstmann@icrar.org"
    pkg_opts="configure -ESNUCLROOT=$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers use-build-script=build/install.sh"

    bldr_register_pkg                   \
        --category    "$pkg_ctry"    \
        --name        "$pkg_name"    \
        --version     "$pkg_vers"    \
        --info        "$pkg_info"    \
        --description "$pkg_desc"    \
        --file        "$pkg_file"    \
        --url         "$pkg_urls"    \
        --uses        "$pkg_uses"    \
        --requires    "$pkg_reqs"    \
        --options     "$pkg_opts"    \
        --patch       "$pkg_patch"   \
        --cflags      "$pkg_cflags"  \
        --ldflags     "$pkg_ldflags" \
        --config      "$pkg_cfg"
done

####################################################################################################

