function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $Configuration
  )
  $suffix = "$Architecture-$($Configuration.ToLower())"
  Remove-Item -Path .\build-zlib-$suffix -Recurse -Force
  Remove-Item -Path .\package-zlib-$suffix -Recurse -Force
  # Do not delete archives.
  #Remove-Item -Path .\zlib-$suffix.zip -Recurse -Force
  #Remove-Item -Path .\zlib-$suffix.zip -Recurse -Force
}

Remove-Item -Path .\source-zlib -Recurse -Force

build -Architecture 'x86' -Configuration 'Debug'
build -Architecture 'x86' -Configuration 'Release'
build -Architecture 'x86' -Configuration 'MinSizeRel'
build -Architecture 'x86' -Configuration 'RelWithDebInfo'

build -Architecture 'x64' -Configuration 'Debug'
build -Architecture 'x64' -Configuration 'Release'
build -Architecture 'x64' -Configuration 'MinSizeRel'
build -Architecture 'x64' -Configuration 'RelWithDebInfo'
