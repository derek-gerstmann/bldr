#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="mpiexec"

pkg_default="0.84"
pkg_variants=("0.84")

pkg_info="ADLB is a software library designed to help rapidly build scalable parallel programs."

pkg_desc="ADLB is a software library designed to help rapidly build scalable parallel programs. 

ADLB is a software library designed to help rapidly build scalable parallel programs. 
The name (pronounced adlib) is the acronym for Asynchronous Dynamic Load Balancing. 

However, ADLB does not achieve scalability solely by load balancing. It also includes some 
features that exploit work-stealing as well. Indeed, we sometimes use the phrase instantaneous 
load balancing via work-stealing to describe ADLB. 

ADLB will be available under the same license arrangement as MPICH2. 

There are features of ADLB that are reminiscent of a variety of other systems, e.g. Linda. 
However, ADLB is significantly different and unique in a number of ways."

pkg_opts="configure"
pkg_reqs="openmpi mvapich2 torque"
pkg_uses="openmpi mvapich2"

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

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tgz"
    pkg_urls="https://www.osc.edu/~djohnson/mpiexec/$pkg_file"

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

