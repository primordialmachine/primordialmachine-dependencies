param(
  [Parameter()] [string] $Architecture,
  [Parameter()] [string] $Configuration
)

./build-zlib.ps1 -Architecture $Architecture -Configuration $Configuration
./build-libpng.ps1 -Architecture $Architecture -Configuration $Configuration
./build-freetype.ps1 -Architecture $Architecture -Configuration $Configuration
