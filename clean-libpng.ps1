Remove-Item -Path .\source-libpng -Recurse -Force
Remove-Item -Path .\build-libpng-x64 -Recurse -Force
Remove-Item -Path .\build-libpng-x86 -Recurse -Force
Remove-Item -Path .\package-libpng-x64 -Recurse -Force
Remove-Item -Path .\package-libpng-x86 -Recurse -Force

# Do not delete archives.
#Remove-Item -Path .\libpng-x64.zip -Recurse -Force
#Remove-Item -Path .\libpng-x86.zip -Recurse -Force
