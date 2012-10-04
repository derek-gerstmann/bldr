#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="atlas"

pkg_info="ATLAS provides highly optimized Linear Algebra kernels for arbitrary cache-based architectures."

pkg_desc="ATLAS (Automatically Tuned Linear Algebra Software) provides highly optimized 
Linear Algebra kernels for arbitrary cache-based architectures. ATLAS provides ANSI C 
and Fortran77 interfaces for the entire BLAS API, and a small portion of the LAPACK API."

pkg_vers_dft="3.10.0"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure use-build-dir skip-system-flags skip-auto-compile-flags force-serial-build skip-install"
pkg_reqs="gfortran"
pkg_uses=""

pkg_cfg="-b 64 --with-netlib-lapack-tarfile=$BLDR_CACHE_PATH/lapack-3.4.1.tgz --shared"
pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
    pkg_cfg="$pkg_cfg -Fa al '-fPIC'"
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

    if [[ $(echo $pkg_opts | grep -c 'skip-compile' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path="build"

    bldr_log_info "Moving to build path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$make_path' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"

    local output=$(bldr_get_stdout)
    local options="--stop"
    if [ $BLDR_VERBOSE != true ]
    then
        options="--quiet $options"
    fi

    local mk_cmd=""
    local mk_cmd_list="make build check ptcheck time install"
    if [ -f "./Makefile" ]
    then
        bldr_log_status "Building package '$pkg_name/$pkg_vers'"
        bldr_log_split

        for mk_cmd in ${mk_cmd_list}
        do        
            if [ "$mk_cmd" == "make" ]
            then 
                mk_cmd=""
            fi

            bldr_log_cmd "make $mk_cmd $options"
            bldr_log_split

            if [ $BLDR_VERBOSE != false ]
            then
                eval make $mk_cmd $options || bldr_bail "Failed to install package: '$prefix'"
                bldr_log_split
            else
                eval make $mk_cmd $options &> /dev/null || bldr_bail "Failed to install package: '$prefix'"
                bldr_log_split
            fi
        done
    fi
    bldr_pop_dir
}

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name$pkg_vers.tar.bz2"
    pkg_urls="http://downloads.sourceforge.net/project/math-atlas/Stable/$pkg_vers/$pkg_file?use_mirror=aarnet"

    bldr_register_pkg                  \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
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
