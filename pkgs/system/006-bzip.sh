#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="bzip2"
pkg_vers="1.0.6"

pkg_info="BZIP2 is a freely available, patent free (see below), high-quality data compressor."

pkg_desc="BZIP2 is a freely available, patent free (see below), high-quality data compressor. 
It typically compresses files to within 10% to 15% of the best available techniques 
(the PPM family of statistical compressors), whilst being around twice as fast at 
compression and six times faster at decompression."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.bzip.org/1.0.6/$pkg_file"
pkg_opts="configure:keep"
pkg_reqs="m4/latest autoconf/latest automake/latest"
pkg_cflags=0
pkg_ldflags=0
pkg_cfg="--disable-shared --enable-static"

####################################################################################################

function bldr_pkg_make_method()
{
    local pkg_name="${1}"
    local pkg_vers="${2}"
    local pkg_file="${3}"
    local pkg_urls="${4}"

    local prefix="$BLDR_LOCAL_DIR/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile)
    bldr_pop_dir

    # build using make if a makefile exists
    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_name/$pkg_vers/$make_path"
    echo "Moving to '$BLDR_BUILD_DIR/$pkg_name/$pkg_vers/$make_path'"
    if [ -f "Makefile" ] || [ -f "$make_path/Makefile" ]
    then
        bldr_report "Building package '$pkg_name'"
        bldr_output_hline
        make PREFIX="$prefix" || bldr_bail "Failed to build package: '$prefix'"
        bldr_output_hline
    fi
    bldr_pop_dir
}

function bldr_pkg_install_method()
{
    local pkg_name="${1}"
    local pkg_vers="${2}"
    local pkg_file="${3}"
    local pkg_urls="${4}"

    local prefix="$BLDR_LOCAL_DIR/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile)
    bldr_pop_dir

    # build using make if a makefile exists
    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_name/$pkg_vers/$make_path"
    echo "Moving to '$BLDR_BUILD_DIR/$pkg_name/$pkg_vers/$make_path'"
    if [ -f "Makefile" ] || [ -f "$make_path/Makefile" ]
    then
        bldr_report "Installing package '$pkg_name'"
        bldr_output_hline
        echo "> make install PREFIX=\"$prefix\""
        make PREFIX="$prefix" install || bldr_bail "Failed to build package: '$prefix'"
        bldr_output_hline
    fi
    bldr_pop_dir
}

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg "$pkg_name"    \
               "$pkg_vers"    \
               "$pkg_info"    \
               "$pkg_desc"    \
               "$pkg_file"    \
               "$pkg_urls"    \
               "$pkg_reqs"    \
               "$pkg_opts"    \
               "$pkg_cflags"  \
               "$pkg_ldflags" \
               "$pkg_cfg"

