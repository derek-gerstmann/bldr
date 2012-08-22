#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="2.14.2"
pkg_ctry="compilers"
pkg_name="upc"
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

pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs perl/latest"
pkg_reqs="$pkg_reqs bupc-trans/latest"
pkg_reqs="$pkg_reqs openmpi/1.6"
pkg_reqs="$pkg_reqs gcc/latest"
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
pkg_cfg="$pkg_cfg --enable-languages=fortran"
pkg_cfg="$pkg_cfg BUPC_TRANS=\"$BLDR_BUPC_TRANS_BASE_PATH/targ\""
pkg_cfg="$pkg_cfg MPI_CC=\"$BLDR_OPENMPI_BIN_PATH/mpicc\""

if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
    pkg_cfg="$pkg_cfg --enable-pshm"
    pkg_cfg="$pkg_cfg --enable-pthreads"
    pkg_cfg="$pkg_cfg PTHREADS_INCLUDE=/usr/include"
    pkg_cfg="$pkg_cfg PTHREADS_LIB=/usr/lib"
fi

pkg_cflags=""
pkg_ldflags=""
pkg_patch=""

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

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
