#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="bldr"
pkg_vers="$BLDR_VERSION_STR"

pkg_info="BLDR is a modular software environment builder."

pkg_desc="BLDR is a simple, straight-forward system that automates the process of 
building software packages from source with customisable configurations into 
self-contained, tagged and versioned modules. 

It has minimal requirements and will generally run on any BSD/Unix/Posix system 
that has GNU tools and BASH.

This system was written to help ease the burden of deploying software in HPC 
environments, and to avoid relying on arbitrary libraries, paths and environments 
which may interfere with performance critical code.

If you are looking for a decentralised repository, or a packaging system with all 
the bells and whistles, you're probably better off with RPMs, DEBs, PORTs, FINK, 
Portage, EBUILDS etc.

However, if you routinely recompile large software packages from source or 
repositories and need the ability to fine tune the various compilation flags 
and test out different builds with different compilers, you may find BLDR useful.

It integrates the modules software environment into a source compilation build 
framework that generates localised, stand-alone binary products, tracks 
dependencies, and supports dynamic environment changes."

pkg_file="$pkg_name-$pkg_vers.zip"
pkg_urls="https://github.com/downloads/voidcycles/bldr/$pkg_file"
pkg_opts="configure skip-fetch skip-boot skip-compile skip-configure skip-install migrate-build-tree"
pkg_opts="$pkg_opts -EBLDR_SCRIPTS_PATH=\"$BLDR_SCRIPTS_PATH\""
pkg_opts="$pkg_opts -EBLDR_PKGS_PATH=\"$BLDR_PKGS_PATH\""
pkg_opts="$pkg_opts -EBLDR_PATCHES_PATH=\"$BLDR_PATCHES_PATH\""
pkg_opts="$pkg_opts -EBLDR_SYSTEM_PATH=\"$BLDR_SYSTEM_PATH\""
pkg_opts="$pkg_opts -EBLDR_CACHE_PATH=\"$BLDR_CACHE_PATH\""
pkg_opts="$pkg_opts -EBLDR_BUILD_PATH=\"$BLDR_BUILD_PATH\""
pkg_opts="$pkg_opts -EBLDR_LOG_PATH=\"$BLDR_LOG_PATH\""
pkg_opts="$pkg_opts -EBLDR_LOCAL_PATH=\"$BLDR_LOCAL_PATH\""
pkg_opts="$pkg_opts -EBLDR_MODULE_PATH=\"$BLDR_MODULE_PATH\""

pkg_uses=""
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "$pkg_ctry"    \
               --name        "$pkg_name"    \
               --version     "$pkg_vers"    \
               --info        "$pkg_info"    \
               --description "$pkg_desc"    \
               --file        "$pkg_file"    \
               --url         "$pkg_urls"    \
               --uses        "$pkg_uses"    \
               --requires    "$pkg_reqs"    \
               --options     "$pkg_opts"    \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"


