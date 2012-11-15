#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="services"
pkg_name="ramcloud"

pkg_default="trunk"
pkg_variants=("trunk")
pkg_mirrors=("git://fiz.stanford.edu/git/ramcloud.git")

pkg_info="RAMCloud is a low-latency, high-performance, strongly-consistent distributed storage service."

pkg_desc="The RAMCloud project is creating a new class of storage, based entirely in DRAM, 
that is 2-3 orders of magnitude faster than existing storage systems. If successful, it will 
enable new applications that manipulate large-scale datasets much more intensively than has 
ever been possible before. In addition, we think RAMCloud, or something like it, will become 
the primary storage system for cloud computing environments such as Amazon's AWS and Microsoft's 
Azure.

The role of DRAM in storage systems has been increasing rapidly in recent years, driven by the 
needs of large-scale Web applications. These applications manipulate very large datasets with 
an intensity that cannot be satisfied by disks alone. As a result, applications are keeping 
more and more of their data in DRAM. For example, large-scale caching systems such as memcached 
are being widely used (in 2009 Facebook used a total of 150 TB of DRAM in memcached and other 
caches for a database containing 200 TB of disk storage), and the major Web search engines 
now keep their search indexes entirely in DRAM."

pkg_opts="configure "
pkg_reqs="scons "
pkg_reqs+="zlib "
pkg_reqs+="bzip2 "
pkg_reqs+="pcre "
pkg_reqs+="libevent "
pkg_reqs+="protobuf "
pkg_uses="$pkg_uses"

pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""

####################################################################################################

function bldr_pkg_config_method()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_vers_dft=""
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
           --default)       pkg_vers_dft="$2"; shift 2;;
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

    bldr_config_pkg                   \
        --info        "$pkg_info"     \
        --description "$pkg_desc"     \
        --category    "$pkg_ctry"     \
        --name        "$pkg_name"     \
        --version     "$pkg_vers"     \
        --default     "$pkg_vers_dft" \
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

    bldr_log_subsection "Configuring package '$pkg_name/$pkg_vers' using '$cfg_cmd' ..."

    bldr_run_cmd "git submodule update --init --recursive"
    bldr_run_cmd "make logcabin"

    bldr_pop_dir

}

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.gz"
    pkg_urls="${pkg_mirrors[$pkg_idx]}"

    bldr_register_pkg                 \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_default" \
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

    let pkg_idx++         
done

####################################################################################################

