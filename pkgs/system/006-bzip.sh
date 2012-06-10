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
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--disable-shared --enable-static"

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

    # build using make if a makefile exists
    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"
    echo "Moving to '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path'"
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

    # build using make if a makefile exists
    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"
    echo "Moving to '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path'"
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

bldr_build_pkg --category    "system"       \
               --name        "$pkg_name"    \
               --version     "$pkg_vers"    \
               --info        "$pkg_info"    \
               --description "$pkg_desc"    \
               --file        "$pkg_file"    \
               --url         "$pkg_urls"    \
               --requires    "$pkg_reqs"    \
               --options     "$pkg_opts"    \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"

