#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="science"
pkg_name="gsl"
pkg_vers="1.15"

pkg_info="The GNU Scientific Library (GSL) is a numerical library for C and C++ programmers."

pkg_desc="The GNU Scientific Library (GSL) is a numerical library for C and C++ programmers. 
It is free software under the GNU General Public License. The library provides a wide range of 
mathematical routines such as random number generators, special functions and least-squares 
fitting. There are over 1000 functions in total with an extensive test suite."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://ftp.gnu.org/gnu/gsl/$pkg_file"
pkg_opts="configure"
pkg_uses="m4/latest autoconf/latest automake/latest"
pkg_reqs=""
pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################

function bldr_pkg_compile_method()
{
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""

    while true ; do
        case "$1" in
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    local prefix="$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile)
    bldr_pop_dir

    local output=$(bldr_get_stdout)  

    # build using make if a makefile exists
    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"
    echo "Moving to '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path'"
    if [ -f "Makefile" ] || [ -f "$make_path/Makefile" ]
    then
        bldr_output_hline
        ln -sv "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers" "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/gsl"
        bldr_output_hline
        bldr_report "Building package '$pkg_name'"
        bldr_output_hline
        eval make PREFIX="$prefix" $output || bldr_bail "Failed to build package: '$prefix'"
        bldr_output_hline
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


