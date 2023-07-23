function build {
  param(
    [Parameter()] [string] $Architecture,
    [Parameter()] [string] $Configuration
  )
  $suffix = "$Architecture-$($Configuration.ToLower())"
  Remove-Item -Path .\build-freetype-$suffix -Recurse -Force
  Remove-Item -Path .\package-freetype-$suffix -Recurse -Force
  # Do not delete archives.
  #Remove-Item -Path .\freetype-$suffix.zip -Recurse -Force
  #Remove-Item -Path .\freetype-$suffix.zip -Recurse -Force
}

Remove-Item -Path .\source-freetype -Recurse -Force

build -Architecture 'x86' -Configuration 'Debug'
build -Architecture 'x86' -Configuration 'Release'
build -Architecture 'x86' -Configuration 'MinSizeRel'
build -Architecture 'x86' -Configuration 'RelWithDebInfo'

build -Architecture 'x64' -Configuration 'Debug'
build -Architecture 'x64' -Configuration 'Release'
build -Architecture 'x64' -Configuration 'MinSizeRel'
build -Architecture 'x64' -Configuration 'RelWithDebInfo'
