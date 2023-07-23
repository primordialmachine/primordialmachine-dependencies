Remove-Item -Path .\source-zlib -Recurse -Force
Remove-Item -Path .\build-zlib-x64 -Recurse -Force
Remove-Item -Path .\build-zlib-x86 -Recurse -Force
Remove-Item -Path .\package-zlib-x64 -Recurse -Force
Remove-Item -Path .\package-zlib-x86 -Recurse -Force

# Do not delete archives.
#Remove-Item -Path .\zlib-x64.zip -Recurse -Force
#Remove-Item -Path .\zlib-x86.zip -Recurse -Force
