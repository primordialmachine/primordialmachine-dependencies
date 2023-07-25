param(
  [Parameter()] [string] $Architecture,
  [Parameter()] [string] $Configuration
)

. .\common.ps1

#
New-Item -ItemType Directory -Force -Path .\source-zlib
cd .\source-zlib
git clone https://github.com/madler/zlib.git .
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
  $name='zlib'
  $suffix = "$name-$Architecture-$($Configuration.ToLower())"
  $source_dir="source-$name"
  $build_dir="build-$suffix"
  $package_dir="package-$suffix"
  $archive="$suffix.zip"
  
  Write-Host "building $name with arch = $Architecture and config = $($Configuration.ToLower())"
  delete -Path .\$build_dir
  New-Item -ItemType Directory -Force -Path .\$build_dir
  cd .\$build_dir
  $cmake_args=@()
  if ($Architecture -eq 'x86') {
    $cmake_args+=@("-A", "Win32")
  } elseif ($Architecture -eq 'x64') {
    $cmake_args+=@("-A",  "x64")
  }
  $cmake_args+=@("./../$source_dir")
  & "cmake" $cmake_args
  & "cmake" @("--build", ".", "--config", "$Configuration")

  cd ..

  New-Item -ItemType Directory -Force -Path .\$package_dir\zlib\lib
  if ($Configuration -eq 'Debug') {
    Copy-Item .\$build_dir\$Configuration\zlibstaticd.lib .\$package_dir\zlib\lib\zlib.lib
  } else {
    Copy-Item .\$build_dir\$Configuration\zlibstatic.lib .\$package_dir\zlib\lib\zlib.lib
  }
  New-Item -ItemType Directory -Force -Path .\$package_dir\zlib\include
  Copy-Item .\$source_dir\zlib.h .\$package_dir\zlib\include\zlib.h
  Copy-Item .\$build_dir\zconf.h .\$package_dir\zlib\include\zconf.h

  Compress-Archive -Force -Path .\$package_dir\* -DestinationPath .\$archive
}

build -Architecture $Architecture -Configuration $Configuration
