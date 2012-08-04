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

export PATH="./scripts:../scripts:./system:../system:$PATH"

####################################################################################################

# setup project paths
BLDR_ABS_PWD="$( cd "$( dirname ".$0" )" && pwd )"
BLDR_ROOT_PATH="$( dirname "$BLDR_ABS_PWD/.." )"
BLDR_BASE_PATH="$( basename "$BLDR_ABS_PWD" )"

# try one level up if we aren't resolving the root dir
if [ ! -f "$BLDR_ROOT_PATH/system/bldr.sh" ]
then
    BLDR_ABS_PWD="$( cd "$( dirname ".$0" )/.." && pwd )"
    BLDR_ROOT_PATH="$( dirname "$BLDR_ABS_PWD/.." )"
    BLDR_BASE_PATH="$( basename "$BLDR_ABS_PWD" )"
fi

# try one level up if we aren't resolving the root dir
if [ ! -f "$BLDR_ROOT_PATH/system/bldr.sh" ]
then
    BLDR_ABS_PWD="$( cd "$( dirname ".$0" )/../.." && pwd )"
    BLDR_ROOT_PATH="$( dirname "$BLDR_ABS_PWD/.." )"
    BLDR_BASE_PATH="$( basename "$BLDR_ABS_PWD" )"
fi

####################################################################################################

# ensure we are run inside of the root dir
if [ ! -f "$BLDR_ROOT_PATH/system/bldr.sh" ]
then
    echo "Please execute package build script from within the 'bldr' subfolder: '$BLDR_ABS_PWD' '$BLDR_ROOT_PATH'!"
    exit 0
fi 

####################################################################################################

# setup system paths
BLDR_CONFIG_PATH=${BLDR_CONFIG_PATH:=$BLDR_ROOT_PATH}
export BLDR_SCRIPTS_PATH="$BLDR_CONFIG_PATH/scripts"
export BLDR_PKGS_PATH="$BLDR_CONFIG_PATH/pkgs"
export BLDR_PATCHES_PATH="$BLDR_CONFIG_PATH/patches"
export BLDR_SYSTEM_PATH="$BLDR_CONFIG_PATH/system"
export BLDR_CACHE_PATH="$BLDR_CONFIG_PATH/cache"
export BLDR_BUILD_PATH="$BLDR_CONFIG_PATH/build"

# setup install paths
BLDR_INSTALL_PATH=${BLDR_INSTALL_PATH:=$BLDR_ABS_PWD}
export BLDR_LOCAL_PATH="$BLDR_INSTALL_PATH/local"
export BLDR_MODULE_PATH="$BLDR_INSTALL_PATH/modules"
export BLDR_OS_LIB_EXT="a"

####################################################################################################

export BLDR_SYSTEM_IS_LINUX=$( uname -s | grep -m1 -c Linux )
export BLDR_SYSTEM_IS_OSX=$( uname -s | grep -m1 -c Darwin )
export BLDR_MODULE_CMD=$(which 'modulecmd')

if [ "$(type -t module)" != "function" ]
then
	BLDR_MODULE_CMD_INIT=$(find $BLDR_ROOT_PATH/local/internal/modules/latest/* -depth +2 -type f -iname "bash")
	if [[ -f "$BLDR_MODULE_CMD_INIT" ]]; then	
		source "$BLDR_MODULE_CMD_INIT"
	fi
	export BLDR_MODULE_CMD=$(which 'modulecmd')
fi

if [ "$(type -t module)" != "function" ]
then
	bldr_bail "Failed to locate module environment!  Exiting!"
fi	

####################################################################################################

function bldr_load() 
{
	if [[ -d "$BLDR_ROOT_PATH/modules/internal" ]]; then
		module use "$BLDR_ROOT_PATH/modules/internal"
		for internal_path in "$BLDR_ROOT_PATH/modules/internal"/*
		do
			internal_base=$(basename $internal_path)
			module load $internal_base
		done
	fi

	if [[ -d "$BLDR_ROOT_PATH/modules/system" ]]; then
		module use "$BLDR_ROOT_PATH/modules/system"
	fi

	for ctgry_dir in $BLDR_ROOT_PATH/modules/*
	do
		ctgry_name=$(basename "$ctgry_dir")

		if [[ "$ctgry_name" == "internal" ]]; then
			continue
		fi

		if [[ "$ctgry_name" == "system" ]]; then
			continue
		fi

		module use "$BLDR_ROOT_PATH/modules/$ctgry_name"
	done
}

####################################################################################################

function bldr_unload()
{
	for ctgry_dir in $BLDR_ROOT_PATH/modules/*
	do
		ctgry_name=$(basename "$ctgry_dir")

		if [[ "$ctgry_name" == "internal" ]]; then
			continue
		fi

		if [[ "$ctgry_name" == "system" ]]; then
			continue
		fi

		module unuse "$BLDR_ROOT_PATH/modules/$ctgry_name"
	done

	if [[ -d "$BLDR_ROOT_PATH/modules/system" ]]; then
		module unuse "$BLDR_ROOT_PATH/modules/system"
	fi

	if [[ -d "$BLDR_ROOT_PATH/modules/internal" ]]; then
		for internal_path in "$BLDR_ROOT_PATH/modules/internal"/*
		do
			internal_base=$(basename $internal_path)
			module unload $internal_base
		done
		module unuse "$BLDR_ROOT_PATH/modules/internal"
	fi
}

####################################################################################################

# bldr_load

