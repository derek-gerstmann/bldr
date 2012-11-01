#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="developer"
pkg_name="boost"

pkg_default="1.51"
pkg_variants=("1.49" "1.50" "1.51")
pkg_distribs=("boost_1_49_0.tar.bz2"
              "boost_1_50_0.tar.bz2"
              "boost_1_51_0.tar.bz2")
  
pkg_info="Boost provides free peer-reviewed portable C++ source libraries."

pkg_desc="Boost provides free peer-reviewed portable C++ source libraries.

We emphasize libraries that work well with the C++ Standard Library. 
Boost libraries are intended to be widely useful, and usable across a broad 
spectrum of applications. The Boost license encourages both commercial and 
non-commercial use.

We aim to establish 'existing practice' and provide reference implementations 
so that Boost libraries are suitable for eventual standardization. Ten Boost 
libraries are included in the C++ Standards Committee's Library Technical 
Report (TR1) and in the new C++11 Standard. C++11 also includes several more 
Boost libraries in addition to those from TR1. More Boost libraries are 
proposed for TR2."

bst_opts="configure "
bst_opts+="force-bootstrap "
bst_opts+="skip-config "
bst_opts+="force-static "
bst_opts+="skip-auto-compile-flags "

pkg_reqs="zlib "
pkg_reqs+="bzip2 "
pkg_reqs+="libicu "
pkg_reqs+="openmpi "

pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg="variant=release "
pkg_cfg+="link=static "
pkg_cfg+="threading=single,multi "
pkg_cfg+="runtime-link=static "
pkg_cfg+="--with-mpi "
pkg_cfg+="-s ICU_PATH=\"$BLDR_LIBICU_BASE_PATH\" "
pkg_cfg+="-s BZIP2_INCLUDE=\"$BLDR_BZIP2_INCLUDE_PATH\" "
pkg_cfg+="-s BZIP2_LIBPATH=\"$BLDR_BZIP2_LIB_PATH\" "
pkg_cfg+="-s ZLIB_INCLUDE=\"$BLDR_ZLIB_INCLUDE_PATH\" "
pkg_cfg+="-s ZLIB_LIBPATH=\"$BLDR_ZLIB_LIB_PATH\" "

pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cfg+="cxxflags=-fPIC cflags=-fPIC linkflags=-fPIC "
fi

####################################################################################################

function pkg_run_cmd()
{
    local cmd="${@}"

    bldr_log_cmd "$cmd"

    local ts=$(date "+%Y-%m-%d-%Hh%Mm%Ss")
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    local cmd_log_file="$BLDR_LOG_PATH/bldr_cmd_$ts.log"

    set -o pipefail    
    
    if [[ $BLDR_VERBOSE == true ]]
    then
        bldr_log_split

        (eval "$cmd" 2>&1 | tee -a $cmd_log_file $log_file) || \
            (bldr_log_split ; bldr_log_error "Failed to execute command!  Output follows:" ; \
             bldr_bail_cmd "$(cat $cmd_log_file)")

        bldr_log_split
    else
        (eval "$cmd" 2>&1 | tee -a $cmd_log_file) >> $log_file || \
            (bldr_log_split ; bldr_log_error "Failed to execute command!  Output follows:" ; \
                bldr_bail_cmd "$(cat $cmd_log_file)")
    fi

    rm $cmd_log_file
    bldr_log_split
}


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
           --default)       pkg_default="$2"; shift 2;;
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
    bldr_compile_pkg                 \
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
        --config-path "$pkg_cfg_path"\
        --patch       "$pkg_patches" \
        --verbose     "$use_verbose"
    
    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local build_path=$(bldr_locate_build_path $pkg_cfg_path)
    bldr_pop_dir

    # handle BOOST specific build setup
    #
    local output=$(bldr_get_stdout)  

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path"
    bldr_log_info "Moving to '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path'"
    bldr_log_split

    local env_flags=" "
    pkg_cfg=$(bldr_trim_list_str "$pkg_cfg")
    if [ "$pkg_cfg" != "" ] && [ "$pkg_cfg" != " " ] && [ "$pkg_cfg" != ":" ]
    then
        pkg_cfg=$(echo $pkg_cfg | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_cfg=""
    fi

    pkg_cflags=$(bldr_trim_list_str "$pkg_cflags")
    if [ "$pkg_cflags" != "" ] && [ "$pkg_cflags" != " " ]  && [ "$pkg_cflags" != ":" ]
    then
        pkg_mpath=$(echo $pkg_cflags | bldr_split_str ":" | bldr_join_str ";")
        env_flags='-DCMAKE_PREFIX_PATH="'$pkg_mpath'"'
    else
        pkg_cflags=""
    fi

    pkg_ldflags=$(bldr_trim_list_str "$pkg_ldflags")
    if [ "$pkg_ldflags" != "" ] && [ "$pkg_ldflags" != " " ] && [ "$pkg_ldflags" != ":" ]
    then
        pkg_env=$(echo $pkg_ldflags | bldr_split_str ":" | bldr_join_str " ")
        env_flags=$env_flags' '$pkg_env
    else
        pkg_ldflags=""
    fi

    pkg_run_cmd "./b2 --prefix=\"$prefix\" $pkg_cfg $env_flags"
    pkg_run_cmd "./b2 install"
    bldr_pop_dir
}

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file=${pkg_distribs[$pkg_idx]}
    pkg_urls="http://sourceforge.net/projects/boost/files/$pkg_name/$pkg_vers/$pkg_file/download"

    pkg_opts="$bst_opts "
    pkg_opts+="-EBOOST_ROOT=\"$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers\" "
    pkg_opts+="-EBOOST_INCLUDEDIR=\"$BLDR_BOOST_INCLUDE_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include\" "

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

