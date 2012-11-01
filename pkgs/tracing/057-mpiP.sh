#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="mpiP"

pkg_default="3.3"
pkg_variants=("3.3")

pkg_info="mpiP is a lightweight profiling library for MPI applications."

pkg_desc="mpiP is a lightweight profiling library for MPI applications. 

Because it only collects statistical information about MPI functions, mpiP generates 
considerably less overhead and much less data than tracing tools. All the information 
captured by mpiP is task-local. It only uses communication during report generation, 
typically at the end of the experiment, to merge results from all of the tasks into 
one output file."

pkg_opts="configure force-serial-build "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

####################################################################################################

pkg_reqs="openmpi gfortran binutils libunwind "
pkg_uses="openmpi gfortran binutils libunwind "

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg+="--with-f77=$BLDR_GFORTRAN_BIN_PATH/gfortran "
pkg_cfg+="--with-binutils-dir=$BLDR_BINUTILS_BASE_PATH "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://downloads.sourceforge.net/project/mpip/mpiP/mpiP-3.3/$pkg_file"

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

