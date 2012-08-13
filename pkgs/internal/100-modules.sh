#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="internal"
pkg_name="modules"
pkg_vers="3.2.9c"

pkg_info="The modules package provides for the dynamic modification of a user's environment via 'module' files."

pkg_desc="The Environment Modules package provides for the dynamic modification of a user's 
environment via 'module' files. Each 'module' file contains the information needed to configure the 
shell for an application. Once the Modules package is initialized, the environment can be 
modified on a per-module basis using the module command which interprets modulefiles. 
Typically modulefiles instruct the module command to alter or set shell environment 
variables such as PATH, MANPATH, etc. modulefiles may be shared by many users on a system 
and users may have their own collection to supplement or replace the shared modulefiles.

Modules can be loaded and unloaded dynamically and atomically, in an clean fashion. All 
popular shells are supported, including bash, ksh, zsh, sh, csh, tcsh, as well as some 
scripting languages such as perl.

Modules are useful in managing different versions of applications. Modules can also be bundled 
into metamodules that will load an entire suite of different applications."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://aarnet.dl.sourceforge.net/project/modules/Modules/modules-3.2.9/$pkg_file"
pkg_opts="configure force-static skip-modulate"
pkg_uses=""
pkg_uses="$pkg_uses coreutils/latest"
pkg_uses="$pkg_uses findutils/latest"
pkg_uses="$pkg_uses diffutils/latest"
pkg_uses="$pkg_uses patch/latest"
pkg_uses="$pkg_uses sed/latest"
pkg_uses="$pkg_uses grep/latest"
pkg_uses="$pkg_uses pkg-config/latest"
pkg_uses="$pkg_uses m4/latest"
pkg_uses="$pkg_uses gperf/latest"
pkg_uses="$pkg_uses autoconf/latest"
pkg_uses="$pkg_uses automake/latest"
pkg_uses="$pkg_uses tar/latest"
pkg_uses="$pkg_uses libtool/latest"
pkg_uses="$pkg_uses make/latest"
pkg_uses="$pkg_uses cmake/latest"
pkg_uses="$pkg_uses tcl/latest"
pkg_reqs="$pkg_uses"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg="$pkg_cfg --with-tcl-lib=$BLDR_LOCAL_PATH/languages/tcl/latest/lib"
pkg_cfg="$pkg_cfg --with-tcl-inc=$BLDR_LOCAL_PATH/languages/tcl/latest/include"

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


