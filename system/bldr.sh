#!/bin/bash

####################################################################################################
##
## License:    The MIT License
## 
## Copyright (c) 2012. Derek Gerstmann, The University of Western Australia.
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
## THE SOFTWARE.
##  
####################################################################################################

export BLDR_VERSION_MAJOR="1"
export BLDR_VERSION_MINOR="0"
export BLDR_VERSION_PATCH="0"
export BLDR_VERSION_STR="v$BLDR_VERSION_MAJOR.$BLDR_VERSION_MINOR.$BLDR_VERSION_PATCH"

BLDR_VERBOSE=${BLDR_VERBOSE:=false}
BLDR_DEBUG=${BLDR_DEBUG:=false}

if [ -t 1 ] ; 
then 
    BLDR_TXT_HEADER="\033[1;34m"    # bold blue
    BLDR_TXT_TITLE="\033[1;37m"     # bold white
    BLDR_TXT_ERROR="\033[1;31m"     # bold red
    BLDR_TXT_WARN="\033[1;33m"      # bold yellow
    BLDR_TXT_CMD="\033[1;32m"       # bold reen
    BLDR_TXT_INFO="\033[0;37m"      # white
    BLDR_TXT_RST="\033[0m"          # reset
else
    BLDR_TXT_HEADER=""
    BLDR_TXT_TITLE=""
    BLDR_TXT_ERROR=""
    BLDR_TXT_WARN=""
    BLDR_TXT_CMD=""
    BLDR_TXT_INFO=""
    BLDR_TXT_RST=""
fi

####################################################################################################

function bldr_echo()
{
    echo "${@}"
}

function bldr_log_info()
{
    local bldblu="\033[1;34m" # blue
    local txtwht="\033[0;37m" # white
    local txtrst="\033[0m"    # reset

    echo -e ${BLDR_TXT_HEADER}"--"${BLDR_TXT_INFO}" ${@} "${BLDR_TXT_RST}
}

function bldr_log_header()
{
    local bldblu="\033[1;34m" # blue
    local bldwht="\033[1;37m" # white
    local txtrst="\033[0m"    # reset

    local ts=$(date "+%Y-%m-%d-%H:%M:%S")
    echo -e ${BLDR_TXT_TITLE}"[ ${ts} ]"${BLDR_TXT_TITLE}" ${@} "${BLDR_TXT_RST}
}

function bldr_log_error()
{
    local bldred="\033[1;31m" # red
    local txtwht="\033[1;33m" # yellow
    local txtrst="\033[0m"    # reset

    local ts=$(date "+%Y-%m-%d-%H:%M:%S")
    echo -e ${BLDR_TXT_ERROR}"[ ${ts} ]" ${BLDR_TXT_WARN}" ${@} "${BLDR_TXT_RST}
}

function bldr_log_cmd()
{
    local bldwht="\033[1;37m" # white
    local bldgrn="\033[1;32m" # green
    local txtrst="\033[0m"    # reset

    echo -e ${BLDR_TXT_TITLE}">"${BLDR_TXT_CMD}" ${@} "${BLDR_TXT_RST}
}

function bldr_exec()
{
    bldr_log_cmd "${@}"
    eval "${@}" 
}

function bldr_log_split()
{
    bldr_echo "---------------------------------------------------------------------------------------------------------------"
}

####################################################################################################

# setup project paths
BLDR_ABS_PWD="$( cd "$( dirname "$0" )/.." && pwd )"
BLDR_BASE_DIR="$( basename "$BLDR_ABS_PWD" )"
BLDR_ROOT_DIR="$( dirname "$BLDR_ABS_PWD" )"

# try one level up if we aren't resolving the root dir
if [ "$BLDR_BASE_DIR" != "bldr" ]
then
    BLDR_ABS_PWD="$( cd "$( dirname "$0" )/../.." && pwd )"
    BLDR_BASE_DIR="$( basename "$BLDR_ABS_PWD" )"
    BLDR_ROOT_DIR="$( dirname "$BLDR_ABS_PWD" )"
fi

####################################################################################################

# ensure we are run inside of the root dir
if [ "$BLDR_BASE_DIR" != "bldr" ]
then
    echo "Please execute package build script from within the 'bldr' subfolder: '$BLDR_ABS_PWD'!"
    exit 0
fi 

####################################################################################################

# setup system paths
export BLDR_SCRIPTS_DIR="$BLDR_ABS_PWD/scripts"
export BLDR_LOCAL_DIR="$BLDR_ABS_PWD/local"
export BLDR_CACHE_DIR="$BLDR_ABS_PWD/cache"
export BLDR_SYSTEM_DIR="$BLDR_ABS_PWD/system"
export BLDR_PKGS_DIR="$BLDR_ABS_PWD/pkgs"
export BLDR_MODULE_DIR="$BLDR_ABS_PWD/modules"
export BLDR_BUILD_DIR="$BLDR_ABS_PWD/build"
export BLDR_OS_LIB_EXT="a"

####################################################################################################

export BLDR_SYSTEM_IS_LINUX=$( uname -s | grep -c Linux )
if [ "$BLDR_SYSTEM_IS_LINUX" -eq 1 ]
then
    export BLDR_OS_NAME="lnx"
fi

export BLDR_SYSTEM_IS_OSX=$( uname -s | grep -c Darwin )
if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
then
    export BLDR_OS_NAME="osx"
    export MACOSX_DEPLOYMENT_TARGET=10.6
    export LDFLAGS="-arch x86_64 -isysroot /Developer/SDKs/MacOSX10.6.sdk"
    export CFLAGS="-arch x86_64 -isysroot /Developer/SDKs/MacOSX10.6.sdk"
fi

export BLDR_SYSTEM_IS_CENTOS=0
if [ "$BLDR_SYSTEM_IS_LINUX" -eq 1 ]
then
    if [ -e /etc/redhat-release ]
    then
        export BLDR_SYSTEM_IS_CENTOS=$( cat /etc/redhat-release | grep -c CentOS )
    fi
fi

if [ "$BLDR_OS_NAME" == "" ]
then
    echo "Operating system is unknown and not detected properly.  Please update detection routine!"
    exit 0
fi 

####################################################################################################

# import any existing system utility into our path for usage
if [ -d "$BLDR_LOCAL_DIR/system" ]
then
    loaded_system=false
    for sys_path in "$BLDR_LOCAL_DIR/system"/*
    do
        if [[ -d "$sys_path/latest/bin" ]]
        then
            if [ $BLDR_VERBOSE != false ]
            then
                bldr_log_info "Using local system utility: '$sys_path'"
                loaded_system=true
            fi
            export PATH="$sys_path/latest/bin:$PATH"
        fi
    done
    if [ $loaded_system != false ]
    then
        bldr_log_split
    fi
fi

# setup the environment to support our own version of MODULES
if [ -d "$BLDR_LOCAL_DIR/system/modules/latest" ]
then
    for md_path in "$BLDR_LOCAL_DIR/system/modules/latest/Modules"/*
    do
        if [[ -d "$md_path/bin" ]]
        then
            export PATH="$md_path/bin:$PATH"
        fi
        if [[ -d "$md_path/init" ]]
        then
            source "$md_path/init/bash"
            module use $BLDR_MODULE_DIR/system
        fi
    done
fi

# setup the environment to support our own version of PKG_CONFIG
if [ -d "$BLDR_LOCAL_DIR/system/pkg-config/latest/bin" ]
then
    if [ ! -d "$BLDR_LOCAL_DIR/system/pkg-config/latest/lib/pkgconfig" ]
    then
        mkdir -p "$BLDR_LOCAL_DIR/system/pkg-config/latest/lib/pkgconfig"
    fi

    export PKG_CONFIG=$BLDR_LOCAL_DIR/system/pkg-config/latest/bin/pkg-config
    export PKG_CONFIG_PATH=$BLDR_LOCAL_DIR/system/pkg-config/latest/lib/pkgconfig
fi

####################################################################################################

function bldr_get_stdout()
{
    local output=""    
    if [ $BLDR_VERBOSE != false ]
    then
        output="&>1"
    else
        output="&>/dev/null"
    fi
    echo $output
}

function bldr_make_lowercase()
{
    echo $1 | tr '[:upper:]' '[:lower:]'
}

function bldr_make_uppercase()
{
    echo $1 | tr '[:lower:]' '[:upper:]'
}

function bldr_resolve_path()
{
    cd "$1" 2>/dev/null || return $? 
    local resolved="`pwd -P`"
    echo "$resolved"
}

function bldr_unquote_str
{
    echo "${@}" | sed 's/^"*//g' | sed 's/"*$//g' 
}

