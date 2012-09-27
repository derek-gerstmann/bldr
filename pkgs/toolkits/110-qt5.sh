#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="toolkits"
pkg_name="qt"
pkg_vers="5.0.0-beta"
pkg_info="Qt is a cross-platform application and UI framework for developers using C++ or QML, 
a CSS & JavaScript like language."

pkg_desc="Qt is a cross-platform application and UI framework for developers using C++ or QML, 
a CSS & JavaScript like language"

pkg_file="$pkg_name-everywhere-opensource-src-$pkg_vers.tar.gz"
pkg_urls="git://gitorious.org/qt/qt5.git"
pkg_opts="configure skip-auto-compile-flags use-build-script=build"

pkg_reqs=""
pkg_reqs="$pkg_reqs zlib/latest"
pkg_reqs="$pkg_reqs bison/latest"
pkg_reqs="$pkg_reqs flex/latest"
pkg_reqs="$pkg_reqs gperf/latest"
pkg_reqs="$pkg_reqs openssl/latest"
pkg_reqs="$pkg_reqs libicu/latest"
pkg_reqs="$pkg_reqs libiconv/latest"
pkg_reqs="$pkg_reqs libedit/latest"
pkg_reqs="$pkg_reqs perl/latest"
pkg_reqs="$pkg_reqs python/2.7.3"
pkg_reqs="$pkg_reqs libtiff/latest"
pkg_reqs="$pkg_reqs libjpeg/latest"
pkg_reqs="$pkg_reqs libpng/latest"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################


pkg_cflags=""
pkg_ldflags=""

pkg_cfg="-opensource -release -continue -silent -confirm-license -fast" 

if [ $BLDR_SYSTEM_IS_OSX == true ]
then
     pkg_cfg="$pkg_cfg -arch $BLDR_OSX_ARCHITECTURES" 
fi

pkg_cfg="$pkg_cfg -make libs"
pkg_cfg="$pkg_cfg -make tools"
# pkg_cfg="$pkg_cfg -no-webkit"
# pkg_cfg="$pkg_cfg -no-libmng"
pkg_cfg="$pkg_cfg -system-libjpeg"
# pkg_cfg="$pkg_cfg -system-libtiff"
pkg_cfg="$pkg_cfg -system-libpng"
pkg_cfg="$pkg_cfg -qt-zlib"
pkg_cfg="$pkg_cfg -openssl-linked"
pkg_cfg="$pkg_cfg -I \"$BLDR_ZLIB_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_FLEX_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_OPENSSL_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBICU_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBICONV_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBEDIT_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBTIFF_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBJPEG_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -I \"$BLDR_LIBPNG_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_ZLIB_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_BISON_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_FLEX_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_OPENSSL_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBICU_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBICONV_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBEDIT_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBTIFF_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBJPEG_LIB_PATH\""
pkg_cfg="$pkg_cfg -L \"$BLDR_LIBPNG_LIB_PATH\""

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

    local pwd_path="$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_path=$(bldr_locate_config_path "$pkg_cfg_path" "$pkg_opts")
    local cfg_cmd=$(bldr_locate_config_script "$pkg_cfg_path" "$pkg_opts")
    local boot_path=$(bldr_locate_boot_path "$pkg_cfg_path")
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"

    bldr_run_cmd "perl init-repository"
    bldr_log_split

    unset QTDIR
    export PATH="$pwd_path/qtbase/bin:$pwd_path/qtrepotools/bin:$PATH"

    bldr_pop_dir

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

    local pwd_path="$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_log_info "Moving to build path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_log_status "Building package '$pkg_name/$pkg_vers'"
    bldr_log_split    

    blr_run_cmd "build -j 4"
    bldr_pop_dir
}

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg                    \
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

