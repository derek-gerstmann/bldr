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

pkg_default="3.2.9c"
pkg_variants=("3.2.9c")

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

pkg_opts="configure force-static skip-modulate"

pkg_uses="coreutils "
pkg_uses+="findutils "
pkg_uses+="diffutils "
pkg_uses+="patch "
pkg_uses+="sed "
pkg_uses+="grep "
pkg_uses+="m4 "
pkg_uses+="gperf "
pkg_uses+="autoconf "
pkg_uses+="automake "
pkg_uses+="tar "
pkg_uses+="make "
pkg_uses+="cmake "
pkg_uses+="tcl "
pkg_reqs="$pkg_uses"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg+="--with-tcl-lib=$BLDR_LOCAL_PATH/languages/tcl/default/lib "
pkg_cfg+="--with-tcl-inc=$BLDR_LOCAL_PATH/languages/tcl/default/include "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.gz"
     pkg_urls="http://aarnet.dl.sourceforge.net/project/modules/Modules/modules-3.2.9/$pkg_file"

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

