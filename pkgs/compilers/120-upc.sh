#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="upc"

pkg_default="2.14.2"
pkg_variants=("2.14.2")

pkg_info="Unified Parallel C (UPC) is an extension of the C programming language designed for high performance computing on large-scale parallel machines."

pkg_desc="Unified Parallel C (UPC) is an extension of the C programming language designed for 
high performance computing on large-scale parallel machines.

The language provides a uniform programming model for both shared and distributed memory hardware. 

The programmer is presented with a single shared, partitioned address space, where variables may 
be directly read and written by any processor, but each variable is physically associated with a 
single processor. UPC uses a Single Program Multiple Data (SPMD) model of computation in which 
the amount of parallelism is fixed at program startup time, typically with a single thread of 
execution per processor.

In order to express parallelism, UPC extends ISO C 99 with the following constructs:

* An explicitly parallel execution model
* A shared address space
* Synchronization primitives and a memory consistency model
* Memory management primitives

The UPC language evolved from experiences with three other earlier languages that 
proposed parallel extensions to ISO C 99: AC , Split-C, and Parallel C Preprocessor 
(PCP). UPC is not a superset of these three languages, but rather an attempt to distill 
the best characteristics of each. UPC combines the programmability advantages of the 
shared memory programming paradigm and the control over data layout and performance 
of the message passing programming paradigm."

pkg_file="berkeley_upc-$pkg_vers.tar.gz"
pkg_urls="http://upc.lbl.gov/download/release/$pkg_file"
pkg_opts="configure skip-xcode-config"

pkg_reqs="zlib "
pkg_reqs+="perl "
pkg_reqs+="bupc-trans "
pkg_reqs+="openmpi "
pkg_reqs+="gcc "
pkg_uses="$pkg_reqs gfortran"

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

pkg_cfg=""
pkg_cfg+="--enable-languages=fortran "
pkg_cfg+="BUPC_TRANS=\"$BLDR_BUPC_TRANS_BASE_PATH/targ\" "
pkg_cfg+="MPI_CC=\"$BLDR_OPENMPI_BIN_PATH/mpicc\" "

if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
    pkg_cfg+="--enable-pshm "
    pkg_cfg+="--enable-pthreads "
    pkg_cfg+="PTHREADS_INCLUDE=/usr/include "
    pkg_cfg+="PTHREADS_LIB=/usr/lib64 "
fi

pkg_cflags=""
pkg_ldflags=""
pkg_patch=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="berkeley_upc-$pkg_vers.tar.gz"
    pkg_urls="http://upc.lbl.gov/download/release/$pkg_file"

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
