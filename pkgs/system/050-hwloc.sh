#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="system"
pkg_name="hwloc"

pkg_default="1.5"
pkg_variants=("1.5")
pkg_mirrors=("http://www.open-mpi.org/software/hwloc/v1.5/downloads")

pkg_info="The Portable Hardware Locality (hwloc) software package provides a portable abstraction (across OS, versions, architectures, ...) of the hierarchical topology of modern architectures, including NUMA memory nodes, sockets, shared caches, cores and simultaneous multithreading."

pkg_desc="The Portable Hardware Locality (hwloc) software package provides a 
portable abstraction (across OS, versions, architectures, ...) of the hierarchical 
topology of modern architectures, including NUMA memory nodes, sockets, shared caches, 
cores and simultaneous multithreading. It also gathers various system attributes such 
as cache and memory information as well as the locality of I/O devices such as 
network interfaces, InfiniBand HCAs or GPUs. It primarily aims at helping applications
with gathering information about modern computing hardware so as to exploit it 
accordingly and efficiently."

pkg_opts="configure"
pkg_opts+="enable-static "
pkg_opts+="enable-shared "
pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_host=${pkg_mirrors[$pkg_idx]}
    pkg_urls="$pkg_host/$pkg_file"

    bldr_register_pkg                  \
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
