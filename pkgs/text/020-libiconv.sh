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
pkg_opts="configure -M-f -MMakefile.devel"
pkg_reqs="zlib/latest libunistring/latest gperf/latest"
pkg_uses="$pkg_reqs"
pkg_cfg="--enable-static --enable-shared --enable-extra-encodings" 
pkg_cflags=""
pkg_ldflags=""

####################################################################################################

function bldr_compile_pkg()
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

    if [[ $(bldr_has_cfg_option "$pkg_opts" "skip-compile" ) == "true" ]]
    then
        return
    fi

    if [ ! -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_warning "Build directory not found for '$pkg_name/$pkg_vers'!  Skipping 'compile' stage ..."
        bldr_log_split
        return
    fi

    # setup the build and prep for the compile
    #
    bldr_log_subsection "Building package '$pkg_name/$pkg_vers' ..."

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_path=$(bldr_locate_config_path $pkg_cfg_path $pkg_opts)
    local cfg_cmd=$(bldr_locate_config_script $pkg_cfg_path $pkg_opts)
    local build_path=$(bldr_locate_build_path $pkg_cfg_path $pkg_opts)
    bldr_pop_dir
    
    bldr_log_info "Moving to build path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path"

    if [[ $(bldr_has_cfg_option "$pkg_opts" "force-serial-build" ) == "true" ]]
    then
        bldr_log_info "Forcing serial build for '$pkg_name/$pkg_vers' ..."
        bldr_log_split
        BLDR_PARALLEL=false
    fi
    
    if [[ $(bldr_has_pkg --category "internal" --name "make" --version "3.8.2" ) == "false" ]]
    then
        BLDR_PARALLEL=false
    fi

    local defines=""
    local output=$(bldr_get_stdout)
    local options="--stop"

    if [[ $BLDR_VERBOSE != true ]]
    then
        options="--quiet $options"
    fi

    if [[ $BLDR_PARALLEL == true ]]
    then
        local procs=2
        if [[ $BLDR_SYSTEM_IS_OSX == true ]]
        then
            procs=$(sysctl -n hw.ncpu)
        fi
        if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
        then
            procs=$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)
        fi
        options="-j$procs $options"
    fi

    # append any -M directives as macros to the make command (eg. -MMAKE_EXAMPLES=0 -> MAKE_EXAMPLES=0)
    if [[ $(echo "$pkg_opts" | grep -m1 -c '\-M') > 0 ]]
    then
        local def=""
        defines=$(echo $pkg_opts | grep -E -o "\-M(\S+)\s*" | sed 's/-M//g' )
        for def in ${defines}
        do
            options="$options $def"
        done
    fi

     if [ $BLDR_SYSTEM_IS_OSX == true ]
     then
        bldr_run_cmd "make -f Makefile.devel $options" || bldr_bail "Failed to build package: '$prefix'"
     fi

     bldr_run_cmd "make check $options" || bldr_bail "Failed to build package: '$prefix'"
     bldr_run_cmd "make install $options" || bldr_bail "Failed to build package: '$prefix'"
    bldr_pop_dir
}


####################################################################################################
# build and install pkg as local module
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
  bldr_log_warning "$pkg_name uses the native OSX version bundled with MacOSX.  Skipping..."
  bldr_log_split
else
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
fi

