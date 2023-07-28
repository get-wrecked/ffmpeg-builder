@ECHO OFF

echo === Cloning vcpkg repo ...

git clone --depth 1 https://github.com/microsoft/vcpkg

echo === Bootstrapping vcpkg ...

cd vcpkg
call bootstrap-vcpkg.bat

echo === Applying triplet ...

xcopy /Y ..\x64-windows-recorder.cmake triplets

echo === Building ffmpeg ...

vcpkg install ffmpeg[avcodec,avdevice,avfilter,avformat,dav1d,ffmpeg,ffprobe,lzma,mp3lame,openh264,openjpeg,opus,snappy,soxr,swresample,swscale,theora,vorbis,vpx,webp,zlib]:x64-windows-recorder

echo === Copying to output folder ...

cd ..

xcopy /Y /E vcpkg\packages\ffmpeg_x64-windows-recorder\bin\*.dll output\recorder\libav\bin\
xcopy /Y /E vcpkg\packages\ffmpeg_x64-windows-recorder\include output\recorder\libav\include\
xcopy /Y /E vcpkg\packages\ffmpeg_x64-windows-recorder\lib output\recorder\libav\lib\
xcopy /Y /E vcpkg\packages\ffmpeg_x64-windows-recorder\share output\recorder\libav\share\

xcopy /Y /E vcpkg\packages\ffmpeg_x64-windows-recorder\bin\*.pdb output\recorder\libav_pdb\

xcopy /Y /E vcpkg\packages\ffmpeg_x64-windows-recorder\tools output\recorder\tools\
