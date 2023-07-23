#
New-Item -ItemType Directory -Force -Path .\source-freetype
cd .\source-freetype
git clone https://gitlab.freedesktop.org/freetype/freetype/ .
cd ..

function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $CMakeArchitecture,
    [Parameter()] [string] $Configuration
  )
  $suffix="$Architecture-$($Configuration.ToLower())"
  New-Item -ItemType Directory -Force -Path .\build-freetype-$suffix
  cd .\build-freetype-$suffix
  cmake -DPNG_PNG_INCLUDE_DIR=".\..\package-libpng-$suffix\libpng\include" `
        -DPNG_LIBRARY=".\..\package-libpng-$suffix\libpng\lib\libpng.lib" `
        -DZLIB_INCLUDE_DIR=".\..\package-zlib-$suffix\zlib\include" `
        -DZLIB_LIBRARY=".\..\package-zlib-$suffix\zlib\lib\zlib.lib" `
        -DBUILD_SHARED_LIBS=false `
        -A $CMakeArchitecture -S .\..\source-freetype .
  cmake --build . 
  cmake --build . --config $Configuration --target package
  cd ..

  Remove-Item -Recurse -Force .\package-freetype-$suffix
  New-Item -ItemType Directory -Force -Path .\package-freetype-$suffix
  Expand-Archive -LiteralPath .\build-freetype-$suffix\freetype-2.13.1-win32.zip .\package-freetype-$suffix
  mv .\package-freetype-$suffix\freetype-2.13.1-win32 .\package-freetype-$suffix\freetype
  mv .\package-freetype-$suffix\freetype\include\freetype2\* .\package-freetype-$suffix\freetype\include
  Remove-Item -Recurse -Force .\package-freetype-$suffix\freetype\include\freetype2
  Compress-Archive -Force -Path .\package-freetype-$suffix\* -DestinationPath .\freetype-$suffix.zip
}

build -Architecture 'x86' -CMakeArchitecture 'Win32' -Configuration 'RelWithDebInfo'
build -Architecture 'x86' -CMakeArchitecture 'Win32' -Configuration 'MinSizeRel'
build -Architecture 'x86' -CMakeArchitecture 'Win32' -Configuration 'Debug'
build -Architecture 'x86' -CMakeArchitecture 'Win32' -Configuration 'Release'

build -Architecture 'x64' -CMakeArchitecture 'x64' -Configuration 'RelWithDebInfo'
build -Architecture 'x64' -CMakeArchitecture 'x64' -Configuration 'MinSizeRel'
build -Architecture 'x64' -CMakeArchitecture 'x64' -Configuration 'Debug'
build -Architecture 'x64' -CMakeArchitecture 'x64' -Configuration 'Release'
