function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $Configuration
  )
  $suffix = "$Architecture-$($Configuration.ToLower())"
  Remove-Item -Path .\build-libpng-$suffix -Recurse -Force
  Remove-Item -Path .\package-libpng-$suffix -Recurse -Force
  # Do not delete archives.
  #Remove-Item -Path .\libpng-$suffix.zip -Recurse -Force
  #Remove-Item -Path .\libpng-$suffix.zip -Recurse -Force
}

Remove-Item -Path .\source-libpng -Recurse -Force

build -Architecture 'x86' -Configuration 'Debug'
build -Architecture 'x86' -Configuration 'Release'
build -Architecture 'x86' -Configuration 'MinSizeRel'
build -Architecture 'x86' -Configuration 'RelWithDebInfo'

build -Architecture 'x64' -Configuration 'Debug'
build -Architecture 'x64' -Configuration 'Release'
build -Architecture 'x64' -Configuration 'MinSizeRel'
build -Architecture 'x64' -Configuration 'RelWithDebInfo'
