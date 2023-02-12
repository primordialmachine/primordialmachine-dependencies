Remove-Item -Path .\source-freetype -Recurse -Force
Remove-Item -Path .\build-freetype-x64 -Recurse -Force
Remove-Item -Path .\build-freetype-x86 -Recurse -Force
Remove-Item -Path .\package-freetype-x64 -Recurse -Force
Remove-Item -Path .\package-freetype-x86 -Recurse -Force

# Do not delete archives.
#Remove-Item -Path .\freetype-x64.zip -Recurse -Force
#Remove-Item -Path .\freetype-x86.zip -Recurse -Force