function bldr_trim_str
{
    echo "${@}" | sed 's/^ *//g' | sed 's/ *$//g' 
}

function bldr_trim_list_str
{
    echo "${@}" | sed 's/^:*//g' | sed 's/:*$//g'
}

function bldr_trim_url_str
{
    echo "${@}" | sed 's/^;*//g' | sed 's/;*$//g'
}

function bldr_match_str
{
    local $str
    local $fnd
    local cnt=$(echo $str | grep -c '^'$fnd':')
    echo "$cnt"
}

function bldr_locate_makefile
{
    local make_path="."
    local given=$(bldr_trim_str "$1")
    local mk_paths=$(bldr_trim_str "$given . ./build ../build .. ../src ../source")
    if [ -f "CMakeLists.txt" ] && [ -f "build/Makefile" ]
    then
        make_path="build"
    else
        for path in ${mk_paths}
        do
            if [ -f "$path/Makefile" ]
            then
                make_path="$path"
                break
            fi
        done
    fi
    echo "$make_path"
}

function bldr_locate_boot_script
{
    local found_path=""
    local given=$(bldr_trim_str "$1")
    local cfg_paths=$(bldr_trim_str "$given . build source src ../build ../source ../src")
    local cfg_files="bootstrap bootstrap.sh autogen.sh"
    for path in ${cfg_paths}
    do
        for file in ${cfg_files}
        do
            if [ -f "$path/$file" ]
            then
                found_path="$path/$file"
                break
            fi
        done
    done
    echo "$found_path"
}

function bldr_locate_boot_path
{
    local given=$(bldr_trim_str "$1")
    local script=$(bldr_locate_boot_script "$given")
    local path=$(dirname "$script")
    echo "$path"
}

function bldr_locate_config_script
{
    local found_path="."
    local given=$(bldr_trim_str "$1")
    local cfg_paths=$(bldr_trim_str "$given . source src build ../build ../source ../src")
    local cfg_files="configure configure.sh bootstrap bootstrap.sh autogen.sh CMakeLists.txt"
    for path in ${cfg_paths}
    do
        for file in ${cfg_files}
        do
            if [ -f "$path/$file" ]
            then
                found_path="$path/$file"
                break
            fi
        done
    done
    echo "$found_path"
}

function bldr_locate_config_path
{
    local given=$(bldr_trim_str "$1")
    local script=$(bldr_locate_config_script "$given")
    local path=$(dirname "$script")
    echo "$path"
}

function bldr_quote_str
{
    local filename=$1

    sed $filename \
        -e 's#\\#\\\\#' \
        -e 's#/#\\/#' \
        -e 's#\.#\\.#' \
        -e 's#\*#\\*#' \
        -e 's#\[#\\[#'

    return $?
}

function bldr_split_str
{
    local BLDR_DEFAULT_DELIMITER=" "

    local a_delimiter="${1:-$BLDR_DEFAULT_DELIMITER}"
    local a_inputfile="$2"

    awk -F "$a_delimiter" \
    '{  for(i = 1; i <= NF; i++) {
            print $i
        }
    }' $a_inputfile

    return $?
}

function bldr_join_str
{
    local BLDR_DEFAULT_DELIMITER=" "

    local a_delimiter="${1:-$BLDR_DEFAULT_DELIMITER}"
    local a_inputfile="$2"

    awk -v usersep="$a_delimiter" '
    BEGIN{
        sep=""; # Start with no bldr_log_split (before the first item)
    }
    {
        printf("%s%s", sep, $0);
        (NR == 1) && sep = usersep; # Separator is set after the first item.
    }
    END{
        print "" # Print a new line at the end.
    }' $a_inputfile
    
    return $?
}

function bldr_output_header()
{
    local msg=$@
    bldr_log_split
    bldr_log_header "${msg}"
    bldr_log_split
}

function bldr_bail
{
    local msg=$@

    bldr_log_split
    bldr_log_error "ERROR: ${msg}. Exiting..."
    bldr_log_split

    exit 1
}

function try
{
    $@
    if test $? -ne 0 ; then
        bldr_bail "$@"
    fi
}

function bldr_exit_on_failure
{
    if test $? -ne 0 ; then
        bldr_bail "$1"
    fi
}

function bldr_clone()
{
    local url=$1
    local dir=$2

    local cmd="$(which wget)"
    if [ -e $cmd ];
    then
        cmd="git bldr_clone"
        $cmd $url $dir || bldr_bail "Failed to bldr_clone '$url' into '$dir'"
    else
        bldr_bail "Failed to locate 'git' command!  Please install this command line utility!"
    fi
    bldr_log_split
}

function bldr_checkout()
{
    local url=$1
    local dir=$2

    url="${url/svn/http}"
    local cmd="$(which svn)"
    if [ -e $cmd ];
    then
        cmd="svn export"
        $cmd $url $dir || bldr_bail "Failed to bldr_checkout '$url' into '$dir'"
    else
        bldr_bail "Failed to locate 'svn' command!  Please install this command line utility!"
    fi
    bldr_log_split
}

function bldr_fetch() 
{
    local url=$1
    local archive=$2
    local dir=$3

    local usepipe=0
    local cmd="$(which wget)"
    if [ ! -e $cmd ];
    then
        cmd="$(which curl)"
        if [ -e $cmd ];
        then
            cmd="curl -f -L -O"
            usepipe=1
        else
            bldr_bail "Failed to locate either 'wget' or 'curl' for fetching packages!  Please install one of these utilties!"
        fi
    else
        cmd="wget --progress=dot -O"
    fi

    if [ ! -e $archive ]; then
        bldr_log_header "Fetching '$archive'..."
        bldr_log_split
        if [ "$usepipe" -eq 1 ]
        then
            echo "> $cmd $url > $archive"
            bldr_log_split
            $cmd $url > $archive
        else
            echo "> $cmd $archive $url"
            bldr_log_split
            $cmd $archive $url
        fi
        bldr_log_split
        bldr_log_info "Downloaded '$url' to '$archive'..."
    fi
}

function bldr_is_valid_archive()
{
    local is=0
    local archive=$1
    if [ -f $archive ] ; then
       case $archive in
        *.tar.bz2)  is=1;;
        *.tar.gz)   is=1;;
        *.tar.xz)   is=1;;
        *.bz2)      is=1;;
        *.rar)      is=1;;
        *.gz)       is=1;;
        *.tar)      is=1;;
        *.tbz2)     is=1;;
        *.tgz)      is=1;;
        *.zip)      is=1;;
        *.Z)        is=1;;
        *.7z)       is=1;;
        *)          is=0;;
       esac    
    fi
    echo "$is"
}

