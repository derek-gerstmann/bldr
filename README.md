
                                                         
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

To build a list of packages by name (eg cmake, hdf5, etc):

    > ./scripts/bldr build -n cmake -n hdf5

To force a build of a specific category/package/version (eg cmake, hdf5, etc):

    > ./scripts/bldr build -c storage -n hdf5 -v 1.8.9 --verbose --force

To use the generated modulefiles in the 'bldr/modules', simply use them via modules:

    > cd bldr
    > source ./scripts/setup.sh
    > module use cmake





