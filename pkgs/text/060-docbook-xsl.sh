#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="docbook-xsl"

pkg_info="DocBook is an XML vocabulary that lets you create documents in a presentation-neutral form that captures the logical structure of your content."

pkg_desc="DocBook is an XML vocabulary that lets you create documents in a 
presentation-neutral form that captures the logical structure of your content. 

Using free tools along with the DocBook XSL stylesheets, you can publish your 
content as HTML pages and PDF files, and in many other formats."

pkg_vers_dft="1.77.1"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure skip-compile skip-boot skip-config"
pkg_reqs="pkg-config coreutils zlib gzip libxml2"
pkg_uses="$pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg=""
pkg_patch=""

####################################################################################################

function bldr_pkg_install_method()
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
     bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

     bldr_log_subsection "Installing package '$pkg_name/$pkg_vers' for '$pkg_ctry' ..."
     
     bldr_make_dir "$prefix/share/xsl"
     bldr_log_split
     
     bldr_make_dir "$prefix/doc"
     bldr_log_split

     local install_cmd="cp -v -R VERSION common eclipse epub extensions fo highlighting html \
         htmlhelp images javahelp lib manpages params profiling \
         roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 $prefix/share/xsl"

     bldr_run_cmd "$install_cmd" || bldr_bail "Failed to install package: '$prefix'"
     bldr_copy_file "README" "$prefix/doc/README.xsl" 
     bldr_copy_file "NEWS*" "$prefix/doc" 
     bldr_copy_file "RELEASE-NOTES*" "$prefix/doc" 

     bldr_run_cmd "xmlcatalog --noout --add \"rewriteSystem\" \"http://docbook.sourceforge.net/release/xsl/$pkg_vers\" \"$prefix/share/xsl\" \"${XML_CATALOG_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"rewriteURI\" \"http://docbook.sourceforge.net/release/xsl/$pkg_vers\" \"$prefix/share/xsl\" \"${XML_CATALOG_FILES}\""

     bldr_run_cmd "xmlcatalog --noout --add \"rewriteSystem\" \"http://docbook.sourceforge.net/release/xsl/current\" \"$prefix/share/xsl\" \"${XML_CATALOG_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"rewriteURI\" \"http://docbook.sourceforge.net/release/xsl/current\" \"$prefix/share/xsl\" \"${XML_CATALOG_FILES}\""

     bldr_pop_dir
}

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.bz2"
    pkg_urls="http://downloads.sourceforge.net/project/docbook/$pkg_name/$pkg_vers/$pkg_file"

    bldr_register_pkg                \
        --category    "$pkg_ctry"    \
        --name        "$pkg_name"    \
        --version     "$pkg_vers"    \
        --default     "$pkg_vers_dft"\
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


