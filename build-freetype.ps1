param(
  [Parameter()] [string] $Architecture,
  [Parameter()] [string] $Configuration
)

. .\common.ps1

#
New-Item -ItemType Directory -Force -Path .\source-freetype
cd .\source-freetype
git clone https://gitlab.freedesktop.org/freetype/freetype.git .
cd ..

function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $Configuration
  )
  # Validate architecture.
  if ($Architecture -eq 'x86') {
  } elseif ($Architecture -eq 'x64') {
  } else {
    throw 'unsupported architecture'
  }
  $name='freetype'
  $suffix="$name-$Architecture-$($Configuration.ToLower())"
  $source_dir="source-$name"
  $build_dir="build-$suffix"
  $package_dir="package-$suffix"
  $archive="$suffix.zip"
  
  Write-Host "building $name with arch = $Architecture and config = $($Configuration.ToLower())"
  New-Item -ItemType Directory -Force -Path .\$build_dir
  cd .\$build_dir
  $cmake_args=@()
  if ($Architecture -eq 'x86') {
    $cmake_args+=@('-A', 'Win32')
  } elseif ($Architecture -eq 'x64') {
    $cmake_args+=@('-A', 'x64')
  }
  $cmake_args+=@("-DPNG_PNG_INCLUDE_DIR=`".\..\package-libpng-$Architecture-$($Configuration.ToLower())\libpng\include`"", `
                 "-DPNG_LIBRARY=`".\..\package-libpng-$Architecture-$($Configuration.ToLower())\libpng\lib\libpng.lib`"", `
                 "-DZLIB_INCLUDE_DIR=`".\..\package-zlib-$Architecture-$($Configuration.ToLower())\zlib\include`"", `
                 "-DZLIB_LIBRARY=`".\..\package-zlib-$Architecture-$($Configuration.ToLower())\zlib\lib\zlib.lib`"", `
                 "-DBUILD_SHARED_LIBS=false")
  $cmake_args+=@(".\..\$source_dir")
  & "cmake" $cmake_args
  & "cmake" @('--build', '.', '--config'. $Configuration)
  & "cmake" @('--build', '.', '--config', $Configuration, '--target', 'package')
  cd ..

  delete -Path ".\$package_dir"
  New-Item -ItemType Directory -Force -Path .\$package_dir
  if ($Architecture -eq 'x86') {
    Expand-Archive -LiteralPath .\$build_dir\freetype-2.13.1-win32.zip .\$package_dir
    mv .\$package_dir\freetype-2.13.1-win32 .\$package_dir\freetype
  } elseif ($Architecture -eq 'x64') {
    Expand-Archive -LiteralPath .\$build_dir\freetype-2.13.1-win64.zip .\$package_dir
    mv .\$package_dir\freetype-2.13.1-win64 .\$package_dir\freetype
  }
  mv .\$package_dir\freetype\include\freetype2\* .\$package_dir\freetype\include
  delete -Path ".\$package_dir\freetype\include\freetype2"
  Compress-Archive -Force -Path .\$package_dir\* -DestinationPath .\$archive
}

build -Architecture $Architecture -Configuration $Configuration
