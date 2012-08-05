#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="threadpool"
pkg_vers="0.2.5"

pkg_info="ThreadPool is a cross-platform C++ thread pool library using the Boost C++ libraries."

pkg_desc="ThreadPool is a cross-platform C++ thread pool library using the Boost C++ libraries. 

In general terms thread pools are an efficient mechanism for asynchronous task processing 
within the same process. They realise the thread pool pattern.

A thread pool manages a group of threads in order to process a large number of tasks. 
Since multiple threads can be executed in parallel this approach may be very efficient 
regarding the overall program performance on many computer systems. By restricting the 
number of threads and by reusing them resources are saved and additionally the system 
stability is increased.

The threadpool library provides a convenient way for dispatching asynchronous tasks. 
Pools can be customized, managed dynamically and easily integrated into your software."

pkg_file="threadpool-0_2_5-src.zip"
pkg_urls="http://sourceforge.net/projects/threadpool/files/threadpool/0.2.5%20%28Stable%29/$pkg_file"
pkg_opts="configure force-static skip-compile keep"
pkg_reqs="zlib/latest bzip2/latest libicu/latest boost/latest"
pkg_uses="m4/latest autoconf/latest automake/latest $pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_cfg_path="threadpool"

####################################################################################################

function bldr_pkg_install_method()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
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

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local build_path=$(bldr_locate_build_path $pkg_cfg_path)
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path"

    local hdr_path="boost"
    if [ -d "$hdr_path" ]
    then
        bldr_log_status "Migrating build files from '$hdr_path' for '$pkg_name/$pkg_vers'"
        bldr_log_split
        bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include/$hdr_path"
        bldr_copy_dir "$hdr_path" "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include/$hdr_path" || bldr_bail "Failed to copy shared files into directory: $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$path"
        bldr_log_split
    fi

    bldr_pop_dir
}

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
               --config      "$pkg_cfg"     \
               --config-path "$pkg_cfg_path"

