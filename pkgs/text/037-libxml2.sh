#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="libxml2"
pkg_default="2.8.0"
pkg_variants=("2.8.0")

pkg_info="Libxml2 is the XML C parser and toolkit developed for the Gnome project"

pkg_desc="Libxml2 is the XML C parser and toolkit developed for the Gnome project 
(but usable outside of the Gnome platform), it is free software available under 
the MIT License. XML itself is a metalanguage to design markup languages, i.e. text 
language where semantic and structure are added to the content using extra 'markup' 
information enclosed between angle brackets. HTML is the most well-known markup 
language. Though the library is written in C a variety of language bindings make 
it available in other environments."

pkg_reqs="pkg-config coreutils zlib gzip xz"
pkg_uses="$pkg_reqs"
pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################

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

      if [ "$use_verbose" == "true" ]
      then
          BLDR_VERBOSE=true
      fi

      local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

      # call the standard BLDR install method
      #
      bldr_install_pkg                 \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_default"\
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

      # create a stub XML catalog file for shared use
      #
      bldr_make_dir "$prefix/etc/xml"
      bldr_log_split

      bldr_push_dir "$prefix"
      bldr_run_cmd "./bin/xmlcatalog --noout --create ./etc/xml/catalog"
      bldr_run_cmd "./bin/xmlcatalog --noout --create ./etc/xml/docbook"
      bldr_pop_dir
}

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://xmlsoft.org/sources/$pkg_file"

    pkg_opts="configure"
    pkg_opts+=" -EXML_CATALOG_FILES=\"$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers/etc/xml/catalog\""
    pkg_opts+=" -EXML_DOCBOOK_FILES=\"$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers/etc/xml/docbook\""

    bldr_register_pkg                \
        --category    "$pkg_ctry"    \
        --name        "$pkg_name"    \
        --version     "$pkg_vers"    \
        --default     "$pkg_default"\
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
