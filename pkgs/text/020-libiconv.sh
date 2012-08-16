#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="libiconv"
pkg_vers="1.14"

pkg_info="The GNU libiconv library provides utilities for converting text from/to Unicode via the iconv() method."

pkg_desc="The GNU libiconv library provides utilities for converting text from/to Unicode via the iconv() method.

For historical reasons, international text is often encoded using a language or country dependent 
character encoding. With the advent of the internet and the frequent exchange of text across 
countries - even the viewing of a web page from a foreign country is a 'text exchange' in this 
context -, conversions between these encodings have become important. They have also become a problem, 
because many characters which are present in one encoding are absent in many other encodings. To 
solve this mess, the Unicode encoding has been created. It is a super-encoding of all others and 
is therefore the default encoding for new text formats like XML.

Still, many computers still operate in locale with a traditional (limited) character encoding. 
Some programs, like mailers and web browsers, must be able to convert between a given text encoding 
and the user's encoding. Other programs internally store strings in Unicode, to facilitate internal 
processing, and need to convert between internal string representation (Unicode) and external 
string representation (a traditional encoding) when they are doing I/O. GNU libiconv is a 
conversion library for both kinds of applications. "

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/pub/gnu/libiconv/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest libunistring/latest gperf/latest"
pkg_uses="$pkg_reqs"
pkg_cfg="--enable-static --enable-shared --enable-extra-encodings" 
pkg_cflags=""
pkg_ldflags=""

####################################################################################################

# OSX >= 10.6 ships with GNU libiconv w/tons of proprietary (unknown) patches 
# -- just copy that version into our local tree
#
if [ $BLDR_SYSTEM_IS_OSX == true ]
then
    pkg_opts="$pkg_opts skip-fetch skip-boot skip-config skip-install migrate-build-tree"
fi

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
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    # call the standard BLDR compile method
    #
    if [[ $BLDR_SYSTEM_IS_OSX == false ]]
    then
        bldr_compile_pkg                 \
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
            --cflags      "$pkg_cflags"  \
            --ldflags     "$pkg_ldflags" \
            --config      "$pkg_cfg"     \
            --config-path "$pkg_cfg_path"\
            --patch       "$pkg_patches" \
            --verbose     "$use_verbose"
            return
    fi
    
    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local build_path=$(bldr_locate_build_path $pkg_cfg_path)
    bldr_pop_dir

    # handle OSX specific build setup
    #
    bldr_make_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    bldr_log_split

    bldr_make_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib"
    bldr_make_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include"

    local fnd_lib=""
    local fnd_lst=$(find /usr/lib/* -type f -iname "libiconv*")
    for fnd_lib in ${fnd_lst}
    do
        bldr_copy_file "$fnd_lib" "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib"
    done

    local fnd_lst=$(find /usr/lib/* -type l -iname "libiconv*")
    for fnd_lib in ${fnd_lst}
    do
        local fnd_lnk=$(readlink $fnd_lib)
        local fnd_base=$(basename $fnd_lib)
        bldr_copy_file "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib/$fnd_lnk" "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib/$fnd_base"
    done

    local fnd_hdr=""
    local fnd_lst=$(find /usr/include/* -type f -iname "*iconv*")
    for fnd_lib in ${fnd_lst}
    do
        bldr_copy_file "$fnd_lib" "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include"
    done

    bldr_log_split
    bldr_pop_dir
}

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                 \
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
  --cflags      "$pkg_cflags"  \
  --ldflags     "$pkg_ldflags" \
  --config      "$pkg_cfg"

