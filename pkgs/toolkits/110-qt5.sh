#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="toolkits"
pkg_name="qt5"
pkg_vers="trunk"
pkg_info="Qt is a cross-platform application and UI framework for developers using C++ or QML, 
a CSS & JavaScript like language."

pkg_desc="Qt is a cross-platform application and UI framework for developers using C++ or QML, 
a CSS & JavaScript like language"

# pkg_file="$pkg_name-$pkg_vers-$BLDR_TIMESTAMP.tar.bz2"
pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="git://gitorious.org/qt/qt5.git"
pkg_opts="configure disable-xcode-cflags disable-xcode-ldflags"

pkg_reqs="bison/latest"
pkg_reqs="$pkg_reqs flex/latest"
pkg_reqs="$pkg_reqs gperf/latest"
pkg_reqs="$pkg_reqs openssl/latest"
pkg_reqs="$pkg_reqs libicu/latest"
pkg_reqs="$pkg_reqs libedit/latest"
pkg_reqs="$pkg_reqs perl/latest"
pkg_reqs="$pkg_reqs python/2.7.3"
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-opensource -release -continue -silent -confirm-license"

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     pkg_cfg="$pkg_cfg -arch $BLDR_OSX_ARCHITECTURES" 
     pkg_cfg="$pkg_cfg -no-framework -static"
fi

pkg_cfg="$pkg_cfg -make libs"
pkg_cfg="$pkg_cfg -make tools"

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

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

     bldr_boot_pkg                      \
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

     bldr_log_status "Initialising repository '$pkg_name/$pkg_vers'"
     bldr_log_split

     bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
     local boot_cmd="perl init-repository"
     bldr_run_cmd "$boot_cmd"

     unset QTDIR
     export PATH="$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/qtbase/bin:$PATH"
     export PATH="$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/qtrepotools/bin:$PATH"

     bldr_pop_dir
}

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

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    bldr_compile_pkg                  \
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

    bldr_log_status "Building Webkit for '$pkg_name/$pkg_vers'"
    bldr_log_split

    local build_path="$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local install_path="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    export WEBKITOUTPUTDIR="$prefix/qtwebkit/WebKitBuild"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/qtwebkit"
    local build_cmd="perl Tools/Scripts/build-webkit --qt --qmake=\"$build_path/qtbase/bin/qmake\" --install-libs=\"$install_path/lib\" --makeargs=\"$MAKEFLAGS\""
    bldr_run_cmd "$build_cmd"
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


