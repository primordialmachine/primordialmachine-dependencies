#
New-Item -ItemType Directory -Force -Path .\source-zlib
cd .\source-zlib
git clone https://github.com/madler/zlib.git .
cd ..

#
New-Item -ItemType Directory -Force -Path .\build-zlib-x86
cd .\build-zlib-x86
cmake -A Win32 -S .\..\source-zlib .
cmake --build . --config Release
cd ..

New-Item -ItemType Directory -Force -Path .\package-zlib-x86\zlib\lib
Copy-Item .\build-zlib-x86\Release\zlibstatic.lib .\package-zlib-x86\zlib\lib\zlibstatic.lib
New-Item -ItemType Directory -Force -Path .\package-zlib-x86\zlib\include
Copy-Item .\source-zlib\zlib.h .\package-zlib-x86\zlib\include\zlib.h
Copy-Item .\build-zlib-x86\zconf.h .\package-zlib-x86\zlib\include\zconf.h

Compress-Archive -Force -Path .\package-zlib-x86\* -DestinationPath .\zlib-x86.zip

#
New-Item -ItemType Directory -Force -Path .\build-zlib-x64
cd .\build-zlib-x64
cmake -A x64 -S .\..\source-zlib .
cmake --build . --config Release
cd ..

New-Item -ItemType Directory -Force -Path .\package-zlib-x64\zlib\lib
Copy-Item .\build-zlib-x64\Release\zlibstatic.lib .\package-zlib-x64\zlib\lib\zlibstatic.lib
New-Item -ItemType Directory -Force -Path .\package-zlib-x64\zlib\include
Copy-Item .\source-zlib\zlib.h .\package-zlib-x64\zlib\include\zlib.h
Copy-Item .\build-zlib-x64\zconf.h .\package-zlib-x64\zlib\include\zconf.h

Compress-Archive -Force -Path .\package-zlib-x64\* -DestinationPath .\zlib-x64.zip
