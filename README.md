
                                                         
                                         /    /    |     
                                        (___ (  ___| ___ 
                                        |   )| |   )|   )
                                        |__/ | |__/ |    
                                                         													
       						 a modular software environment builder


About **bldr**
==================

**bldr** is a simple, straight-forward system that automates the process of building software packages from source with customisable configurations into self-contained, tagged and versioned modules. 

It has minimal requirements and will generally run on any BSD/Unix/Posix system that has GNU tools and BASH.

This system was written to help ease the burden of deploying software in HPC environments, and to avoid relying on arbitrary libraries, paths and environments which may interfere with performance critical code.

If you are looking for a decentralised repository, or a packaging system with all the bells and whistles, you're probably better off with RPMs, DEBs, PORTs, FINK, Portage, EBUILDS etc.

However, if you routinely recompile large software packages from source or repositories and need the ability to fine tune the various compilation flags and test out different builds with different compilers, you may find BLDR useful.

It integrates the modules software environment into a source compilation build framework that generates localised, stand-alone binary products, tracks dependencies, and supports dynamic environment changes.


The **bldr** build process
------------------

*BLDR* adopts the following pipeline for building each package:

    1. Setup: initialises the software package environment
    2. Fetch: retrieves source tarball or clones from repository
    3. Boot: launches any boot scripts to bootstrap source tree
    4. Config: configures the source tree (eg via automake or *cmake*)
    5. Compile: compiles the package (eg via make)
    6. Install: installs the package (eg via make)
    7. Migrate: migrates any additional files into the install path
    8. Modulate: creates a module file to encapsulate the shell environment
    9. Link: updates the 'default' and 'current' symlinked versions for local installs and module files
    10. Cleanup: removes any temporary build files

Each of the above build phases can be overridden by a package build specification, and each of these phases are optional.


Using **bldr**
------------------

For standard usage, create a new subdir in the 'bldr/pkgs' folder for a new modular distribution, and add a set of ordered package definition scripts based on their cross-dependencies.

Then, build your modular distribution via the build script:

    > cd bldr
    > ./scripts/bldr -c category -n name

The build script will launch off a new process and perform the following:
    
    * Fetch any necessary files for the package
        * Download tarball source packages 
        * Checkout code from source control (git / svn)
    * Configure the source tree with any specified options (detailed in the package specification)
        * Apply any necessary patches to the source tree
    * Compile using whatever detected build scripts were included in the distribution:   
        * autoconf / cmake / makefile / ruby gem / python setup / maven
    * Generate build output in 'bldr/build/pkg/version'
    * Install the build products into 'bldr/local/pkg/version'
    * Migrate any user specified data that was not automatically installed (eg pkgconfig files)
    * Generate a modulefile for use with the 'environment module' system
    * Update symlinks for latest builds / module files
    * Cleanup the build folder

Examples
------------------

To build an entire category (eg internal):

    > cd bldr
    > ./scripts/bldr build -c internal

For a normal 'build' all stages are invoked automatically.  However, this is just an alias, and the same behaviour could be achieved via invoking the *bldr* script using the following command line:
    
    > ./scripts/bldr setup fetch boot config compile install migrate modulate link cleanup

To build a list of packages by name (eg cmake, hdf5, etc):

    > ./scripts/bldr build -n cmake -n hdf5

To force a build of a specific category/package/version (eg cmake, hdf5, etc):

    > ./scripts/bldr build -c storage -n hdf5 -v 1.8.9 --verbose --force

To use the generated modulefiles in the 'bldr/modules', simply use them via modules:

    > cd bldr
    > source ./scripts/setup.sh
    > module use cmake

Package Developers 
==================

Package definitions are defined in the *bash* scripting language, and stored in the ./pkgs subfolder.  The current package organisational layout uses the following directory and naming conventions:

    * ./pkgs/CATEGORY/###-NAME.sh

