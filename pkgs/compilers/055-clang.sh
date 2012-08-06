#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="clang"
pkg_vers="3.1"
pkg_info="Clang is an LLVM native C/C++/Objective-C compiler."

pkg_desc="Clang is an LLVM native C/C++/Objective-C compiler, which aims to deliver 
amazingly fast compiles (e.g. about 3x faster than GCC when compiling Objective-C code 
in a debug configuration), extremely useful error and warning messages and to provide 
a platform for building great source level tools. The Clang Static Analyzer is a tool 
that automatically finds bugs in your code, and is a great example of the sort of tool 
that can be built using the Clang frontend as a library to parse C/C++ code."

clang_pkg_file="$pkg_name-$pkg_vers.src.tar.gz"
clang_pkg_urls="http://llvm.org/releases/$pkg_vers/$clang_pkg_file"

pkg_file="llvm-$pkg_vers.src.tar.gz"
pkg_urls="http://llvm.org/releases/$pkg_vers/$pkg_file"
pkg_opts="configure -MBUILD_EXAMPLES=0"
pkg_reqs="libffi/latest"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--enable-optimized --enable-jit --enable-targets=all --enable-libffi" 

####################################################################################################

function bldr_pkg_fetch_method()
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

     if [[ $(bldr_log_info $pkg_opts | grep -c 'skip-fetch' ) > 0 ]]
     then
        return
     fi

     # Fetch the base LLVM source tree for the selected CLANG version
     #
     bldr_fetch_pkg                  \
       --category    "$pkg_ctry"     \
       --name        "$pkg_name"     \
       --version     "$pkg_vers"     \
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

    bldr_push_dir "$BLDR_CACHE_PATH"
    if [ ! -e "$BLDR_CACHE_PATH/$clang_pkg_file" ]
    then
        bldr_download_pkg "$pkg_name" "$pkg_vers" "$clang_pkg_urls" "$clang_pkg_file" "$use_verbose"
    fi
    bldr_pop_dir

    # extract any pkg archives
    bldr_log_info "Checking package '$BLDR_CACHE_PATH/$clang_pkg_file'"
    bldr_log_split

    if [[ $(bldr_is_valid_archive "$BLDR_CACHE_PATH/$clang_pkg_file") > 0 ]]
    then
        bldr_copy_file "$BLDR_CACHE_PATH/$clang_pkg_file" "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/tools/$clang_pkg_file"

        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/tools"
        local archive_listing=$(bldr_list_archive $clang_pkg_file)

        bldr_log_info "Extracting package '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/tools/$clang_pkg_file' as '$archive_listing'"

        if [ $BLDR_VERBOSE == false ]
        then
            bldr_log_split
        fi

        bldr_extract_archive "$clang_pkg_file" 
        bldr_move_file "$archive_listing" "clang"
        bldr_remove_file "$clang_pkg_file"
        bldr_pop_dir
    fi
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


