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

# determine abs path
BLDR_SCRIPT_PATH="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

# setup project paths
BLDR_SCRIPT_PATH="$( dirname "$BLDR_SCRIPT_PATH/.." )"
BLDR_ABS_PWD="$( dirname "$BLDR_SCRIPT_PATH/.." )"
BLDR_ROOT_PATH="$( dirname "$BLDR_ABS_PWD/.." )"
BLDR_BASE_PATH="$( basename "$BLDR_ABS_PWD" )"

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

####################################################################################################

function bldr_load() 
{
	local ctgry_dir=""
	if [[ -d "$BLDR_ROOT_PATH/modules" ]]
	then
		for ctgry_dir in $BLDR_ROOT_PATH/modules/*
		do
			local ctgry_name=$(basename "$ctgry_dir")
			module use "$BLDR_ROOT_PATH/modules/$ctgry_name"
		done
	fi

	if [[ -d "$BLDR_ROOT_PATH/modules/internal" ]]
	then
		module load "bldr/default"
	fi
}

####################################################################################################

function bldr_unload()
{
	local ctgry_dir=""
	local ctgry_name=""

	if [[ -d "$BLDR_ROOT_PATH/modules" ]]
	then
		for ctgry_dir in $BLDR_ROOT_PATH/modules/*
		do
			ctgry_name=$(basename "$ctgry_dir")

			if [[ "$ctgry_name" == "internal" ]]; then
				continue
			fi

			module unuse "$BLDR_ROOT_PATH/modules/$ctgry_name"
		done
	fi

	if [[ -d "$BLDR_ROOT_PATH/modules/internal" ]] 
	then
		local internal_path=""
		for internal_path in "$BLDR_ROOT_PATH/modules/internal"/*
		do
			internal_base=$(basename $internal_path)
			module unload -f $internal_base
		done
		module unuse "$BLDR_ROOT_PATH/modules/internal"
	fi
}

####################################################################################################
# load the local BLDR package repository
####################################################################################################

# ensure we are run inside of the root dir
if [ ! -f "$BLDR_ROOT_PATH/system/bldr.sh" ]
then
    echo "Please execute package build script from within the 'bldr' subfolder: '$BLDR_ROOT_PATH'!"

else
	
	if [ "$(type -t module)" != "function" ]
	then
		BLDR_MODULE_CMD_INIT=$(find $BLDR_ROOT_PATH/local/internal/modules/default/* -depth +2 -type f -iname "bash")
		if [[ -f "$BLDR_MODULE_CMD_INIT" ]]; then	
			source "$BLDR_MODULE_CMD_INIT"
		fi
		export BLDR_MODULE_CMD=$(which 'modulecmd')
	fi

	if [ "$(type -t module)" != "function" ]
	then
		bldr_bail "Failed to locate module environment!  Exiting!"
	fi	

	bldr_load
fi 

####################################################################################################



