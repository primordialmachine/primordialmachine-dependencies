function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $Configuration
  )
  $suffix = "$Architecture-$($Configuration.ToLower())"
  Remove-Item -Path .\build-openal-soft-$suffix -Recurse -Force
  Remove-Item -Path .\package-openal-soft-$suffix -Recurse -Force
  # Do not delete archives.
  #Remove-Item -Path .\openal-soft-$suffix.zip -Recurse -Force
  #Remove-Item -Path .\openal-soft-$suffix.zip -Recurse -Force
}

Remove-Item -Path .\source-openal-soft -Recurse -Force

build -Architecture 'x86' -Configuration 'Debug'
build -Architecture 'x86' -Configuration 'Release'
build -Architecture 'x86' -Configuration 'MinSizeRel'
build -Architecture 'x86' -Configuration 'RelWithDebInfo'

build -Architecture 'x64' -Configuration 'Debug'
build -Architecture 'x64' -Configuration 'Release'
build -Architecture 'x64' -Configuration 'MinSizeRel'
build -Architecture 'x64' -Configuration 'RelWithDebInfo'
