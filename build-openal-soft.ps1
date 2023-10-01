param(
  [Parameter()] [string] $Architecture,
  [Parameter()] [string] $Configuration
)

. .\common.ps1

#
New-Item -ItemType Directory -Force -Path .\source-openal-soft
cd .\source-openal-soft
git clone https://github.com/kcat/openal-soft .
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
  $name='openal-soft'
  $suffix="$name-$Architecture-$($Configuration.ToLower())"
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
  $cmake_args+=@("-DLIBTYPE=`"STATIC`"");
  $cmake_args+=@(".\..\source-$name");
  & cmake $cmake_args
  & cmake @('--build', '.', '--config', $Configuration)

  & cmake $cmake_args
  & cmake @('--install', '.', '--prefix', './install', '--config', $Configuration)

  cd ..

  New-Item -ItemType Directory -Force -Path .\$package_dir\openal-soft\lib
  if ($Configuration -eq 'Debug') {
    Copy-Item .\$build_dir\install\lib\OpenAL32.lib .\$package_dir\openal-soft\lib\OpenAL32.lib
  } elseif (($Configuration -eq 'Release') -or (($Configuration -eq 'MinSizeRel') -or ($Configuration -eq 'RelWithDebInfo'))) {
    Copy-Item .\$build_dir\install\lib\OpenAL32.lib .\$package_dir\openal-soft\lib\OpenAL32.lib
  } else {
    throw 'unsupported architecture'
  }
  New-Item -ItemType Directory -Force -Path .\$package_dir\openal-soft\include\AL
  Copy-Item .\$build_dir\install\include\AL\al.h .\$package_dir\openal-soft\include\AL\al.h
  Copy-Item .\$build_dir\install\include\AL\alc.h .\$package_dir\openal-soft\include\AL\alc.h
  Copy-Item .\$build_dir\install\include\AL\alext.h .\$package_dir\openal-soft\include\AL\alext.h
  Copy-Item .\$build_dir\install\include\AL\efx.h .\$package_dir\openal-soft\include\AL\efx.h

  Compress-Archive -Force -Path .\$package_dir\* -DestinationPath .\$archive
}

build -Architecture $Architecture -Configuration $Configuration
