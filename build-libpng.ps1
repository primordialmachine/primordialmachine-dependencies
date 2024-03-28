param(
  [Parameter()] [string] $Architecture,
  [Parameter()] [string] $Configuration
)

. .\common.ps1

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
  # Validate architecture.
  if ($Architecture -eq 'x86') {
  } elseif ($Architecture -eq 'x64') {
  } else {
    throw 'unsupported architecture'
  }
  $name='libpng'
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
  $cmake_args+=@("-DZLIB_ROOT=`".\..\package-zlib-$Architecture-$($Configuration.ToLower())\zlib`"", `
                 '-DPNG_SHARED=OFF', `
                 '-DPNG_TESTS=OFF', `
                 '-DCMAKE_POLICY_POLICY_DEFAULT_CMP0074=NEW')
  $cmake_args+=@("./../$source_dir")
  & cmake $cmake_args
  & cmake @('--build', '.', '--config', $Configuration)

  cd ..

  New-Item -ItemType Directory -Force -Path .\$package_dir\libpng\lib
  if ($Configuration -eq 'Debug') {
    Copy-Item .\$build_dir\$Configuration\libpng16_staticd.lib .\$package_dir\libpng\lib\libpng.lib
  } elseif (($Configuration -eq 'Release') -or (($Configuration -eq 'MinSizeRel') -or ($Configuration -eq 'RelWithDebInfo'))) {
    Copy-Item .\$build_dir\$Configuration\libpng16_static.lib .\$package_dir\libpng\lib\libpng.lib
  } else {
    throw 'unsupported architecture'
  }
  New-Item -ItemType Directory -Force -Path .\$package_dir\libpng\include
  Copy-Item .\$source_dir\png.h .\$package_dir\libpng\include\png.h
  Copy-Item .\$source_dir\pngconf.h .\$package_dir\libpng\include\pngconf.h
  Copy-Item .\$build_dir\pnglibconf.h .\$package_dir\libpng\include\pnglibconf.h

  Compress-Archive -Force -Path .\$package_dir\* -DestinationPath .\$archive
}

build -Architecture $Architecture -Configuration $Configuration
