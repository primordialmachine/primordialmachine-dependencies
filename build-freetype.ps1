#
New-Item -ItemType Directory -Force -Path .\source-freetype
cd .\source-freetype
git clone https://gitlab.freedesktop.org/freetype/freetype/ .
cd ..

#
New-Item -ItemType Directory -Force -Path .\build-freetype-x86
cd .\build-freetype-x86
cmake -DPNG_PNG_INCLUDE_DIR=".\..\package-libpng-x86\libpng\include" `
      -DPNG_LIBRARY=".\..\package-libpng-x86\libpng\lib\libpng16_static.lib" `
      -DZLIB_INCLUDE_DIR=".\..\package-zlib-x86\zlib\include" `
      -DZLIB_LIBRARY=".\..\package-zlib-x86\zlib\lib\zlibstatic.lib" `
      -DBUILD_SHARED_LIBS=false `
      -A Win32 -S .\..\source-freetype .
cmake --build . 
cmake --build . --config Release --target package
cd ..

Remove-Item -Recurse -Force .\package-freetype-x86
New-Item -ItemType Directory -Force -Path .\package-freetype-x86
Expand-Archive -LiteralPath .\build-freetype-x86\freetype-2.13.1-win32.zip .\package-freetype-x86
mv .\package-freetype-x86\freetype-2.13.1-win32 .\package-freetype-x86\freetype
Compress-Archive -Force -Path .\package-freetype-x86\* -DestinationPath .\freetype-x86.zip

#
New-Item -ItemType Directory -Force -Path .\build-freetype-x64
cd .\build-freetype-x64
cmake -DPNG_PNG_INCLUDE_DIR=".\..\package-libpng-x64\libpng\include" `
      -DPNG_LIBRARY=".\..\package-libpng-x64\libpng\lib\libpng16_static.lib" `
      -DZLIB_INCLUDE_DIR=".\..\package-zlib-x64\zlib\include" `
      -DZLIB_LIBRARY=".\..\package-zlib-x64\zlib\lib\zlibstatic.lib" `
      -DBUILD_SHARED_LIBS=false `
      -A x64 -S .\..\source-freetype .
cmake --build .
cmake --build . --config Release --target package
cd..

Remove-Item -Recurse -Force .\package-freetype-x64
New-Item -ItemType Directory -Force -Path .\package-freetype-x64
Expand-Archive -LiteralPath .\build-freetype-x64\freetype-2.13.1-win64.zip .\package-freetype-x64
mv .\package-freetype-x64\freetype-2.13.1-win64 .\package-freetype-x64\freetype
Compress-Archive -Force -Path .\package-freetype-x64\* -DestinationPath .\freetype-x64.zip
