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
pkg_name="bupc-trans"
pkg_info="The Berkeley UPC-to-C translator provides a source-to-source compiler for translating Unified Parallel C (UPC) to ANSI-C99."

pkg_desc="The Berkeley UPC-to-C translator provides a source-to-source compiler for translating Unified Parallel C (UPC) to ANSI-C99.

Unified Parallel C (UPC) is an extension of the C programming language designed for 
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

pkg_file="berkeley_upc_translator-$pkg_vers.tar.gz"
pkg_urls="http://upc.lbl.gov/download/release/$pkg_file"
pkg_opts="configure force-serial-build skip-config -MPREFIX=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers\""
pkg_reqs=""
pkg_uses="$pkg_reqs"

####################################################################################################

pkg_cfg=""
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
