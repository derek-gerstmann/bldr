#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="ftb"
pkg_vers="0.6.2"

pkg_info="FTB is a facility for Checkpoint-Restart and Job Pause-Migration-Restart Frameworks."

pkg_desc="Fault Tolerance Backplane (FTB) can be used for Checkpoint-Restart and Job Pause-Migration-Restart Frameworks. 

FTB has been developed and standardized by the CIFTS project. It enables faults to be handled in a coordinated 
and holistic manner in the entire system, providing for an infrastructure which can be used by 
different software systems to exchange fault-related information."

pkg_file="$pkg_name-$pkg_vers.tgz"
pkg_urls="http://www.mcs.anl.gov/research/cifts/software/$pkg_file"
pkg_opts="configure force-bootstrap force-serial-build"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--enable-static --enable-shared --with-platform=linux"

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
    local pkg_patches=""
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

   bldr_boot_pkg                     \
       --info        "$pkg_info"     \
       --description "$pkg_desc"     \
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

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"


    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    bldr_run_cmd "./autogen.sh clean"
    bldr_run_cmd "./autogen.sh"
    bldr_pop_dir

    bldr_log_status "Done booting package '$pkg_name/$pkg_vers' for '$pkg_ctry' ... "

}

####################################################################################################
# build and install pkg as local module
####################################################################################################

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     bldr_log_warning "$pkg_name isn't supported on MacOSX.  Skipping..."
     bldr_log_split
else
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
fi

