#!/bin/sh
# Build Duke Nukem 3D for the MiSTer in the toolchain container: static SDL2 with the
# hybrid core drivers first (once), then the game.
# usage: ./build.sh [mister|host] [Release|RelWithDebInfo|Debug]
#   mister  ARM binary for the MiSTer     -> build/mister/eduke32
#   host    same code for this PC, to run against hybrid/tools/fakecore
set -e
cd "$(dirname "$0")"
TARGET=${1:-mister}
TYPE=${2:-Release}
ROOT=$PWD
PREFIX=$ROOT/build/sdl/$TARGET/prefix

hybrid/docker.sh hybrid/sdl2/build.sh "$TARGET" build/sdl

# GAME: EDuke32 has no CMake build: its own makefiles, with MISTER_HYBRID=1
# (eduke32/Common.mak: the classic renderer alone, no network, no OpenGL)
# and our SDL2. The program is made in eduke32/ and moved to build/$TARGET/.
MAKEOPTS="MISTER_HYBRID=1 PRETTY_OUTPUT=0 LTO=0 obj=$ROOT/build/$TARGET/obj SDLCONFIG=$PREFIX/bin/sdl2-config"
case $TYPE in
    Release) MAKEOPTS="$MAKEOPTS RELEASE=1" ;;
    RelWithDebInfo) MAKEOPTS="$MAKEOPTS RELEASE=1 FORCEDEBUG=1 STRIP=" ;;
    *) MAKEOPTS="$MAKEOPTS RELEASE=0 STRIP=" ;;
esac
if [ "$TARGET" = mister ]; then
    # the compiler's runtime is linked in, the binary only needs the MiSTer's glibc
    MAKEOPTS="$MAKEOPTS CROSS=arm-linux-gnueabihf- ARCH=armv7l"
    MAKEOPTS="$MAKEOPTS OPTOPT='-mcpu=cortex-a9 -mfpu=neon -mfloat-abi=hard -fno-pie'"
    MAKEOPTS="$MAKEOPTS CUSTOMOPT='-static-libstdc++ -static-libgcc'"
fi
mkdir -p "build/$TARGET"
hybrid/docker.sh sh -c "make -C eduke32 -j\$(nproc) eduke32 $MAKEOPTS"
mv -f eduke32/eduke32 "build/$TARGET/eduke32"
ls -la "build/$TARGET/eduke32"

# The launch script's messages on the core's picture (hybrid/tools/mh_message.c)
if [ "$TARGET" = mister ]; then
    hybrid/docker.sh arm-linux-gnueabihf-gcc -O2 -static -Ihybrid/hps -o build/mister/mh_message \
        hybrid/tools/mh_message.c hybrid/hps/*.c -lpthread -lm
fi
