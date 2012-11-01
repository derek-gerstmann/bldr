#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="mpe2"

pkg_default="1.3.0"
pkg_variants=("1.3.0")

pkg_info="MPE is a software package for MPI (Message Passing Interface) programmers."

pkg_desc="MPE is a set of postmortem profiling tools for use with MPI programs. It consists mainly of 
libmpe, an instrumentation library, and Jumpshot, its associated graphical visualizer. The most 
straightforward way of using it is by linking against libmpe; one may also insert logging calls 
in the target program's source code, thereby increasing the level of detail available for analysis.

While usually associated with MPICH, it is implementation-agnostic and works with OpenMPI, 
LAM/MPI as well as with commercial implementations, such as IBM's and Cray's. "

pkg_opts="configure force-serial-build "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

####################################################################################################

pkg_reqs="openmpi gfortran"
pkg_uses="openmpi gfortran"

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

pkg_cfg="--with-mpilibs=\"-L$BLDR_OPENMPI_LIB_PATH -lmpi -lopen-pal -lopen-rte -lompitrace\" "
pkg_cfg+="--with-mpiinc=\"-I$BLDR_OPENMPI_INCLUDE_PATH\" "
pkg_cfg+="--with-mpicc=$BLDR_OPENMPI_BIN_PATH/mpicc "
pkg_cfg+="--with-mpif77=$BLDR_OPENMPI_BIN_PATH/mpif77 "
pkg_cfg+="F77=$BLDR_GFORTRAN_BIN_PATH/gfortran "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="ftp://ftp.mcs.anl.gov/pub/mpi/mpe/$pkg_file"

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
