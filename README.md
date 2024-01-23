# FFMPEG builder

This repo is intended to easily allow CI to build LGPL builds of ffmpeg and associated DLLs for us.

## Usage

- Run `build.bat`
- Collect results from `output` folder

## Changing what gets built

`build.bat` contains a list of features that get built, which can be modified. **Some FFMPEG features are GPL, so check licenses for anything you enable**. Notable example: x264 is GPL.

## Implementation details

FFMPEG has an official `vcpkg` port, so we use this for easy building. We have our own vcpkg triplet (`x64-windows-recorder.cmake`) which builds ffmpeg dynamic (shared), but everything else as a static library. This results in DLLs for libav with all the dependencies self-contained, and small ffmpeg binaries which make use of the same DLLs.

## Latest update (manual builds)

ffmpeg binaries built by this repo using vcpkg is showing terrible performance with openh264 encoder. Our manual build tests showed that vcpkg builds of ffmpeg are indeed way slower. So we have decided to build ffmpeg locally in our machines and upload the binary here as a release zip file. Also we discovered that openh264 performance varies significantly across versions. The latest ffmpeg version that showed best performance for openh264 was 5.1. Any ffmpeg version later than this is performing at only half the fps for some unknown reason. Hence we have decided to stick with ffmpeg 5.1 for now. Below are the steps to build ffmpeg with openh264 in a windows machine using Visual Studio compiler.

- Install MSYS2
Download MSYS2 from msys2.org and follow the installation instructions.

- Open the MSYS2 terminal and update the package database and base packages by running:
```
pacman -Syu
pacman -S make autoconf automake libtool pkg-config git
pacman -S yasm
```

- Edit the windows system environment variable to add msys binaries to `Path`. For example `C:\msys64\usr\bin` should be added to `Path`

- Open the normal windows command prompt and checkout openh264

```
git clone https://github.com/cisco/openh264.git
cd openh264
git checkout cfbd5896606b91638c8871ee91776dee31625bd5
```

- Do the following one line modification to the openh264 repo.

```
C:\work\ffmpeg_msvc\openh264>git diff
diff --git a/build/AutoBuildForWindows.bat b/build/AutoBuildForWindows.bat
index beec645f..803b8b1e 100644
--- a/build/AutoBuildForWindows.bat
+++ b/build/AutoBuildForWindows.bat
@@ -408,6 +408,7 @@ rem ***********************************************
   echo "make OS=%vOSType%  ARCH=%vArcType% USE_ASM=%vASMFlag% BUILDTYPE=%vConfiguration% %NATIVE_OPTIONS% plugin"
   make OS=%vOSType%  ARCH=%vArcType% USE_ASM=%vASMFlag% BUILDTYPE=%vConfiguration% clean
   make OS=%vOSType%  ARCH=%vArcType% USE_ASM=%vASMFlag% BUILDTYPE=%vConfiguration% %NATIVE_OPTIONS%
+  make OS=%vOSType%  ARCH=%vArcType% USE_ASM=%vASMFlag% BUILDTYPE=%vConfiguration% %NATIVE_OPTIONS% install
   make OS=%vOSType%  ARCH=%vArcType% USE_ASM=%vASMFlag% BUILDTYPE=%vConfiguration% %NATIVE_OPTIONS% plugin
   if not %ERRORLEVEL%==0 (
     set BuildFlag=1
```

- Ensure you have Visual Studio 2019 or earlier installed.

- Run `bash` command from `openh264` folder to move to a bash prompt.

```
bash
```

- In the bash prompt run the following commands.

```
cd build
AutoBuildForWindows.bat Win64-Release-ASM
```

- Open a new `x64 Native Tools Command Prompt for 2022` prompt. 
- Run `bash` command in the above command prompt to move to a bash prompt.
- Ensure that openh264 libraries are installed /usr/local/ directories. Add it to the pkg config path with the below command.

```
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
```

- Run `pkg-config --libs openh264` command to check if pkg config is detecting openh264 package without any errors.

- Now in a new folder checkout and build ffmpeg with the below commands.

```
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
git checkout n5.1
./configure --toolchain=msvc --enable-libopenh264 --enable-shared --disable-encoders --disable-decoders --enable-encoder=libopenh264 --enable-encoder=aac
make -j4
make install
```

- Now check if ffmpeg binaries are installed in /usr/local/bin

- Now from windows UI from msys `/usr/local` directory(for example `C:\msys64\usr\local`), create a zip file containing `bin`, `lib` and `include` folders.

- Create a new release in this repo and just upload the zip file by providing proper release version and name
