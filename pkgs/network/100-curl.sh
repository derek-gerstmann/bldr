#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_name="curl"
pkg_vers="7.26.0"

pkg_info="Curl is a command line tool for transferring data with URL syntax."

pkg_desc="curl is a command line tool for transferring data with URL syntax, 
supporting DICT, FILE, FTP, FTPS, Gopher, HTTP, HTTPS, IMAP, IMAPS, LDAP, 
LDAPS, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMTP, SMTPS, Telnet and TFTP. 
curl supports SSL certificates, HTTP POST, HTTP PUT, FTP uploading, 
HTTP form based upload, proxies, cookies, user+password authentication 
(Basic, Digest, NTLM, Negotiate, kerberos...), file transfer resume, 
proxy tunneling and a busload of other useful tricks."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://curl.haxx.se/download/$pkg_file"
pkg_opts="configure"
pkg_uses="m4/latest autoconf/latest automake/latest libtool/latest zlib/latest"
pkg_reqs=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--enable-optimize --enable-threaded-resolver --enable-nonblocking"

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "network"      \
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

