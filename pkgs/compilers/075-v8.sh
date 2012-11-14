#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="v8"

pkg_default="3.14.5"
pkg_variants=("3.14.5" "trunk")
pkg_distribs=("https://github.com/v8/v8/archive/3.14.5.tar.gz"
              "git://github.com/v8/v8.git")

pkg_info="V8 is Google's open source JavaScript engine."

pkg_desc="V8 is Google's open source JavaScript engine.

V8 is written in C++ and is used in Google Chrome, the open source browser from Google.

V8 implements ECMAScript as specified in ECMA-262, 5th edition, and runs on Windows 
(XP or newer), Mac OS X (10.5 or newer), and Linux systems that use IA-32, x64, or ARM processors.

V8 can run standalone, or can be embedded into any C++ application."

pkg_opts="configure "
pkg_opts+="skip-install "
pkg_opts+="use-make-build-target=native "
pkg_opts+="-Mlibrary=shared "
pkg_opts+="migrate-build-tree "
pkg_opts+="migrate-build-headers "
pkg_opts+="migrate-build-bin "
pkg_opts+="use-build-tree=out/native "

pkg_reqs=""
pkg_uses="m4 automake autoconf"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

####################################################################################################

function bldr_pkg_config_method()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_vers_dft=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_patches=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --default)       pkg_vers_dft="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    bldr_config_pkg                   \
        --info        "$pkg_info"     \
        --description "$pkg_desc"     \
        --category    "$pkg_ctry"     \
        --name        "$pkg_name"     \
        --version     "$pkg_vers"     \
        --default     "$pkg_vers_dft" \
        --file        "$pkg_file"     \
        --url         "$pkg_urls"     \
        --uses        "$pkg_uses"     \
        --requires    "$pkg_reqs"     \
        --options     "$pkg_opts"     \
        --cflags      "$pkg_cflags"   \
        --ldflags     "$pkg_ldflags"  \
        --patch       "$pkg_patches"  \
        --config      "$pkg_cfg"      \
        --config-path "$pkg_cfg_path" \
        --verbose     "$use_verbose"

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_log_subsection "Configuring package '$pkg_name/$pkg_vers' using '$cfg_cmd' ..."

    bldr_run_cmd "make dependencies"

    bldr_pop_dir

}
####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls=${pkg_distribs[$pkg_idx]}
    
    bldr_register_pkg                 \
        --category    "$pkg_ctry"     \
        --name        "$pkg_name"     \
        --version     "$pkg_vers"     \
        --default     "$pkg_default"  \
        --info        "$pkg_info"     \
        --description "$pkg_desc"     \
        --file        "$pkg_file"     \
        --url         "$pkg_urls"     \
        --uses        "$pkg_uses"     \
        --requires    "$pkg_reqs"     \
        --options     "$pkg_opts"     \
        --cflags      "$pkg_cflags"   \
        --ldflags     "$pkg_ldflags"  \
        --config      "$pkg_cfg"      \
        --config-path "$pkg_cfg_path"
done

####################################################################################################

