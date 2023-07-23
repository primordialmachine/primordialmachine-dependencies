#
New-Item -ItemType Directory -Force -Path .\source-zlib
cd .\source-zlib
git clone https://github.com/madler/zlib.git .
cd ..

function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $CMakeArchitecture,
    [Parameter()] [string] $Configuration
  )
  $suffix = "zlib-$Architecture-$($Configuration.ToLower())"
  New-Item -ItemType Directory -Force -Path .\build-$suffix
  cd .\build-$suffix
  cmake -A $CMakeArchitecture -S .\..\source-zlib .
  cmake --build . --config $Configuration
  cd ..

  New-Item -ItemType Directory -Force -Path .\package-$suffix\zlib\lib
  if ($Configuration -eq 'Debug') {
    Copy-Item .\build-$suffix\$Configuration\zlibstaticd.lib .\package-$suffix\zlib\lib\zlib.lib
  } else {
    Copy-Item .\build-$suffix\$Configuration\zlibstatic.lib .\package-$suffix\zlib\lib\zlib.lib
  }
  New-Item -ItemType Directory -Force -Path .\package-$suffix\zlib\include
  Copy-Item .\source-zlib\zlib.h .\package-$suffix\zlib\include\zlib.h
  Copy-Item .\build-$suffix\zconf.h .\package-$suffix\zlib\include\zconf.h

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

