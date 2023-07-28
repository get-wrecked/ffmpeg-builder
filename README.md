# FFMPEG builder

This repo is intended to easily allow CI to build LGPL builds of ffmpeg and associated DLLs for us.

## Usage

- Run `build.bat`
- Collect results from `output` folder

## Changing what gets built

`build.bat` contains a list of features that get built, which can be modified. **Some FFMPEG features are GPL, so check licenses for anything you enable**. Notable example: x264 is GPL.

## Implementation details

FFMPEG has an official `vcpkg` port, so we use this for easy building. We have our own vcpkg triplet (`x64-windows-recorder.cmake`) which builds ffmpeg dynamic (shared), but everything else as a static library. This results in DLLs for libav with all the dependencies self-contained, and small ffmpeg binaries which make use of the same DLLs.