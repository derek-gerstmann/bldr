#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="deployment"
pkg_name="ant"

pkg_default="1.8.4"
pkg_variants=("1.8.4")

pkg_info="Apache Ant is a Java library and command-line tool that help building software."

pkg_desc="Apache Ant is a Java library and command-line tool that help building software."

ant_opts="ant force-bootstrap skip-install migrate-build-tree"
ant_opts+="use-build-script=build.sh no-bootstrap-prefix "
pkg_reqs=""
pkg_uses=""

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg_path=""

function bldr_pkg_boot_method()
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

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    bldr_make_dir "lib/optional"
    bldr_fetch "https://github.com/downloads/KentBeck/junit/junit-4.11.jar" "lib/optional/junit-4.11.jar"
    bldr_pop_dir


            bldr_boot_pkg                     \
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

    export PATH="$PATH:$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bootstrap/bin"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/$pkg_ctry/$pkg_name/$pkg_vers/bootstap/lib"
    export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/$pkg_ctry/$pkg_name/$pkg_vers/bootstap/lib"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_path=$(bldr_locate_config_path "$pkg_cfg_path" "$pkg_opts")
    local cfg_cmd=$(bldr_locate_config_script "$pkg_cfg_path" "$pkg_opts")
    local boot_path=$(bldr_locate_boot_path "$pkg_cfg_path")
    bldr_pop_dir

}

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
#     pkg_file="apache-ant-$pkg_vers-bin.tar.bz2"
#     pkg_urls="http://mirror.overthewire.com.au/pub/apache/ant/binaries/$pkg_file"

     pkg_file="apache-ant-$pkg_vers-src.tar.bz2"
     pkg_urls="http://apache.mirror.uber.com.au//ant/source/$pkg_file"

     pkg_cfg="-Ddist.dir=$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers dist "

     pkg_opts="$ant_opts"
     pkg_opts+="-EANT_HOME=\"$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers\" "

     bldr_register_pkg                \
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
done

####################################################################################################

