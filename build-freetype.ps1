#
New-Item -ItemType Directory -Force -Path .\source-freetype
cd .\source-freetype
git clone https://gitlab.freedesktop.org/freetype/freetype/ .
cd ..

function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $Configuration
  )
  $suffix="$Architecture-$($Configuration.ToLower())"
  New-Item -ItemType Directory -Force -Path .\build-freetype-$suffix
  cd .\build-freetype-$suffix
  $cmake_args=''
  if ($Architecture -eq 'x86') {
    $cmake_args=' -A Win32'
  } elseif ($Architecture -eq 'x64') {
    $cmake_args=' -A x64'
  }
  cmake $cmake_args `
        -DPNG_PNG_INCLUDE_DIR=".\..\package-libpng-$suffix\libpng\include" `
        -DPNG_LIBRARY=".\..\package-libpng-$suffix\libpng\lib\libpng.lib" `
        -DZLIB_INCLUDE_DIR=".\..\package-zlib-$suffix\zlib\include" `
        -DZLIB_LIBRARY=".\..\package-zlib-$suffix\zlib\lib\zlib.lib" `
        -DBUILD_SHARED_LIBS=false `
        ".\..\source-freetype"
  cmake --build . 
  cmake --build . --config $Configuration --target package
  cd ..

  Remove-Item -Recurse -Force .\package-freetype-$suffix
  New-Item -ItemType Directory -Force -Path .\package-freetype-$suffix
  if ($Architecture -eq 'x86') {
    Expand-Archive -LiteralPath .\build-freetype-$suffix\freetype-2.13.1-win32.zip .\package-freetype-$suffix
    mv .\package-freetype-$suffix\freetype-2.13.1-win32 .\package-freetype-$suffix\freetype
  } elseif ($Architecture -eq 'x64') {
    Expand-Archive -LiteralPath .\build-freetype-$suffix\freetype-2.13.1-win64.zip .\package-freetype-$suffix
    mv .\package-freetype-$suffix\freetype-2.13.1-win64 .\package-freetype-$suffix\freetype
  }
  mv .\package-freetype-$suffix\freetype\include\freetype2\* .\package-freetype-$suffix\freetype\include
  Remove-Item -Recurse -Force .\package-freetype-$suffix\freetype\include\freetype2
  Compress-Archive -Force -Path .\package-freetype-$suffix\* -DestinationPath .\freetype-$suffix.zip
}

build -Architecture 'x86' -Configuration 'RelWithDebInfo'
build -Architecture 'x86' -Configuration 'MinSizeRel'
build -Architecture 'x86' -Configuration 'Debug'
build -Architecture 'x86' -Configuration 'Release'

build -Architecture 'x64' -Configuration 'RelWithDebInfo'
build -Architecture 'x64' -Configuration 'MinSizeRel'
build -Architecture 'x64' -Configuration 'Debug'
build -Architecture 'x64' -Configuration 'Release'
