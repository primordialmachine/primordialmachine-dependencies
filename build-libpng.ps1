#
New-Item -ItemType Directory -Force -Path .\source-libpng
cd .\source-libpng
git clone https://github.com/glennrp/libpng.git .
cd ..

#
New-Item -ItemType Directory -Force -Path .\build-libpng-x86
cd .\build-libpng-x86
cmake -DZLIB_INCLUDE_DIRS=".\..\package-zlib-x64\zlib\include" -DPNG_BUILD_ZLIB=ON -DPNG_SHARED=OFF -DPNG_TESTS=OFF -A Win32 -S .\..\source-libpng
cmake --build . --config Release
cd ..

New-Item -ItemType Directory -Force -Path .\package-libpng-x86\libpng\lib
Copy-Item .\build-libpng-x86\Release\libpng16_static.lib .\package-libpng-x86\libpng\lib\libpng16_static.lib
New-Item -ItemType Directory -Force -Path .\package-libpng-x86\libpng\include
Copy-Item .\source-libpng\png.h .\package-libpng-x86\libpng\include\png.h
Copy-Item .\source-libpng\pngconf.h .\package-libpng-x86\libpng\include\pngconf.h
Copy-Item .\build-libpng-x86\pnglibconf.h .\package-libpng-x86\libpng\include\pnglibconf.h

Compress-Archive -Force -Path .\package-libpng-x86\* -DestinationPath .\libpng-x86.zip

#
New-Item -ItemType Directory -Force -Path .\build-libpng-x64
cd .\build-libpng-x64
cmake -DZLIB_INCLUDE_DIRS=".\..\package-zlib-x64\zlib\include" -DPNG_BUILD_ZLIB=ON -DPNG_SHARED=OFF -DPNG_TESTS=OFF -A x64 -S .\..\source-libpng
cmake --build . --config Release
cd ..

New-Item -ItemType Directory -Force -Path .\package-libpng-x64\libpng\lib
Copy-Item .\build-libpng-x64\Release\libpng16_static.lib .\package-libpng-x64\libpng\lib\libpng16_static.lib
New-Item -ItemType Directory -Force -Path .\package-libpng-x64\libpng\include
Copy-Item .\source-libpng\png.h .\package-libpng-x64\libpng\include\png.h
Copy-Item .\source-libpng\pngconf.h .\package-libpng-x64\libpng\include\pngconf.h
Copy-Item .\build-libpng-x64\pnglibconf.h .\package-libpng-x64\libpng\include\pnglibconf.h

Compress-Archive -Force -Path .\package-libpng-x64\* -DestinationPath .\libng-x64.zip