function bldr_extract_archive()
{
    local archive=$1
    local extr=$(which tar)
    bldr_log_info "Extracting '$archive'"

    if [ -e $BLDR_LOCAL_DIR/gtar/latest/bin/tar ]
    then
        extr=$BLDR_LOCAL_DIR/gtar/latest/bin/tar
    fi

    local output=$(bldr_get_stdout)  
    if [ $BLDR_VERBOSE != false ]
    then
        bldr_log_split
    fi

    if [ -f $archive ] ; then
       case $archive in
        *.tar.bz2)  eval $extr xvjf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tar.gz)   eval $extr xvzf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tar.xz)   eval $extr Jxvf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.bz2)      eval bunzip2 ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.rar)      eval unrar x ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.gz)       eval gunzip ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tar)      eval $extr xvf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tbz2)     eval $extr xvjf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tgz)      eval $extr xvzf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.zip)      eval unzip -uo ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.Z)        eval uncompress ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.7z)       eval 7z x ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *)          bldr_bail "Failed to extract archive '${archive}'";;
       esac    
    fi
}

function bldr_strip_archive_ext()
{
    local archive=$1
    local result=""

    if [ -f $archive ] ; then
       case $archive in
        *.tar.bz2)  result=$(echo ${archive%.tar.bz2} );;
        *.tar.gz)   result=$(echo ${archive%.tar.gz} );;
        *.tar.xz)   result=$(echo ${archive%.tar.xz} );;
        *.bz2)      result=$(echo ${archive%.bz2} );;
        *.rar)      result=$(echo ${archive%.rar} );;
        *.gz)       result=$(echo ${archive%.gz} );;
        *.tar)      result=$(echo ${archive%.tar} );;
        *.tbz2)     result=$(echo ${archive%.tbz2} );;
        *.tgz)      result=$(echo ${archive%.tgz} );;
        *.zip)      result=$(echo ${archive%.zip} );;
        *.Z)        result=$(echo ${archive%.Z} );;
        *.7z)       result=$(echo ${archive%.7z} );;
        *)          bldr_bail "Failed to extract archive contents '${archive}'";;
       esac    
    fi

    echo $result
}

function bldr_list_archive()
{
    local archive=$1
    local extr=$(which tar)
    local result=""

    if [ -e $BLDR_LOCAL_DIR/gtar/latest/bin/tar ]
    then
        extr=$BLDR_LOCAL_DIR/gtar/latest/bin/tar
    fi

    if [ -f $archive ] ; then
       case $archive in
        *.tar.bz2)  result=$(eval $extr tjf ${archive} );;
        *.tar.gz)   result=$(eval $extr tzf ${archive} );;
        *.tar.xz)   result=$(eval $extr Jtf ${archive} );;
        *.tar)      result=$(eval $extr tf ${archive} );;
        *.tbz2)     result=$(eval $extr tjf ${archive} );;
        *.tgz)      result=$(eval $extr tzf ${archive} );;
        *.zip)      result=$(eval unzip -l ${archive} );;
        *)          bldr_bail "Failed to extract archive contents '${archive}'";;
       esac    
    fi

    local basedir=$(echo "$result" | grep -E "^[^/]*(/)$" )

    if [ "$basedir" == "" ]
    then
        basedir=$(bldr_strip_archive_ext "$archive")
    fi

    local listing=$(basename $basedir)
    echo "$listing"
}

function bldr_make_dir()
{
    local dir=$1
    bldr_log_info "Creating '$dir'"
    mkdir -p ${dir} || bldr_bail "Failed to create directory '${dir}'"
}

function bldr_remove_dir()
{
    local dir=$1
    local force=$2
    if [ "$dir" = "/" ] 
    then
        bldr_bail "Invalid directory name requested for removal: '${dir}'"
    fi

    bldr_log_info "Removing '$dir'"
    if [ ${force} ]; then
        rm -r ${dir}  || bldr_bail "Failed to remove directory '${dir}'"
    else
        if [ -d "${dir}" ]; then
            chmod -R +rw ${dir} || bldr_bail "Failed to remove directory '${dir}'"
            rm -r ${dir}  || bldr_bail "Failed to remove directory '${dir}'"
        fi
    fi
}

function bldr_push_dir()
{
    local dir=$1
    pushd ${dir} > /dev/null || bldr_bail "Failed to push directory '${dir}'"
}

function bldr_pop_dir()
{
    local dir=$1
    popd  > /dev/null  || bldr_bail "Failed to pop directory!"
}

function bldr_move_file()
{
    local src=$1
    local dst=$2
    mv ${src} ${dst}  || bldr_bail "Failed to move file!"
}

function bldr_remove_file()
{
    local src=$1
    rm ${src} || bldr_bail "Failed to remove file!"
}

function bldr_copy_file()
{
    local src=$1
    local dst=$2
    cp ${src} ${dst}  || bldr_bail "Failed to copy file!"
}

function bldr_make_archive()
{
    local archive=$1
    local dir=$2
    
    tar cjf "${archive}" "${dir}" || bldr_bail "Failed to create archive!"
}

function bldr_cursor_pos()
{
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    echo -en "\033[6n" > /dev/tty
    # tput u7 > /dev/tty    # when TERM=xterm (and relatives)
    
    IFS=';' read -r -d R -a pos
    stty $oldstty
    
    # change from one-based to zero based so they work with: tput cup $row $col
    local row=$((${pos[0]:2} - 1))    # strip off the esc-[
    local col=$((${pos[1]} - 1))
    
    echo "$row $col"
}

