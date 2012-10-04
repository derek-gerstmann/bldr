#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="network"
pkg_name="curl"

pkg_info="Curl is a command line tool for transferring data with URL syntax."

pkg_desc="curl is a command line tool for transferring data with URL syntax, 
supporting DICT, FILE, FTP, FTPS, Gopher, HTTP, HTTPS, IMAP, IMAPS, LDAP, 
LDAPS, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMTP, SMTPS, Telnet and TFTP. 
curl supports SSL certificates, HTTP POST, HTTP PUT, FTP uploading, 
HTTP form based upload, proxies, cookies, user+password authentication 
(Basic, Digest, NTLM, Negotiate, kerberos...), file transfer resume, 
proxy tunneling and a busload of other useful tricks."

pkg_vers_dft="7.26.0"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_uses="openssl"
pkg_reqs="$pkg_uses"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_vers_dft"\
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--enable-optimize"
pkg_cfg="$pkg_cfg --enable-threaded-resolver"
pkg_cfg="$pkg_cfg --enable-nonblocking"
pkg_cfg="$pkg_cfg --with-ssl=$BLDR_OPENSSL_BASE_PATH"

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
      pkg_file="$pkg_name-$pkg_vers.tar.gz"
      pkg_urls="http://curl.haxx.se/download/$pkg_file"

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

