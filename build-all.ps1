$configurations='RelWithDebInfo', 'Release', 'Debug', 'MinSizeRel'
$architectures='x86', 'x64'

foreach ($configuration in $configurations) {
  foreach ($architecture in $architectures) {
    ./build-zlib.ps1 -Architecture $architecture -Configuration $configuration 
    ./build-libpng.ps1 -Architecture $architecture -Configuration $configuration 
    ./build-freetype.ps1 -Architecture $architecture -Configuration $configuration
    ./build-openal-soft.ps1 -Architecture $architecture -Configuration $configuration 
  }
}
