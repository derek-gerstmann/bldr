#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="imaging"
pkg_name="xpm"
pkg_default="3.4k"
pkg_variants=("3.4k")

pkg_info="XPM (X PixMap) is a format for storing/retrieving X pixmaps to/from files."

pkg_desc="XPM (X PixMap) is a format for storing/retrieving X pixmaps to/from files.

Here is provided a library containing a set of four functions, similar to the
X bitmap functions as defined in the Xlib: XpmCreatePixmapFromData,
XpmCreateDataFromPixmap, XpmReadFileToPixmap and XpmWriteFileFromPixmap for
respectively including, storing, reading and writing this format, plus four
other: XpmCreateImageFromData, XpmCreateDataFromImage, XpmReadFileToImage and
XpmWriteFileFromImage for working with images instead of pixmaps.

This new version provides a C includable format, defaults for different types
of display: monochrome/color/grayscale, hotspot coordinates and symbol names
for colors for overriding default colors when creating the pixmap. It provides
a mechanism for storing information while reading a file which is re-used
while writing. This way comments, default colors and symbol names aren't lost.
It also handles \"transparent pixels\" by returning a shape mask in addition to
the created pixmap."

pkg_cfg=""
pkg_opts="configure "
pkg_opts+="enable-shared "
pkg_opts+="enable-static "
pkg_opts+="use-build-makefile=Makefile.noX "
pkg_opts+="-MDESTDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers\" "
pkg_opts+="-MMANDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/man\" "
pkg_opts+="-MDESTLIBDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib\" "
pkg_opts+="-MDESTBINDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bin\" "
pkg_opts+="-MDESTINCLUDEDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include\" "
pkg_opts+="use-make-envflags "
pkg_opts+="create-local-base-path "
pkg_opts+="create-local-lib-path "
pkg_opts+="create-local-bin-path "

pkg_uses=""
pkg_reqs=""

pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     pkg_cflags+=":-I/opt/X11/include"
     pkg_ldflags+=":-L/opt/X11/lib"

elif [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
     pkg_cflags+=":-I/usr/include/X11:-fPIC"
     pkg_ldflags+=":-L/usr/lib"
fi

function bldr_pkg_install_method()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_default=""
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

     bldr_install_pkg                \
       --info        "$pkg_info"     \
       --description "$pkg_desc"     \
       --category    "$pkg_ctry"     \
       --name        "$pkg_name"     \
       --version     "$pkg_vers"     \
       --default     "$pkg_default"  \
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

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    bldr_make_dir "$prefix/include/X11"
    bldr_copy_file "$prefix/include/xpm.h" "$prefix/include/X11"
}

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="ftp://ftp.x.org/contrib/libraries/$pkg_file"

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
