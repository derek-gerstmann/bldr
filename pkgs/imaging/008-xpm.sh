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
pkg_vers="3.4k"

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

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="ftp://ftp.x.org/contrib/libraries/$pkg_file"
pkg_opts="configure use-build-makefile=Makefile.noX"
pkg_opts="$pkg_opts -MDESTDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers\""
pkg_opts="$pkg_opts -MMANDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/man\""
pkg_opts="$pkg_opts -MDESTLIBDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/lib\""
pkg_opts="$pkg_opts -MDESTBINDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bin\""
pkg_opts="$pkg_opts -MDESTINCLUDEDIR=\"$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/include\""
pkg_opts="$pkg_opts use-make-envflags"
pkg_opts="$pkg_opts create-local-base-path"
pkg_opts="$pkg_opts create-local-lib-path"
pkg_opts="$pkg_opts create-local-bin-path"
pkg_uses=""
pkg_reqs=""
pkg_cfg="--enable-shared --enable-static"

pkg_cflags=""
pkg_ldflags=""

if [[ $BLDR_SYSTEM_IS_OSX == true ]]; then
     pkg_cflags="$pkg_cflags:-I/opt/X11/include"
     pkg_ldflags="$pkg_ldflags:-L/opt/X11/lib"
elif [[ $BLDR_SYSTEM_IS_LINUX == true ]]; then
     pkg_cflags="$pkg_cflags:-I/usr/include/X11"
     pkg_ldflags="$pkg_ldflags:-L/usr/lib"
fi

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

