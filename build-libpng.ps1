param(
  [Parameter()] [string] $Architecture,
  [Parameter()] [string] $Configuration
)

#
New-Item -ItemType Directory -Force -Path .\source-libpng
cd .\source-libpng
git clone https://github.com/glennrp/libpng.git .
cd ..

function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $Configuration
  )
  $suffix="libpng-$Architecture-$($Configuration.ToLower())"
  New-Item -ItemType Directory -Force -Path .\build-$suffix
  cd .\build-$suffix
  $cmake_args=''
  if ($Architecture -eq 'x86') {
    $cmake_args=' -A Win32'
  } elseif ($Architecture -eq 'x64') {
    $cmake_args=' -A x64'
  } else {
    throw 'unsupported architecture'
  }
  cmake $cmake_args `
        -DZLIB_INCLUDE_DIRS=".\..\package-zlib-$Architecture-$($Configuration.ToLower())\zlib\include" `
        -DPNG_BUILD_ZLIB=ON `
        -DPNG_SHARED=OFF `
        -DPNG_TESTS=OFF `
        ".\..\source-libpng"
  cmake --build . --config $Configuration
  cd ..

  New-Item -ItemType Directory -Force -Path .\package-$suffix\libpng\lib
  if ($Configuration -eq 'Debug') {
    Copy-Item .\build-$suffix\$Configuration\libpng16_staticd.lib .\package-$suffix\libpng\lib\libpng.lib
  } else {
    Copy-Item .\build-$suffix\$Configuration\libpng16_static.lib .\package-$suffix\libpng\lib\libpng.lib   
  }
  New-Item -ItemType Directory -Force -Path .\package-$suffix\libpng\include
  Copy-Item .\source-libpng\png.h .\package-$suffix\libpng\include\png.h
  Copy-Item .\source-libpng\pngconf.h .\package-$suffix\libpng\include\pngconf.h
  Copy-Item .\build-$suffix\pnglibconf.h .\package-$suffix\libpng\include\pnglibconf.h

  Compress-Archive -Force -Path .\package-$suffix\* -DestinationPath .\$suffix.zip
}

build -Architecture $Architecture -Configuration $Configuration
