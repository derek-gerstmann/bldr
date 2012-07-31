#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="graphics"
pkg_name="glew"
pkg_vers="1.8.0"

pkg_info="The OpenGL Extension Wrangler Library (GLEW) is a cross-platform open-source C/C++ extension loading library."

pkg_desc="The OpenGL Extension Wrangler Library (GLEW) is a cross-platform open-source C/C++ 
extension loading library. GLEW provides efficient run-time mechanisms for determining which 
OpenGL extensions are supported on the target platform. OpenGL core and extension functionality 
is exposed in a single header file. GLEW has been tested on a variety of operating systems, 
including Windows, Linux, Mac OS X, FreeBSD, Irix, and Solaris. "

pkg_file="$pkg_name-$pkg_vers.tgz"
pkg_urls="http://sourceforge.net/projects/glew/files/$pkg_name/$pkg_vers/$pkg_file/download"
pkg_opts="configure skip-install"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_reqs=""
pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################

function bldr_pkg_boot_method()
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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
    local base="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name"

    bldr_log_status "Booting package '$pkg_name/$pkg_vers'"
    bldr_log_split
    
    bldr_log_info "Moving to boot path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/auto' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/auto"

    local output=$(bldr_get_stdout)
    local options="--stop"
    if [ $BLDR_VERBOSE != true ]
    then
        options="--quiet $options"
    fi

    if [ -f "./Makefile" ]
    then
        bldr_log_cmd "make $options"
        bldr_log_split

        if [ $BLDR_VERBOSE != false ]
        then
            eval make $options || bldr_bail "Failed to boot package: '$prefix'"
            bldr_log_split
        else
            eval make $options &> /dev/null || bldr_bail "Failed to boot package: '$prefix'"
        fi
    fi
    bldr_pop_dir
}


####################################################################################################

function bldr_pkg_compile_method()
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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
    local base="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name"

    bldr_log_status "Building package '$pkg_name/$pkg_vers'"
    bldr_log_split
    
    bldr_log_info "Moving to build path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    local output=$(bldr_get_stdout)
    local options="--stop"
    if [ $BLDR_VERBOSE != true ]
    then
        options="--quiet $options"
    fi

    local glew_prefix=$prefix
    if [ -f "./Makefile" ]
    then
        if [ "$BLDR_OS_IS_CENTOS" -eq 1 ]
        then
            local glew_sys="centos"
            bldr_copy_file "$BLDR_PATCHES_PATH/$pkg_name/$pkg_vers/$glew_sys/Makefile.$glew_sys" "./config/Makefile.$glew_sys"

            bldr_log_cmd "make GLEW_PREFIX=\"$glew_prefix\" SYSTEM=\"$glew_sys\" $options"
            bldr_log_split

            if [ $BLDR_VERBOSE != false ]
            then
                eval make GLEW_DEST="$glew_prefix" SYSTEM="$glew_sys" $options || bail "Failed to build package: '$prefix'"
                bldr_log_split
                eval make GLEW_DEST="$glew_prefix" SYSTEM="$glew_sys" $options install || bail "Failed to build package: '$prefix'"
                bldr_log_split
            else
                eval make GLEW_DEST="$glew_prefix" SYSTEM="$glew_sys" $options  &> /dev/null || bail "Failed to build package: '$prefix'"
                bldr_log_split
                eval make GLEW_DEST="$glew_prefix" SYSTEM="$glew_sys" $options install  &> /dev/null || bail "Failed to build package: '$prefix'"
                bldr_log_split
            fi
            
        else
            bldr_log_cmd "make GLEW_PREFIX=\"$glew_prefix\" $options"
            bldr_log_split

            if [ $BLDR_VERBOSE != false ]
            then
                eval make GLEW_DEST="$glew_prefix" $options || bail "Failed to build package: '$prefix'"
                bldr_log_split
                eval make GLEW_DEST="$glew_prefix" $options install || bail "Failed to build package: '$prefix'"
                bldr_log_split
            else
                eval make GLEW_DEST="$glew_prefix" $options  &> /dev/null || bail "Failed to build package: '$prefix'"
                bldr_log_split
                eval make GLEW_DEST="$glew_prefix" $options install  &> /dev/null || bail "Failed to build package: '$prefix'"
                bldr_log_split
            fi
        fi
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
               --config      "$pkg_cfg"


