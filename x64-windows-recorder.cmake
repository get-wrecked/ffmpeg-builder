set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_BUILD_TYPE release)

if (PORT MATCHES "ffmpeg")
    set (VCPKG_LIBRARY_LINKAGE dynamic)
else ()
    set (VCPKG_LIBRARY_LINKAGE static)
endif ()