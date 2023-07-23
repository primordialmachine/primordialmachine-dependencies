# Primordial Machine's External Dependencies Project

## What is Primordial Machine's External Dependencies Project
Primordial Machine's External Dependencies is a project that
- logically separates external dependencies from the source codes of
  [Primordial Machine](https://github.com/primordialmachine/primordialmachine/).
- protects the Primordial Machine's developers from idiosyncracies of dependencies
- allows for centralized and uniform method of maintaining these dependencies.

## Requirements
This project requires GIT and KitWare's CMake to build.

## Building using CMake
The project requires Git and CMake to build to be in your path as well as
the reachability of the following Git repositories:
- [freetype](https://gitlab.freedesktop.org/freetype/freetype.git)
- [libpng](https://github.com/glennrp/libpng.git)
- [zlib] (https://github.com/madler/zlib.git)

The following steps perform an in-source build (out of source builds are not yet supported).

- Clone this repository into a directory called `primordialmachine-dependencies`.
  If you did everything correctly, then you should find this README file in
  `primordialmachine-dependencies\README.md`.

- Open a console and enter the directory `primordialmachine-dependencies`.
  Enter `./build.ps1`. If the build succeeds, you should find the zip files
  - `zlib-x86.zip`,
  - `zlib-x64.zip`,
  - `libpng-x86.zip`,
  - `libpng-x64.zip`,
  - `freetype-x86.zip`,
  - `freetype-x64.zip`,
  in this directory.
  Enter `./clean.ps1` to remove the intermediate files.
