
                                                         
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
    9. Cleanup: removes any temporary build files

Each of the above build phases can be overridden by a package build specification, and each of these phases are optional.


Using **bldr**
------------------

For standard usage, create a new subdir in the 'bldr/pkgs' folder for a new modular distribution, and add a set of ordered package definition scripts based on their cross-dependencies.

Then, build your modular distribution via the build script:

    > cd bldr
    > ./scripts/build.sh -c category -n name

The build script will launch off a new process and perform the following:
    
    * download any necessary tarball source packages (or checkout code from source control)
    * configure the source tree with any specified options (detailed in the package scripts)
    * compile using whatever detected build scripts were included in the distribution:   
        * autoconf
        * cmake
        * makefile
    * generate build output in 'bldr/build/pkg/version'
    * install the build products into 'bldr/local/pkg/version'
    * migrate any user specified data that was not automatically installed 
    * generate a modulefile for use with the 'environment module' system
    * generate symlinks for latest builds / module files

Example packages
------------------

See the existing autoconf, automake, and pkgconfig scripts in the pkgs/system folder as examples:

    > cd bldr
    > ls pkgs/system
    > ./scripts/build.sh -c system

To use the generated modulefiles in the 'bldr/modules', simply use them via modules:

    > cd bldr
    > module use ../bldr/modules





