# Primordial Machine's External Dependencies Project

## What is Primordial Machine's External Dependencies Project
Primordial Machine's External Dependencies is a project that
- logically separates external dependencies from the source codes of
  [Primordial Machine](https://bitbucket.org/primordialmachine/primordialmachine/).
- protects the Primordial Machine's developers from idiosyncracies of particualr
  dependencies
- allows for centralized and uniform method of maintaining these dependencies.

## Building using CMake
The project requires Git and CMake to build to be in your path as well as
the reachability of the following Git repositories:
- [FreeType](https://gitlab.freedesktop.org/freetype/freetype.git)
- [libpng](https://github.com/glennrp/libpng.git)

The following steps perform an out-of-source build of this project.

- Clone this repository into a directory called `primordialmachine-dependencies`.
  If you did everything correctly, then you should find this README file in
  `primordialmachine-dependencies\README.md`.

- Open a console and enter the directory `primordialmachine-dependencies`.
  Enter `cd ..` to enter the parent directory.
  We assume in the parent directory no folder `primordialmachine-dependencies-build` exists.
  Enter `mkdir primordialmachine-dependencies-build` to create an empty build directory and `cd primordialmachine-dependencies-build` to enter it.
  
- Enter `cmake .\..\primordialmachine-dependencies` to build this project.

The command `cmake .\..\primordialmachine-dependencies` generates build files for the default target platform architecture.
You can explicitly specify the target platform architecture `x64` and the `Win32` by using the
`cmake -A x64 \..\primordialmachine-dependencies` and - `cmake -A Win32 \..\primordialmachine-dependencies`, respectively.
