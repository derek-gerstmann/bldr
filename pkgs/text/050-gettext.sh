#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="gettext"

pkg_default="0.18.1.1"
pkg_variants=("0.18.1.1")

pkg_info="GNU gettext is designed to minimize the impact of internationalization on program sources."

pkg_desc="GNU gettext is designed to minimize the impact of internationalization on program sources, 
keeping this impact as small and hardly noticeable as possible. Internationalization has better 
chances of succeeding if it is very light weighted, or at least, appear to be so, when looking at 
program sources.

The Translation Project also uses the GNU gettext distribution as a vehicle for documenting its 
structure and methods. This goes beyond the strict technicalities of documenting the GNU gettext 
proper. By so doing, translators will find in a single place, as far as possible, all they need 
to know for properly doing their translating work. Also, this supplemental documentation might 
also help programmers, and even curious users, in understanding how GNU gettext is related to the 
remainder of the Translation Project, and consequently, have a glimpse at the big picture."

pkg_opts="configure "
pkg_opts+="enable-static "
pkg_opts+="enable-shared "

pkg_reqs="coreutils "
pkg_reqs+="zlib "
pkg_reqs+="libicu "
pkg_reqs+="libunistring "
pkg_reqs+="expat "
pkg_reqs+="libxml2 "
pkg_reqs+="libiconv "
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

pkg_cfg="--with-gnu-ld "
pkg_cfg+="--without-emacs "
pkg_cfg+="--disable-rpath "
pkg_cfg+="--with-included-libunistring "
pkg_cfg+="--with-included-libcroco "
pkg_cfg+="--with-libunistring-prefix=\"$BLDR_LIBUNISTRING_BASE_PATH\" "
pkg_cfg+="--with-libexpat-prefix=\"$BLDR_EXPAT_BASE_PATH\" "
pkg_cfg+="--with-libxml2-prefix=\"$BLDR_LIBXML2_BASE_PATH\" "
pkg_cfg+="--with-libiconv-prefix=\"$BLDR_LIBICONV_BASE_PATH\" "

pkg_patch=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://ftp.gnu.org/pub/gnu/gettext/$pkg_file"

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


