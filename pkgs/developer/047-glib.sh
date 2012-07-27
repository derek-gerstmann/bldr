#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="glib"
pkg_vers="2.32.1"
pkg_info="GLib provides the core application building blocks for libraries and applications written in C."

pkg_desc="GLib provides the core application building blocks for libraries and applications written in C. 
It provides the core object system used in GNOME, the main loop implementation, and a large set of 
utility functions for strings and common data structures."

pkg_file="$pkg_name-$pkg_vers.tar.xz"
pkg_urls="http://ftp.gnome.org/pub/GNOME/sources/glib/2.32/$pkg_file"
pkg_opts="configure"
pkg_reqs="pkg-config/latest zlib/latest libiconv/latest libicu/latest libxml2/latest libffi/latest gettext/latest"
pkg_uses="tar/latest tcl/latest m4/latest autoconf/latest automake/latest $pkg_reqs"

pkg_cflags="-m64 -I$BLDR_LOCAL_PATH/internal/zlib/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/libicu/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/libffi/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/gettext/latest/include"
pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/gettext/latest/share/gettext"

pkg_ldflags="-L$BLDR_LOCAL_PATH/internal/zlib/latest/lib:-lz"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/libffi/latest/lib:-lffi"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/libicu/latest/lib"
pkg_ldflags="$pkg_ldflags:-licudata:-licui18n:-licuio:-licule:-liculx:-licutest:-licutu:-licuuc"
pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/gettext/latest/lib:-lasprintf:-lgettextpo"

pkg_cfg=""
pkg_cfg="$pkg_cfg --disable-maintainer-mode"
pkg_cfg="$pkg_cfg --disable-dependency-tracking"
pkg_cfg="$pkg_cfg --disable-dtrace" 


if [ $BLDR_SYSTEM_IS_OSX -eq 1 ]
then
     pkg_cfg="$pkg_cfg --with-libiconv-prefix=/usr"
     pkg_cflags="$pkg_cflags:-I/usr/local/include:-I/usr/include"
     pkg_ldflags="$pkg_ldflags:-L/usr/local/lib:-L/usr/lib:-lintl"
else
     pkg_reqs="$pkg_reqs libiconv/latest"
     pkg_cfg="$pkg_cfg --with-libiconv-prefix=$BLDR_LOCAL_PATH/internal/libiconv/latest"
     pkg_cflags="$pkg_cflags:-I$BLDR_LOCAL_PATH/internal/libiconv/latest/include"
     pkg_ldflags="$pkg_ldflags:-L$BLDR_LOCAL_PATH/internal/libiconv/latest/lib"
fi


pkg_patch=""

####################################################################################################

# function bldr_pkg_config_method()
function foo()
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

     if [[ $(bldr_log_info $pkg_opts | grep -c 'skip-config' ) > 0 ]]
     then
        return
     fi

     if [ $BLDR_SYSTEM_IS_OSX -eq 1 ]
     then
          local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
          bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
          local cfg_path=$(bldr_locate_config_path $pkg_cfg_path)
          bldr_pop_dir

          bldr_log_info "Moving to config path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path' ..."
          bldr_log_split
          bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"
          bldr_pop_dir
     fi

     # call the standard BLDR config method
     #
     bldr_config_pkg                  \
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
    
     if [ $BLDR_SYSTEM_IS_OSX -eq 1 ]
     then
          local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
          bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
          local cfg_path=$(bldr_locate_config_path $pkg_cfg_path)
          bldr_pop_dir

          bldr_log_info "Moving to config path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path' ..."
          bldr_log_split
          bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"

          bldr_log_header "Patching package '$pkg_name/$pkg_vers' ..."
          bldr_log_split

          if [ -f "$BLDR_PATCHES_PATH/$pkg_name/$pkg_vers/osx/config.h.in.ed" ]
          then
               bldr_apply_patch "$BLDR_PATCHES_PATH/$pkg_name/$pkg_vers/osx/config.h.in.ed"
          fi
          bldr_pop_dir
     fi
}

####################################################################################################
# build and install pkg as local module
####################################################################################################


# if [ $BLDR_SYSTEM_IS_OSX -eq 1 ]
# then
#    bldr_log_status "$pkg_name $pkg_ver is not building on OSX right now.  Skipping..."
#    bldr_log_split
# else
    bldr_build_pkg --category    "developer"    \
                   --name        "$pkg_name"    \
                   --version     "$pkg_vers"    \
                   --info        "$pkg_info"    \
                   --description "$pkg_desc"    \
                   --file        "$pkg_file"    \
                   --url         "$pkg_urls"    \
                   --uses        "$pkg_uses"    \
                   --requires    "$pkg_reqs"    \
                   --options     "$pkg_opts"    \
                   --patch       "$pkg_patch"   \
                   --cflags      "$pkg_cflags"  \
                   --ldflags     "$pkg_ldflags" \
                   --config      "$pkg_cfg"
# fi

