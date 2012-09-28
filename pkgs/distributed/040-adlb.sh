#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="trunk"
pkg_ctry="distributed"
pkg_name="adlb"

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

pkg_opts="configure migrate-build-tree"
pkg_reqs="openmpi/latest gfortran/latest"
pkg_uses="$pkg_uses"

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

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="svn://svn.cs.mtsu.edu/svn/adlbm/trunk"
bldr_build_pkg                   \
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