function bldr_copy_dir()
{
    local src=$1
    local dst=$2

    bldr_log_info "Copying '$src' to '$dst' ..."
    if [ "$BLDR_SYSTEM_IS_LINUX" -eq 1 ]
    then
        # echo cp -TRv $src $dst
        cp -TR $src $dst || bldr_bail "Failed to copy from '$src' to '$dst'"
    elif [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
    then
        # echo ditto -v $src $dst
        ditto $src $dst || bldr_bail "Failed to copy from '$src' to '$dst'"
    fi
}

####################################################################################################

function bldr_build_all()
{
    local dir="${1}"
    if [[ -d $dir ]]
    then
        local builder
        for builder in "$dir"/*
        do
            if [[ -f $builder ]]
            then
                eval $builder
            fi
        done
    fi
}

function bldr_has_pkg()
{
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_opts=""

    while true ; do
        case "$1" in
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           * )              break ;;
        esac
    done

    local existing=false

    if [ -d "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        existing=true
    fi

    echo "$existing"
}

function bldr_setup_pkg()
{
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [[ $(echo $pkg_opts | grep -c 'skip-setup' ) > 0 ]]
    then
        return
    fi

    bldr_log_header "Setting up package '$pkg_name/$pkg_vers' for '$BLDR_OS_NAME' ... "
    bldr_log_split
    
    if [ ! -d $BLDR_BUILD_DIR ]
    then
        bldr_make_dir "$BLDR_BUILD_DIR"
        bldr_log_split
    fi

    bldr_push_dir "$BLDR_BUILD_DIR"

    if [ -d "$pkg_name/$pkg_vers" ]
    then
        bldr_log_info "Removing stale build '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers'"
        bldr_log_split
        bldr_remove_dir "$pkg_name/$pkg_vers"
    fi
    bldr_pop_dir

    if [ -f "$BLDR_MODULE_DIR/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_info "Removing stale module '$BLDR_MODULE_DIR/$pkg_ctry/$pkg_name/$pkg_vers'"
        bldr_log_split
        bldr_remove_file "$BLDR_MODULE_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    fi
}

function bldr_fetch_pkg()
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [[ $(echo $pkg_opts | grep -c 'skip-fetch' ) > 0 ]]
    then
        return
    fi

    # create the local cache dir if it doesn't exist
    if [ ! -d $BLDR_CACHE_DIR ]
    then
        bldr_make_dir "$BLDR_CACHE_DIR"
        bldr_log_split
    fi
    bldr_push_dir "$BLDR_CACHE_DIR"
#    bldr_log_split

    # if a local copy doesn't exist, grab the pkg from the url
    bldr_log_info "Fetching package '$BLDR_CACHE_DIR/$pkg_file'"
    bldr_log_split
    if [ ! -f "$pkg_file" ]
    then
        local pkg_url_list=$(echo $pkg_urls | bldr_split_str ';')
        for url in ${pkg_url_list}
        do
            bldr_log_info "Retrieving package '$pkg_name/$pkg_vers' from '$url'"
            bldr_log_split

            if [[ $(echo "$url" | grep -c 'http://') == 1 ]]
            then
                bldr_fetch $url $pkg_file 
            fi

            if [[ $(echo "$url" | grep -c 'git://') == 1 ]]
            then
                bldr_clone $url $pkg_name 
                if [ -d $pkg_name ]
                then
                    bldr_log_split
                    bldr_log_info "Archiving package '$pkg_file' from '$pkg_name/$pkg_vers'"
                    bldr_make_archive $pkg_file $pkg_name
#                    bldr_log_split
                fi
            fi

            if [[ $(echo "$url" | grep -c 'svn://') == 1 ]]
            then
                bldr_checkout $url $pkg_name 
                if [ -d $pkg_name ]
                then
                    bldr_log_split
                    bldr_log_info "Archiving package '$pkg_file' from '$pkg_name/$pkg_vers'"
                    bldr_make_archive $pkg_file $pkg_name
#                    bldr_log_split
                fi
            fi

            if [ -e $pkg_file ]; then
                break;
            fi
        done
    fi
    bldr_pop_dir

    # extract any pkg archives
    bldr_log_info "Checking package '$BLDR_CACHE_DIR/$pkg_file'"
    bldr_log_split

    if [[ $(bldr_is_valid_archive "$BLDR_CACHE_DIR/$pkg_file") > 0 ]]
    then
        bldr_log_info "Cloning package '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$pkg_file'"
        bldr_log_split

        if [ ! -d "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name" ]
        then
            bldr_make_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name"
            bldr_log_split
        fi

        if [ -d "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers" ]
        then
            bldr_remove_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
            bldr_log_split
        fi

        bldr_copy_file "$BLDR_CACHE_DIR/$pkg_file" "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_file"

        bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name"
        local archive_listing=$(bldr_list_archive $pkg_file)

        bldr_log_info "Extracting package '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_file' to '$archive_listing'"
        bldr_log_split
        
        bldr_extract_archive $pkg_file
        bldr_move_file $archive_listing $pkg_vers
        bldr_remove_file "$pkg_file"
        if [ $BLDR_VERBOSE != true ]
        then
            bldr_log_split
        fi    
        bldr_pop_dir
    fi
}

function bldr_boot_pkg()
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
    local pkg_patches=""
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [[ $(echo $pkg_opts | grep -c 'skip-boot' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    bldr_log_header "Booting package '$pkg_name/$pkg_vers'"
    bldr_log_split

    if [ ! -d "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_make_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
        bldr_log_split
    fi

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_path=$(bldr_locate_config_path $pkg_cfg_path)
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    pkg_patches=$(bldr_trim_list_str "$pkg_patches")
    if [ "$pkg_patches" != "" ] && [ "$pkg_patches" != " " ] && [ "$pkg_patches" != ":" ]
    then
        pkg_patches=$(echo $pkg_patches | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_patches=""
    fi

    for patch_file in ${pkg_patches}
    do
        if [ -f "$patch_file" ] 
        then
            bldr_log_info "Applying patch from file '$patch_file' ..."
            bldr_log_split

            bldr_log_cmd "patch -p1 < $patch_file"
            bldr_log_split

            patch -p1 < $patch_file || bldr_bail "Failed to apply patch '$patch_file' to package '$pkg_name/$pkg_vers'!"
            bldr_log_split
        fi
    done

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"
    pkg_uses=$(bldr_trim_list_str "$pkg_uses")
    if [ "$pkg_uses" != "" ] && [ "$pkg_uses" != " " ] && [ "$pkg_uses" != ":" ]
    then
        pkg_uses=$(echo $pkg_uses | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_uses=""
    fi

    local cmd_mod="$(which modulecmd)"
    if [[ "$pkg_uses" != "" && "$cmd_mod" != "" ]]
    then
        if [ -d "$BLDR_MODULE_DIR/$pkg_ctry" ]
        then
            module use "$BLDR_MODULE_DIR/$pkg_ctry"
        fi

        for using in ${pkg_uses}
        do
            bldr_log_info "Loading module '$using' ..."
            module load $using
        done
        bldr_log_split
    fi
    bldr_pop_dir

    local bootstrap=false
    if [ ! -x "./configure" ] && [ ! -x "./configure.sh" ]
    then
        bootstrap=true
    fi

    if [[ $(echo $pkg_opts | grep -c 'force-bootstrap' ) > 0 ]]
    then
        bldr_log_info "Forcing bootstrap configuration ..."
        bldr_log_split
        bootstrap=true
    fi
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    local boot_path=$(bldr_locate_boot_path $pkg_cfg_path)
    bldr_pop_dir

    # bootstrap package
    if [ $bootstrap != false ]
    then
        bldr_log_info "Moving to boot path: '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$boot_path' ..."
        bldr_log_split
        bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$boot_path"

        local boot_cmd=$(bldr_locate_boot_script $pkg_cfg_path)

        bldr_log_info "Using boot script: '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$boot_path/$boot_cmd' ..."
        bldr_log_split

        if [ -x "$boot_cmd" ]
        then
            local output=$(bldr_get_stdout)
            bldr_log_cmd "$boot_cmd --prefix=\"$prefix\""

            if [ $BLDR_VERBOSE != false ]
            then
                eval $boot_cmd --prefix="$prefix" || bldr_bail "Failed to boot package '$pkg_name/$pkg_vers'!"
                bldr_log_split
            else
                eval $boot_cmd --prefix="$prefix" 1> /dev/null || bldr_bail "Failed to boot package '$pkg_name/$pkg_vers'!"
            fi
        fi
        bldr_pop_dir
    fi
}

function bldr_cmake_pkg()
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [[ $(echo $pkg_opts | grep -c 'skip-config' ) > 0 ]]
    then
        return
    fi

    bldr_make_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/build"
    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/build"

    bldr_log_split
  
    local prefix="$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers"

    local env_flags=" "
    pkg_cfg=$(bldr_trim_list_str "$pkg_cfg")
    if [ "$pkg_cfg" != "" ] && [ "$pkg_cfg" != " " ] && [ "$pkg_cfg" != ":" ]
    then
        pkg_cfg=$(echo $pkg_cfg | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_cfg=""
    fi

    pkg_cflags=$(bldr_trim_list_str "$pkg_cflags")
    if [ "$pkg_cflags" != "" ] && [ "$pkg_cflags" != " " ]  && [ "$pkg_cflags" != ":" ]
    then
        pkg_mpath=$(echo $pkg_cflags | bldr_split_str ":" | bldr_join_str ";")
        env_flags='-DCMAKE_PREFIX_PATH="'$pkg_mpath'"'
    else
        pkg_cflags=""
    fi

    pkg_ldflags=$(bldr_trim_list_str "$pkg_ldflags")
    if [ "$pkg_ldflags" != "" ] && [ "$pkg_ldflags" != " " ] && [ "$pkg_ldflags" != ":" ]
    then
        pkg_env=$(echo $pkg_ldflags | bldr_split_str ":" | bldr_join_str " ")
        env_flags=$env_flags' '$pkg_env
    else
        pkg_ldflags=""
    fi

    env_flags="$env_flags $pkg_cfg"

    local cmake_src_path=".."
    local src_paths=".. ../src ../source"
    for path in ${src_paths}
    do
        if [ -f "$path/CMakeLists.txt" ] 
        then
            cmake_src_path="$path"
            break
        fi
    done

    bldr_log_header "Configuring package '$pkg_name/$pkg_vers' from source folder '$cmake_src_path' ..."
    bldr_log_split

    local cmake_exec="$BLDR_LOCAL_DIR/system/cmake/latest/bin/cmake"
    local cmake_mod="-DCMAKE_MODULE_PATH=$BLDR_LOCAL_DIR/system/cmake/latest/share/cmake-2.8/Modules"
    local cmake_pre="-DCMAKE_INSTALL_PREFIX=$prefix"
    if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
    then
        cmake_pre="$cmake_pre -DCMAKE_OSX_ARCHITECTURES=x86_64"
    fi

    local use_static=false
    local use_shared=false
    if [[ $(echo $pkg_opts | grep -c 'enable-shared' ) > 0 ]]
    then
        bldr_log_info "Adding shared library configuration ..."
        bldr_log_split
        cmake_pre="$cmake_pre -DBUILD_SHARED_LIBS=ON"
        use_shared=true
    fi
    
    if [[ $(echo $pkg_opts | grep -c 'enable-static' ) > 0 ]]
    then
        bldr_log_info "Adding static library configuration ..."
        bldr_log_split
        cmake_pre="$cmake_pre -DBUILD_STATIC_LIBS=ON"
        use_static=true
    fi

    if [[ $(echo $pkg_opts | grep -c 'force-shared' ) > 0 ]]
    then
        bldr_log_info "Forcing shared library configuration ..."
        bldr_log_split
        if [ use_shared != true ]
        then
            cmake_pre="$cmake_pre -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF"
        fi
    fi

    if [[ $(echo $pkg_opts | grep -c 'force-static' ) > 0 ]]
    then
        bldr_log_info "Forcing static library configuration ..."
        bldr_log_split
        if [ use_static != true ]
        then
            cmake_pre="$cmake_pre -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON"
        fi
    fi


    bldr_log_cmd "$cmake_exec $cmake_mod $cmake_pre $env_flags $cmake_src_path"
    bldr_log_split

    if [ $BLDR_VERBOSE != false ]
    then
        eval $cmake_exec $cmake_mod $cmake_pre $env_flags $cmake_src_path || bldr_bail "Failed to configure: '$prefix'"
        bldr_log_split
    else
        eval $cmake_exec $cmake_mod $cmake_pre $env_flags $cmake_src_path &>/dev/null || bldr_bail "Failed to configure: '$prefix'"
        bldr_log_split
    fi

    bldr_log_info "Done configuring package '$pkg_name/$pkg_vers'"
    bldr_pop_dir
}

function bldr_config_pkg()
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [[ $(echo $pkg_opts | grep -c 'skip-config' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_path=$(bldr_locate_config_path $pkg_cfg_path)
    bldr_pop_dir

    bldr_log_header "Configuring package '$pkg_name/$pkg_vers' ..."
    bldr_log_split

    bldr_log_info "Moving to config path: '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path' ..."
    bldr_log_split

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"

    local use_cmake=1
    local has_cmake=0

    local use_amake=0
    local has_amake=0

    if [ -f "./CMakeLists.txt" ] || [ -f "./src/CMakeLists.txt" ] || [ -f "./source/CMakeLists.txt" ]
    then
        has_cmake=1
    fi    

    if [ -f "./configure" ] || [ -f "./Configure.sh" ] || [ -f "./Configure" ]
    then
        has_amake=1
    fi

    if [[ $(echo $pkg_opts | grep -c 'cmake' ) > 0 ]]
    then
        use_cmake=1
        use_amake=0
        has_amake=0
    fi

    if [[ $(echo $pkg_opts | grep -c 'configure' ) > 0 ]]
    then
        use_cmake=0
        has_cmake=0
        use_amake=1
    fi

    if [ $use_cmake != 0 ] && [ $has_cmake != 0 ]
    then
        bldr_pop_dir
        bldr_cmake_pkg                    \
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
    else
        use_amake=1
    fi

    if [ $use_amake != 0 ] && [ $has_amake != 0 ]
    then
        local env_flags=" "
        if [ "$BLDR_SYSTEM_IS_CENTOS" -eq 1 ]
        then
            if [ "$pkg_cflags" != "" ] && [ "$pkg_cflags" != " " ]  && [ "$pkg_cflags" != ":" ]
            then
                pkg_cflags="$pkg_cflags":-I/usr/include
                pkg_ldflags="$pkg_ldflags":-L/usr/lib64:-L/usr/lib
            fi
        fi

        pkg_cfg=$(bldr_trim_list_str "$pkg_cfg")
        if [ "$pkg_cfg" != "" ] && [ "$pkg_cfg" != " " ] && [ "$pkg_cfg" != ":" ]
        then
            pkg_cfg=$(echo $pkg_cfg | bldr_split_str ":" | bldr_join_str " ")
        else
            pkg_cfg=""
        fi

        pkg_cflags=$(bldr_trim_list_str "$pkg_cflags")
        if [ "$pkg_cflags" != "" ] && [ "$pkg_cflags" != " " ]  && [ "$pkg_cflags" != ":" ]
        then
            pkg_cflags=$(echo $pkg_cflags | bldr_split_str ":" | bldr_join_str " ")
#            env_flags='CXXFLAGS="'$pkg_cflags'" CPPFLAGS="'$pkg_cflags'" CFLAGS="'$pkg_cflags'"'
            env_flags="CXXFLAGS=\"$pkg_cflags $CXXFLAGS\" CPPFLAGS=\"$pkg_cflags $CPPFLAGS\" CFLAGS=\"$pkg_cflags $CFLAGS\""
        else
            pkg_cflags=""
        fi

        pkg_ldflags=$(bldr_trim_list_str "$pkg_ldflags")
        if [ "$pkg_ldflags" != "" ] && [ "$pkg_ldflags" != " " ] && [ "$pkg_ldflags" != ":" ]
        then
            pkg_ldflags=$(echo $pkg_ldflags | bldr_split_str ":" | bldr_join_str " ")
#            env_flags=$env_flags' LDFLAGS="'$pkg_ldflags'"'
            env_flags="$env_flags LDFLAGS=\"$pkg_ldflags $LDFLAGS\""
        else
            pkg_ldflags=""
        fi

        local use_static=false
        local use_shared=false

        if [[ $(echo $pkg_opts | grep -c 'enable-shared' ) > 0 ]]
        then
            bldr_log_info "Adding shared library configuration ..."
            bldr_log_split
            pkg_cfg="$pkg_cfg --enable-shared"
            use_shared=true
        fi
        
        if [[ $(echo $pkg_opts | grep -c 'enable-static' ) > 0 ]]
        then
            bldr_log_info "Adding static library configuration ..."
            bldr_log_split
            pkg_cfg="$pkg_cfg --enable-static"
            use_static=true
        fi

        if [[ $(echo $pkg_opts | grep -c 'force-shared' ) > 0 ]]
        then
            bldr_log_info "Forcing shared library configuration ..."
            bldr_log_split
            if [ $use_shared != true ]
            then
                pkg_cfg="$pkg_cfg --enable-shared --disable-static"
            fi
        fi

        if [[ $(echo $pkg_opts | grep -c 'force-static' ) > 0 ]]
        then
            bldr_log_info "Forcing static library configuration ..."
            bldr_log_split
            if [ $use_static != true ]
            then
                pkg_cfg="$pkg_cfg --disable-shared --enable-static"
            fi
        fi

        local cfg_cmd=$(bldr_locate_config_script $pkg_cfg_path)
        local output=$(bldr_get_stdout)  

        bldr_log_cmd "$cfg_cmd --prefix=\"$prefix\" $pkg_cfg $env_flags"
        bldr_log_split

        if [ $BLDR_VERBOSE != false ]
        then
            eval $cfg_cmd "--prefix=$prefix ${pkg_cfg} ${env_flags}" || bldr_bail "Failed to configure: '$prefix'"
            bldr_log_split
        else
            eval $cfg_cmd "--prefix=$prefix ${pkg_cfg} ${env_flags}" &>/dev/null || bldr_bail "Failed to configure: '$prefix'"
        fi

        bldr_log_info "Done configuring package '$pkg_name/$pkg_vers'"
        bldr_log_split
        bldr_pop_dir
    fi
}

function bldr_compile_pkg()
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [[ $(echo $pkg_opts | grep -c 'skip-compile' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile $pkg_cfg_path)
    bldr_pop_dir

    bldr_log_info "Moving to build path: '$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"

    local output=$(bldr_get_stdout)
    local options="--stop"
    if [ $BLDR_VERBOSE != true ]
    then
        options="--quiet $options"
    fi

    if [ -f "./Makefile" ]
    then
        bldr_log_header "Building package '$pkg_name/$pkg_vers'"
        bldr_log_split
        
        bldr_log_cmd "make $options"
        bldr_log_split

        if [ $BLDR_VERBOSE != false ]
        then
            eval make $options || bldr_bail "Failed to install package: '$prefix'"
            bldr_log_split
        else
            eval make $options &> /dev/null || bldr_bail "Failed to install package: '$prefix'"
            bldr_log_split
        fi
    fi
    bldr_pop_dir
}

function bldr_install_pkg()
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    local prefix="$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile $pkg_cfg_path)
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"

    local output=$(bldr_get_stdout)
    local options="--stop"
    if [ $BLDR_VERBOSE != true ]
    then
        options="--quiet $options"
    fi

    # extract the makefile rule names and filter out empty lines and comments
    if [ -f "./Makefile" ]
    then
        # install using make if an 'install' rule exists
        local rules=$(make -pnsk | grep -v ^$ | grep -v ^# | grep -c '^install:')
        if [[ $(echo "$rules") > 0 ]]
        then
            bldr_log_header "Installing package '$pkg_name/$pkg_vers'"
            bldr_log_split

            bldr_log_cmd "make $options install"
            bldr_log_split

            if [ $BLDR_VERBOSE != false ]
            then
                eval make $options install || bldr_bail "Failed to install package: '$prefix'"
                bldr_log_split
            else
                eval make $options install &> /dev/null || bldr_bail "Failed to install package: '$prefix'"
                bldr_log_split
            fi
        fi
    fi
    bldr_pop_dir
}

function bldr_migrate_pkg()
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [[ $(echo $pkg_opts | grep -c 'skip-migrate' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile $pkg_cfg_path)
    bldr_pop_dir

    bldr_log_header "Migrating package '$pkg_name/$pkg_vers' ..."
    bldr_log_split

    # build using make if a makefile exists
    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"
    local bin_paths="lib bin lib32 lib64"
    for path in ${bin_paths}
    do
        # move product into external os specific path
        if [ -d "$prefix/$path" ]
        then
            if [ -d "$prefix/$path/pkgconfig" ] && [ -d "$PKG_CONFIG_PATH" ]
            then
                bldr_log_info "Adding package config '$prefix/$path/pkgconfig' for '$pkg_name/$pkg_vers'"
                bldr_log_split

                cp -v $prefix/$path/pkgconfig/*.pc "$PKG_CONFIG_PATH" || bldr_bail "Failed to copy pkg-config into directory: $PKG_CONFIG_PATH"
                bldr_log_split
            fi
        fi
    done
    bldr_pop_dir

    if [[ $(echo $pkg_opts | grep -c 'migrate-build-headers' ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
        local inc_paths="include inc man share"
        for path in ${inc_paths}
        do
            # move product into external path
            if [ -d "$path" ]
            then
                bldr_log_header "Migrating build files from '$path' for '$pkg_name/$pkg_vers'"
                bldr_log_split
                bldr_make_dir "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$path"
                bldr_copy_dir "$path" "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$path" || bldr_bail "Failed to copy shared files into directory: $BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$path"
                bldr_log_split
            fi
        done
        bldr_pop_dir
    fi    

    if [[ $(echo $pkg_opts | grep -c 'migrate-build-libs' ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
        local inc_paths="build"
        for path in ${inc_paths}
        do
            # move product into external path
            if [ -d "$path" ]
            then
                bldr_log_header "Migrating build libraries from '$path' for '$pkg_name/$pkg_vers'"
                bldr_log_split
                bldr_make_dir "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$path"
                bldr_log_split
                eval cp -v "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$path/*.$BLDR_OS_LIB_EXT" "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$path" || bldr_bail "Failed to copy shared files into directory: $BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers/$path"
            fi
        done
        bldr_pop_dir
    fi    

    bldr_log_info "Linking local '$pkg_name/$pkg_vers' as '$pkg_name/latest' ..."
    bldr_log_split
    if [ -e "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/latest" ]
    then
        bldr_remove_file "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/latest"
    fi

    if [ $BLDR_VERBOSE != false ]
    then
        ln -sv "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers" "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/latest" || bldr_bail "Failed to link latest package version to '$pkg_name/$pkg_vers'!"
        bldr_log_split    
    else
        ln -s "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers" "$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/latest"  || bldr_bail "Failed to link latest package version to '$pkg_name/$pkg_vers'!"
    fi
}

function bldr_cleanup_pkg()
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [[ $(echo $pkg_opts | grep -c 'skip-cleanup' ) > 0 ]]
    then
        return
    fi

    bldr_log_header "Cleaning package '$pkg_name/$pkg_vers' ..."
    bldr_log_split
    
    local prefix="$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile $pkg_cfg_path)
    bldr_pop_dir

    # build using make if a makefile exists
    if [[ $(echo $pkg_opts | grep -c 'keep' ) > 0 ]]
    then
        bldr_log_info "Keeping package build directory for '$pkg_name/$pkg_vers'"
        bldr_log_split
    else
        bldr_log_info "Removing package build directory for '$pkg_name/$pkg_vers'"
        bldr_log_split

        bldr_remove_dir "$BLDR_BUILD_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
        bldr_log_split
    fi
}

function bldr_modulate_pkg()
{
    local use_verbose="false"
    local pkg_ctry="common"
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [[ $(echo $pkg_opts | grep -c 'skip-modulate' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_DIR/$pkg_ctry/$pkg_name/$pkg_vers"
    local tstamp=$(date "+%Y-%m-%d-%H:%M:%S")

    local module_dir="$BLDR_MODULE_DIR/$pkg_ctry/$pkg_name"
    local module_file="$BLDR_MODULE_DIR/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_log_header "Modulating '$pkg_ctry' package '$pkg_name/$pkg_vers'"
    bldr_log_split
    
    if [ ! -d $module_dir ]
    then 
        bldr_make_dir "$module_dir"
        bldr_log_split
    fi

    if [ -f $module_file ]
    then
        bldr_remove_file $module_file
        bldr_log_split
    fi

    local pkg_title=$(bldr_make_uppercase $pkg_name)
    pkg_title=$(echo $pkg_title|sed 's/-/_/g')

    pkg_cfg=$(bldr_trim_list_str "$pkg_cfg")
    if [ "$pkg_cfg" != "" ] && [ "$pkg_cfg" != " " ] && [ "$pkg_cfg" != ":" ]
    then
        pkg_cfg="$(echo $pkg_cfg | bldr_split_str ":" | bldr_join_str " ")"
    else
        pkg_cfg=""
    fi

    pkg_cflags=$(bldr_trim_list_str "$pkg_cflags")
    if [ "$pkg_cflags" != "" ] && [ "$pkg_cflags" != " " ]  && [ "$pkg_cflags" != ":" ]
    then
        pkg_cflags="$(echo $pkg_cflags | bldr_split_str ":" | bldr_join_str " ")"
    else
        pkg_cflags=""
    fi

    pkg_ldflags=$(bldr_trim_list_str "$pkg_ldflags")
    if [ "$pkg_ldflags" != "" ] && [ "$pkg_ldflags" != " " ] && [ "$pkg_ldflags" != ":" ]
    then
        pkg_ldflags="$(echo $pkg_ldflags | bldr_split_str ":" | bldr_join_str " ")"
    else
        pkg_ldflags=""
    fi

    pkg_opts=$(bldr_trim_list_str "$pkg_opts")
    if [ "$pkg_opts" != "" ] && [ "$pkg_opts" != " " ] && [ "$pkg_opts" != ":" ]
    then
        pkg_opts="$(echo $pkg_opts | bldr_split_str ":" | bldr_join_str " ")"
    else
        pkg_opts=""
    fi

    pkg_urls=$(bldr_trim_list_str "$pkg_urls")
    pkg_urls=$(bldr_trim_url_str "$pkg_urls")
    if [ "$pkg_urls" != "" ] && [ "$pkg_urls" != " " ] && [ "$pkg_urls" != ":" ]
    then
        pkg_urls="$(echo $pkg_urls | bldr_split_str ";" | bldr_join_str " ")"
    else
        pkg_urls=""
    fi

    pkg_uses=$(bldr_trim_list_str "$pkg_uses")
    if [ "$pkg_uses" != "" ] && [ "$pkg_uses" != " " ] && [ "$pkg_uses" != ":" ]
    then
        pkg_uses=$(echo $pkg_uses | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_uses=""
    fi

    pkg_reqs=$(bldr_trim_list_str "$pkg_reqs")
    if [ "$pkg_reqs" != "" ] && [ "$pkg_reqs" != " " ] && [ "$pkg_reqs" != ":" ]
    then
        pkg_reqs=$(echo $pkg_reqs | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_reqs=""
    fi

    local pkg_env_prefix=$(echo $pkg_title | bldr_join_str "_")

    echo "#%Module 1.0"                                     >  $module_file
    echo "#"                                                >> $module_file
    echo "# $pkg_title $pkg_vers module for use with 'environment-modules' package." >> $module_file
    echo "#"                                                >> $module_file
    echo "# Generated by BLDR $BLDR_VERSION_STR on $tstamp" >> $module_file
    echo "# -- PkgCategory:   '$pkg_ctry'"                  >> $module_file
    echo "# -- PkgName:       '$pkg_name'"                  >> $module_file
    echo "# -- PkgVersion:    '$pkg_vers'"                  >> $module_file
    echo "# -- PkgInfo:       '$pkg_info'"                  >> $module_file
    echo "# -- PkgFile:       '$pkg_file'"                  >> $module_file
    echo "# -- PkgUrls:       '$pkg_urls'"                  >> $module_file
    echo "# -- PkgOptions:    '$pkg_opts'"                  >> $module_file
    echo "# -- PkgUses:       '$pkg_uses'"                  >> $module_file
    echo "# -- PkgRequires:   '$pkg_reqs'"                  >> $module_file
    echo "# -- PkgCFlags:     '$pkg_cflags'"                >> $module_file
    echo "# -- PkgLDFlags:    '$pkg_ldflags'"               >> $module_file
    echo "# -- PkgConfig:     '$pkg_cfg'"                   >> $module_file
    echo "# -- PkgConfigPath: '$pkg_cfg_path'"              >> $module_file
    echo "#"                                                >> $module_file
    echo ""                                                 >> $module_file
    echo "proc ModulesHelp { } { "                          >> $module_file
    echo "    puts stderr \"Provides module environment support for $pkg_title v$pkg_vers.\"" >> $module_file
    echo "    puts stderr \" \""                            >> $module_file

    local line_string=""
    local pkg_desc_lines=$(echo $pkg_desc | bldr_split_str ' \n')
    for word in ${pkg_desc_lines}
    do
        line_string="$line_string $word"
        if [[ ${#line_string} -ge 78 ]]
        then
            line_string=$(bldr_trim_str $line_string)
            echo "    puts stderr \"$line_string\""         >> $module_file
            line_string=""
        fi
    done

    if [[ ${#line_string} -ge 1 ]]
    then
        line_string=$(bldr_trim_str $line_string)
        echo "    puts stderr \"$line_string\""             >> $module_file
        line_string=""
    fi
    echo "    puts stderr \" \""                            >> $module_file
    echo "}"                                                >> $module_file
    echo ""                                                 >> $module_file
    echo "module-whatis \"$pkg_info\""                      >> $module_file
    echo ""                                                 >> $module_file

    if [ "$pkg_reqs" != "" ]
    then
        for require in ${pkg_reqs}
        do
            echo "prereq $require" >> $module_file
        done
        echo ""                                                 >> $module_file
    fi

    # pkg specific environment settings
    echo "setenv $pkg_title""_VERSION                       $pkg_vers"       >> $module_file

    if [ -d "$prefix/include" ]
    then
        echo "setenv $pkg_title""_INCLUDE_PATH              $prefix/include" >> $module_file
    fi

    if [ -d "$prefix/inc" ]
    then
        echo "setenv $pkg_title""_INCLUDE_PATH              $prefix/inc"     >> $module_file
    fi

    if [ -d "$prefix/bin" ]
    then
        echo "setenv $pkg_title""_BIN_PATH                  $prefix/bin"     >> $module_file
    fi

    if [ -d "$prefix/sbin" ]
    then
        echo "setenv $pkg_title""_SBIN_PATH                 $prefix/sbin"    >> $module_file
    fi

    if [ -d "$prefix/lib" ]
    then
        echo "setenv $pkg_title""_LIB_PATH                  $prefix/lib"     >> $module_file
    fi

    if [ -d "$prefix/lib32" ]
    then
        echo "setenv $pkg_title""_LIB32_PATH                $prefix/lib32"   >> $module_file
    fi

    if [ -d "$prefix/lib64" ]
    then
        echo "setenv $pkg_title""_LIB64_PATH                $prefix/lib64"   >> $module_file
    fi

    if [ -d "$prefix/man" ]
    then
        echo "setenv $pkg_title""_MAN_PATH                  $prefix/man"     >> $module_file
    fi

    if [ -d "$prefix/share" ]
    then
        echo "setenv $pkg_title""_SHARE_PATH                $prefix/share"   >> $module_file
    fi

    if [ -d "$prefix/etc" ]
    then
        echo "setenv $pkg_title""_CONFIG_PATH               $prefix/etc"     >> $module_file
    fi

    echo ""                                                      >> $module_file

    # system specific environment settings

    if [ -d "$prefix/bin" ]
    then
        echo "prepend-path PATH                 $prefix/bin"     >> $module_file
    fi

    if [ -d "$prefix/sbin" ]
    then
        echo "prepend-path PATH                 $prefix/sbin"    >> $module_file
    fi

    if [ -d "$prefix/inc" ]
    then
        echo "prepend-path C_INCLUDE_PATH       $prefix/inc"     >> $module_file
        echo "prepend-path CPLUS_INCLUDE_PATH   $prefix/inc"     >> $module_file
        echo "prepend-path CPATH                $prefix/inc"     >> $module_file
        echo "prepend-path FPATH                $prefix/inc"     >> $module_file
    fi

    if [ -d "$prefix/include" ]
    then
        echo "prepend-path C_INCLUDE_PATH       $prefix/include" >> $module_file
        echo "prepend-path CPLUS_INCLUDE_PATH   $prefix/include" >> $module_file
        echo "prepend-path CPATH                $prefix/include" >> $module_file
        echo "prepend-path FPATH                $prefix/include" >> $module_file
    fi

    if [ -d "$prefix/lib" ]
    then
        if [ $BLDR_SYSTEM_IS_OSX != 0 ]
        then
            echo "prepend-path DYLD_LIBRARY_PATH    $prefix/lib"     >> $module_file
        fi
        echo "prepend-path LD_LIBRARY_PATH          $prefix/lib"     >> $module_file
        echo "prepend-path LIBRARY_PATH             $prefix/lib"     >> $module_file
    fi

    if [ -d "$prefix/lib32" ]
    then
        echo "prepend-path LD_LIBRARY_PATH      $prefix/lib32"   >> $module_file
        echo "prepend-path LIBRARY_PATH         $prefix/lib32"   >> $module_file
    fi

    if [ -d "$prefix/lib64" ]
    then
        echo "prepend-path LD_LIBRARY_PATH      $prefix/lib64"   >> $module_file
        echo "prepend-path LIBRARY_PATH         $prefix/lib64"   >> $module_file
    fi

    if [ -d "$prefix/man" ]
    then
        echo "prepend-path MANPATH              $prefix/man"     >> $module_file
    fi

    if [ -d "$prefix/locale" ]
    then
        echo "prepend-path NLSPATH              $prefix/locale"  >> $module_file
    fi

    if [ -d "$prefix/share/man" ]
    then
        echo "prepend-path MANPATH              $prefix/share/man" >> $module_file
    fi

    if [ -d "$prefix/share/info" ]
    then
        echo "prepend-path INFOPATH             $prefix/share/info" >> $module_file
    fi

    if [ -d "$prefix/share/locale" ]
    then
        echo "prepend-path NLSPATH              $prefix/share/locale" >> $module_file
    fi

    echo ""                                                         >> $module_file


    bldr_log_info "Linking module '$pkg_name/$pkg_vers' as '$pkg_name/latest' ..."
    bldr_log_split    

    if [ -e "$module_dir/latest" ]
    then
        bldr_remove_file "$module_dir/latest"
    fi

    if [ $BLDR_VERBOSE != false ]
    then       
        ln -sv "$module_dir/$pkg_vers" "$module_dir/latest" || bldr_bail "Failed to link latest module version to '$pkg_name/$pkg_vers'!"
        bldr_log_split    
    else
        ln -s "$module_dir/$pkg_vers" "$module_dir/latest" || bldr_bail "Failed to link latest module version to '$pkg_name/$pkg_vers'!"
    fi
}

####################################################################################################

function bldr_build_pkg()
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
    local pkg_patches=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="true"; shift;;
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
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
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

    if [ "$pkg_name" == "" ] || [ "$pkg_vers" == "" ] || [ "$pkg_file" == "" ]
    then
        bldr_bail "Incomplete package definition!  Need at least 'name', 'version' and 'file' defined!"
    fi

    local existing=$(bldr_has_pkg --category "$pkg_ctry" --name "$pkg_name" --version "$pkg_vers" --options "$pkg_opts")

    if [ "$existing" != "false" ]
    then
        if [ $BLDR_VERBOSE != false ]
        then
            bldr_log_header "Skipping existing package '$pkg_name/$pkg_vers' ... "
            bldr_log_split
        fi
        return
    fi

    if [ $BLDR_VERBOSE != false ]
    then
        bldr_log_split
        echo "PkgCategory:   '$pkg_ctry'"
        echo "PkgName:       '$pkg_name'"
        echo "PkgVersion:    '$pkg_vers'"
        echo "PkgInfo:       '$pkg_info'"
        echo "PkgFile:       '$pkg_file'"
        echo "PkgUrls:       '$pkg_urls'"
        echo "PkgOptions:    '$pkg_opts'"
        echo "PkgUses:       '$pkg_uses'"
        echo "PkgRequires:   '$pkg_reqs'"
        echo "PkgCFlags:     '$pkg_cflags'"
        echo "PkgLDFlags:    '$pkg_ldflags'"
        echo "PkgConfig:     '$pkg_cfg'"
        echo "PkgConfigPath: '$pkg_cfg_path'"
        echo "PkgPatches:    '$pkg_patches'"
        echo "PkgDesc:      "
        echo " "
        echo "$pkg_desc"
        echo " "
    fi

    local override_setup=$(type -t bldr_pkg_setup_method)
    local override_fetch=$(type -t bldr_pkg_fetch_method)
    local override_boot=$(type -t bldr_pkg_boot_method)
    local override_config=$(type -t bldr_pkg_config_method)
    local override_compile=$(type -t bldr_pkg_compile_method)
    local override_install=$(type -t bldr_pkg_install_method)
    local override_migrate=$(type -t bldr_pkg_migrate_method)
    local override_modulate=$(type -t bldr_pkg_modulate_method)
    local override_cleanup=$(type -t bldr_pkg_cleanup_method)

    # Call the overridden package methods for each build phase if they were defined
    # -- otherwise use the default internal ones (which should handle 90% of most packages)
    if [  "$override_setup" == "function" ]
    then
        bldr_pkg_setup_method             \
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
    else
        bldr_setup_pkg                    \
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
    fi

    if [ "$override_fetch" == "function" ]
    then
        bldr_pkg_fetch_method             \
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
    else
        bldr_fetch_pkg                    \
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
    fi

    if [ "$override_boot" == "function" ]
    then
        bldr_pkg_boot_method              \
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
    else
        bldr_boot_pkg                     \
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
    fi

    if [ "$override_config" == "function" ]
    then
        bldr_pkg_config_method            \
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
    else
        bldr_config_pkg                   \
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
    fi

    if [ "$override_compile" == "function" ]
    then
        bldr_pkg_compile_method           \
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
    else
        bldr_compile_pkg                  \
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
    fi

    if [ "$override_install" == "function" ]
    then
        bldr_pkg_install_method           \
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
    else
        bldr_install_pkg                  \
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
    fi

    if [ "$override_migrate" == "function" ]
    then
        bldr_pkg_migrate_method           \
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
    else
        bldr_migrate_pkg                  \
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
    fi

    if [ "$override_modulate" == "function" ]
    then
        bldr_pkg_modulate_method          \
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
    else
        bldr_modulate_pkg                 \
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
    fi

    if [ "$override_cleanup" == "function" ]
    then
        bldr_pkg_cleanup_method           \
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
    else
        bldr_cleanup_pkg                  \
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
    fi

    bldr_log_header "DONE with '$pkg_name/$pkg_vers'! --"
    bldr_log_split
}

####################################################################################################

function bldr_build_pkgs()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 

    while true ; do
        case "$1" in
           --verbose)       use_verbose="true"; shift;;
           --name)          pkg_name="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    local pkg_ctry=$(echo "$pkg_ctry" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_list=$(echo "$pkg_name" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_dir="$BLDR_PKGS_DIR"

    if [ ! "$pkg_ctry" ]
    then
        pkg_ctry="*"
    fi

    # push the system category onto the list if it hasn't been built yet
    if [[ ! -d $BLDR_LOCAL_DIR/system ]]
    then
        if [[ $(echo $pkg_ctry | grep -c 'system' ) < 1 ]]
        then
            pkg_ctry="system $pkg_ctry"
        fi
    fi

    pkg_ctry=$(bldr_trim_str $pkg_ctry)
    pkg_list=$(bldr_trim_str $pkg_list)

    if [[ -d $pkg_dir ]]
    then
        local builder
        bldr_log_split
        bldr_log_header "Starting build for '$pkg_ctry' in '$pkg_dir'..."
        bldr_log_split
        for pkg_category in $pkg_ctry
        do
            for pkg_def in "$pkg_dir/$pkg_category"/*
            do
                if [[ ! -x $pkg_def ]]
                then
                    continue
                fi

                if [[ "$pkg_list" == "" ]] 
                then
                    eval $pkg_def || exit -1
                else
                    for entry in $pkg_list 
                    do
                        local m=$(echo "$pkg_def" | grep -c $entry )
                        if [[ $m > 0 ]]
                        then
                            eval $pkg_def || exit -1
                        fi
                    done
                fi
            done
        done
    fi
}

####################################################################################################

