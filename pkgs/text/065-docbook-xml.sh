#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="text"
pkg_name="docbook-xml"

pkg_default="4.5"
pkg_variants=("4.5")

pkg_info="The DocBook XML DTD-4.5 package contains document type definitions for verification of XML data files against the DocBook rule set."

pkg_desc="The DocBook XML DTD-4.5 package contains document type definitions for verification 
of XML data files against the DocBook rule set. These are useful for structuring books 
and software documentation to a standard allowing you to utilize transformations already 
written for that standard."

pkg_opts="configure "
pkg_opts+="skip-compile "
pkg_opts+="skip-boot "
pkg_opts+="skip-config "

pkg_reqs="libtool "
pkg_reqs+="coreutils "
pkg_reqs+="zlib "
pkg_reqs+="gzip "
pkg_reqs+="libxml2 "
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

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
     
     bldr_make_dir "$prefix/share/xml"
     bldr_log_split
     
     bldr_make_dir "$prefix/doc"
     bldr_log_split

     local install_cmd="cp -v -af docbook.cat *.dtd ent/ *.mod $prefix/share/xml"

     bldr_run_cmd "$install_cmd" || bldr_bail "Failed to install package: '$prefix'"

     bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//DTD DocBook XML V4.5//EN\" \"http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//DTD DocBook XML CALS Table Model V4.5//EN\" \"file://$prefix/share/xml/calstblx.dtd\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//DTD XML Exchange Table Model 19990315//EN\" \"file://$prefix/share/xml/soextblx.dtd\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//ELEMENTS DocBook XML Information Pool V4.5//EN\" \"file://$prefix/share/xml/dbpoolx.mod\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.5//EN\" \"file://$prefix/share/xml/dbhierx.mod\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//ELEMENTS DocBook XML HTML Tables V4.5//EN\" \"file://$prefix/share/xml/htmltblx.mod\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//ENTITIES DocBook XML Notations V4.5//EN\" \"file://$prefix/share/xml/dbnotnx.mod\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//ENTITIES DocBook XML Character Entities V4.5//EN\" \"file://$prefix/share/xml/dbcentx.mod\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//ENTITIES DocBook XML Additional General Entities V4.5//EN\" \"file://$prefix/share/xml/dbgenent.mod\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"rewriteSystem\" \"http://www.oasis-open.org/docbook/xml/4.5\" \"file:///$prefix/share/xml\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"rewriteURI\" \"http://www.oasis-open.org/docbook/xml/4.5\" \"file:///$prefix/share/xml\" \"${XML_DOCBOOK_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"delegatePublic\" \"-//OASIS//ENTITIES DocBook XML\" \"file:///${XML_DOCBOOK_FILES}\" \"${XML_CATALOG_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"delegatePublic\" \"-//OASIS//DTD DocBook XML\" \"file:///${XML_DOCBOOK_FILES}\" \"${XML_CATALOG_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"delegateSystem\" \"http://www.oasis-open.org/docbook/\" \"file:///${XML_DOCBOOK_FILES}\" \"${XML_CATALOG_FILES}\""
     bldr_run_cmd "xmlcatalog --noout --add \"delegateURI\" \"http://www.oasis-open.org/docbook/\" \"file:///${XML_DOCBOOK_FILES}\" \"${XML_CATALOG_FILES}\""

     for DTDVERSION in 4.1.2 4.2 4.3 4.4
     do
          bldr_run_cmd "xmlcatalog --noout --add \"public\" \"-//OASIS//DTD DocBook XML V$DTDVERSION//EN\" \"http://www.oasis-open.org/docbook/xml/$DTDVERSION/docbookx.dtd\" \"${XML_DOCBOOK_FILES}\""
          bldr_run_cmd "xmlcatalog --noout --add \"rewriteSystem\" \"http://www.oasis-open.org/docbook/xml/$DTDVERSION\" \"file:///$prefix/share/xml\" \"${XML_DOCBOOK_FILES}\""
          bldr_run_cmd "xmlcatalog --noout --add \"rewriteURI\" \"http://www.oasis-open.org/docbook/xml/$DTDVERSION\" \"file:///$prefix/share/xml\" \"${XML_DOCBOOK_FILES}\""
          bldr_run_cmd "xmlcatalog --noout --add \"delegateSystem\" \"http://www.oasis-open.org/docbook/xml/$DTDVERSION/\" \"file:///${XML_DOCBOOK_FILES}\" \"${XML_CATALOG_FILES}\""
          bldr_run_cmd "xmlcatalog --noout --add \"delegateURI\" \"http://www.oasis-open.org/docbook/xml/$DTDVERSION/\" \"file:///${XML_DOCBOOK_FILES}\" \"${XML_CATALOG_FILES}\""
     done

     bldr_pop_dir
}

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.zip"
    pkg_urls="http://www.docbook.org/xml/$pkg_vers/$pkg_file"

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


