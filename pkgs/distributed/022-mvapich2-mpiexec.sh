#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="mvapich2-mpiexec"

pkg_default="1.9a"
pkg_variants=("1.8.1" "1.9a")
pkg_requires=("mvapich2-runtime/1.8.1" "mvapich2-runtime/1.9a")

pkg_info="Mpiexec is a replacement program for the script mpirun, which is part of the mpich package."

pkg_desc="Mpiexec is a replacement program for the script mpirun, which is part of the mpich package.

It is used to initialize a parallel job from within a PBS batch or interactive environment. Mpiexec 
uses the task manager library of PBS to spawn copies of the executable on the nodes in a PBS allocation."

pkg_opts="configure"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--with-default-comm=mpich2-pmi --with-pbs=/usr "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_reqs=${pkg_requires[$pkg_idx]}
    pkg_uses=${pkg_requires[$pkg_idx]}

    pkg_file="mpiexec-0.84.tgz"
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

    let pkg_idx++
done

####################################################################################################

