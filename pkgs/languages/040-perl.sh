#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ver_list=("5.16.1")
pkg_ctry="languages"
pkg_name="perl"

pkg_info="Perl is a high-level, general-purpose, interpreted, dynamic programming language."

pkg_desc="Perl is a high-level, general-purpose, interpreted, dynamic programming language.

Though Perl is not officially an acronym,there are various backronyms in usage, such as: 

  Practical Extraction and Reporting Language.

Perl was originally developed by Larry Wall in 1987 as a general-purpose Unix scripting 
language to make report processing easier.  Since then, it has undergone many changes 
and revisions and become widely popular amongst programmers.

Perl borrows features from other programming languages including C, shell scripting (sh), 
AWK, and sed.[7] The language provides powerful text processing facilities without 
the arbitrary data length limits of many contemporary Unix tools, facilitating easy 
manipulation of text files. Perl gained widespread popularity in the late 1990s as a 
CGI scripting language, in part due to its parsing abilities.

In addition to CGI, Perl is used for graphics programming, system administration, 
network programming, finance, bioinformatics, and other applications. 
Perl is nicknamed 'the Swiss Army chainsaw of scripting languages' because of its 
flexibility and power.

In 1998, it was also referred to as the 'duct tape that holds the Internet together', 
in reference to its ubiquity and perceived inelegance."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://www.cpan.org/src/5.0/$pkg_file"
pkg_opts="configure force-serial-build config-disable-prefix disable-xcode-cflags disable-xcode-ldflags"
pkg_reqs="coreutils/latest tar/latest make/latest"
pkg_uses="$pkg_reqs"
pkg_cfg="-des -Dusethreads"

if [[ $BLDR_SYSTEM_IS_64BIT == true ]]
then
    pkg_cfg="$pkg_cfg -Duse64bitall"
fi
p5_cfg=$pkg_cfg

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_ver_list}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://www.cpan.org/src/5.0/$pkg_file"
    pkg_cfg="$p5_cfg -Dprefix=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

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
done