In this case, CATEGORY is a filesystem conformant string (eg w/o spaces or funky characters) which corresponds to an arbitrary category of packages.  Likewise, NAME corresponds to an arbitrary package name.  The digits prefixing the package name (###) define the build order (which increases numerically -- smaller values force packages in the category to get built first).

In order for *bldr* to find a new package definition script, it must be placed in an existing category subdirectory, and should have executable permissions:

    > chmod +x ./pkgs/CATEGORY/###-NAME.sh

Any non-executable script will be ignored (which makes it easy to disable from a full deployment).

Registration
------------------

The body of a package definition script needs to minimally include the *bldr* system, and register a package via the *bldr_register_pkg* method:

    > source "bldr.sh"

    > bldr_register_pkg                \
    >     --category    "$pkg_ctry"    \
    >     --name        "$pkg_name"    \
    >     --version     "$pkg_vers"    \
    >     --default     "$pkg_default" \
    >     --info        "$pkg_info"    \
    >     --description "$pkg_desc"    \
    >     --file        "$pkg_file"    \
    >     --url         "$pkg_urls"    \
    >     --uses        "$pkg_uses"    \
    >     --requires    "$pkg_reqs"    \
    >     --options     "$pkg_opts"    \
    >     --cflags      "$pkg_cflags"  \
    >     --ldflags     "$pkg_ldflags" \
    >     --config      "$pkg_cfg"     \
    >     --config-path "$pkg_cfg_path"

The example above uses bash variables for specifying the values using the BLDR vairable name conventions.  Note that all arguments are passed by value as strings.  

The flags for the *bldr_register_pkg* are explained below:

    * --category     - category name for this package ^
    * --name         - name for this package ^ 
    * --version      - version identifier for this package ^
    * --default      - the default version to use for the system deployment ^
    * --info         - short one-line description describing the package
    * --description  - longer paragraph description describing the package
    * --file         - filename of tarball or source distribution for the package (will get created if URL is GIT/CVS/SVN)
    * --url          - list of mirrors to obtain the source distribution from (can be http://, git://, svn://, or cvs://) $
    * --uses         - list of BLDR packages needed to BUILD the package at COMPILE TIME %
    * --requires     - list of BLDR packages needed to USE the package at RUNTIME %
    * --options      - list of BLDR options defining the build behaviour (see list below) %
    * --cflags       - list of flags to pass to the compiler %
    * --ldflags      - list of flags to pass to the linker %
    * --config       - list of flags to pass to the configure script for the build system %

    * ^ Must be a filesystem conformant string
    * % List of values specified as a space delimited string
    * $ List of values specified as a semi-colon delimited list

Options
------------------

A number of BLDR options are available to define the specific build behaviour for the package (see --options for the *bldr_register_pkg* method description above).  The are outline below:

    * cmake         - use the cmake build system (uses internal BLDR version of cmake)
    * configure     - use the autoconf/automake build system (uses internal BLDR versions of autoconf/automake)
    * qmake         - use the qmake build system from QT (uses internal BLDR version of QT)
    * scons         - use the scons build system (uses internal BLDR versions of scons)
    * maven         - use the maven build system for (requires java to be installed on the system)
    * ant           - use the ant build system for (requires java to be installed on the system)
    * ruby          - use the ruby build system for installing modules or gems (uses internal BLDR versions of ruby)
    * python        - use the python build system for installing python modules (uses internal BLDR versions of python)

    * -Mkey=value               - pass key-value pair as a macro to the make command (eg. -MMAKE_EXAMPLES=0 -> MAKE_EXAMPLES=0)
    * -Ekey=value               - add key-value pair to the list of exported enviroment variables in the generated module file

    * enable-shared             - build shared libraries (if possible)
    * enable-static             - build static libraries (if possible)

    * force-static              - build only static and disable shared libraries (if possible)
    * force-shared              - build only shared and disable static libraries (if possible)

    * force-serial-build        - don't run the build in parallel (ie don't use make -j)
    * force-inplace-build       - force an in-place build (in the source tree, rather than in a build subfolder)    
    * force-bootstrap           - force any bootstrap script to get executed (found automatically)
    * no-bootstrap-prefix       - don't pass a --prefix flag to the bootstrap script

    * config-prepend-env        - prepend all build settings as environment variables when invoking the build system rather than as flags or options
    * config-disable-prefix     - don't pass a --prefix flag to the configure script

    * use-make-envflags         - prepend all build settings as environment variables when invoking make
    * use-make-build-target=STR - use a custom make build target
    * use-make-install-target=STR - use a custom make install target

    * use-setup-makefile=STR    - use a custom setup makefile (rather than a configure script)
    * use-build-dir=STR         - use a custom build directory (overriding the standard build subfolder)   
    * use-build-script=STR      - use a custom build script (overriding any detected build script)
    * use-build-makefile=STR    - use a custom makefile (overriding any detected makefile script)
    * use-gem                   - use gem for a ruby module build instead of ruby

    * create-local-base-path    - create the ./local base directory for the package (if the build system doesn't)
    * create-local-bin-path     - create the ./local binary directory for the package (if the build system doesn't)
    * create-local-lib-path     - create the ./local library directory for the package (if the build system doesn't)
    * create-local-include-path - create the ./local include directory for the package (if the build system doesn't)

    * migrate-build-tree        - migrate the entire build tree and install it into the ./local path (eg instead of using an install script)
    * migrate-build-headers     - migrate any header files and/or folders in the build tree and install it into the ./local path 
    * migrate-build-docs        - migrate any documentation files and/or folders in the build tree and install it into the ./local path 
    * migrate-build-source      - migrate any source files and/or folders in the build tree and install it into the ./local path 
    * migrate-build-bin         - migrate any binary files, libraries and/or folders in the build tree and install it into the ./local path 
    * migrate-skip-libs         - skip any binary libraries when migrating from the build tree
        
    * pkg-update                - update any installed package that's older than the package definition script
    * force-rebuild             - force a rebuild (obliterating any existing version)
    * quiet                     - reduce verbosity in console messages

    * keep                      - keep all temporary build files after a build completes
    * keep-going                - attempt to keep going if any errors are encountered (skipping any packages that failed to build)
    * keep-build-tree           - keep the build tree for the current package
    * keep-build-ctry           - keep the build directory for the current package's category
    * keep-existing-install     - keep any existing installations in the ./local path for the current package

    * skip-setup                - skip the setup stage
    * skip-fetch                - skip the fetch stage
    * skip-boot                 - skip the boot stage
    * skip-config               - skip the config stage
    * skip-compile              - skip the compile stage
    * skip-install              - skip the install stage
    * skip-migrate              - skip the migrate stage
    * skip-modulate             - skip the modulate stage
    * skip-link                 - skip the link stage

    * skip-system-flags         - skip all the automatic BLDR system build flags
    * skip-system-cflags        - skip just the BLDR compiler system flags
    * skip-system-ldflags       - skip just the BLDR linker system flags
    * skip-system-patches       - don't apply any system patches (found in the ./patches/PKG-NAME/PKG-VERS/ folders)

    * skip-xcode-config         - skip the automatic BLDR XCODE config flags (for OSX only)
    * skip-xcode-cflags         - skip the automatic BLDR XCODE compiler flags (for OSX only)
    * skip-xcode-ldflags        - skip the automatic BLDR XCODE linker flags (for OSX only)

    * use-prefix-path=STR       - use a custom install prefix path 
    * use-local-path=STR        - use a custom local install path
    * use-module-path=STR       - use a custom module install path



    

Commands
------------------

Individual commands for a build can be run separately, or skipped entirely.  The list of available commands is:

    * setup - creates skeleton directory structure to support a new build
    * fetch - retrieves the tarball or source distribution from ./cache or from a URL
    * boot - extracts the source tree from the source distribution and/or runs a bootstrap script
    * config - runs the configure script for the build system
    * compile - invokes the compiler for the build system
    * install - invokes the install method for the build system to populate the ./local install path
    * migrate - moves any leftover build products into the ./local install path tree
    * modulate - generates a module file based on the build products 
    * link - generates symlinks for current and default versions for the installed packages and modules
    * cleanup - obliterates the build tree for the current package

Commands can be disabled in the package definition script (if they aren't necessary or don't apply to the package) by specifying the appropriate *skip* option to the package definition:

    * pkg_opts='skip-boot skip-install'


