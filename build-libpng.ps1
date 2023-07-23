#
New-Item -ItemType Directory -Force -Path .\source-libpng
cd .\source-libpng
git clone https://github.com/glennrp/libpng.git .
cd ..

function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $CMakeArchitecture,
    [Parameter()] [string] $Configuration
  )
  $suffix="libpng-$Architecture-$($Configuration.ToLower())"
  New-Item -ItemType Directory -Force -Path .\build-$suffix
  cd .\build-$suffix
  cmake -DZLIB_INCLUDE_DIRS=".\..\package-zlib-$Architecture-$($Configuration.ToLower())\zlib\include" `
        -DPNG_BUILD_ZLIB=ON `
        -DPNG_SHARED=OFF `
        -DPNG_TESTS=OFF `
        -A $CMakeArchitecture `
        -S .\..\source-libpng
  cmake --build . --config $Configuration
  cd ..

  New-Item -ItemType Directory -Force -Path .\package-$suffix\libpng\lib
  Copy-Item .\build-$suffix\$Configuration\libpng16_static.lib .\package-$suffix\libpng\lib\libpng.lib
  New-Item -ItemType Directory -Force -Path .\package-$suffix\libpng\include
  Copy-Item .\source-libpng\png.h .\package-$suffix\libpng\include\png.h
  Copy-Item .\source-libpng\pngconf.h .\package-$suffix\libpng\include\pngconf.h
  Copy-Item .\build-$suffix\pnglibconf.h .\package-$suffix\libpng\include\pnglibconf.h

  Compress-Archive -Force -Path .\package-$suffix\* -DestinationPath .\$suffix.zip
}

build -Architecture 'x86' -CMakeArchitecture 'Win32' -Configuration 'RelWithDebInfo'
build -Architecture 'x86' -CMakeArchitecture 'Win32' -Configuration 'MinSizeRel'
build -Architecture 'x86' -CMakeArchitecture 'Win32' -Configuration 'Debug'
build -Architecture 'x86' -CMakeArchitecture 'Win32' -Configuration 'Release'

build -Architecture 'x64' -CMakeArchitecture 'x64' -Configuration 'RelWithDebInfo'
build -Architecture 'x64' -CMakeArchitecture 'x64' -Configuration 'MinSizeRel'
build -Architecture 'x64' -CMakeArchitecture 'x64' -Configuration 'Debug'
build -Architecture 'x64' -CMakeArchitecture 'x64' -Configuration 'Release'
