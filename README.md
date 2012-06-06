
                                                         
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

Using **bldr**
------------------

For standard usage, create a new subdir in the 'bldr/pkgs' folder for a new modular distribution, and add a set of ordered package definition scripts based on their cross-dependencies.

Then, build your modular distribution via the build script:

    > cd bldr
    > ./scripts/build.sh my-module

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
    > ./scripts/build.sh system




