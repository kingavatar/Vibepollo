#!/bin/bash
set -e

echo -e "\033[0;36mCreating portable release build...\033[0m"

# Configuration
BUILD_DIR="build_portable"
INSTALL_DIR="Vibepollo_portable"
GENERATOR="Ninja"

rm -rf $BUILD_DIR
rm -rf $INSTALL_DIR

mkdir -p "$BUILD_DIR"
mkdir -p "$INSTALL_DIR"

# Check for required tools
if ! command -v cmake &> /dev/null; then
    echo "Error: cmake not found in PATH."
    exit 1
fi
if ! command -v ninja &> /dev/null; then
    echo "Error: ninja not found in PATH."
    exit 1
fi

# 1. Configure
echo -e "\n\033[0;32mConfiguring CMake...\033[0m"
cmake -B "$BUILD_DIR" -G "$GENERATOR" -S . \
    -DCMAKE_BUILD_TYPE=Release \
    -DSUNSHINE_ENABLE_WEBRTC=OFF \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"

# 2. Build
echo -e "\n\033[0;32mBuilding...\033[0m"
cmake --build "$BUILD_DIR" --config Release

# 3. Install
echo -e "\n\033[0;32mInstalling to $INSTALL_DIR...\033[0m"
cmake --install "$BUILD_DIR" --prefix "$INSTALL_DIR"

# 4. Cleanup
echo -e "\n\033[0;32mCleaning up...\033[0m"
# uninstall.exe is often flagged false-positive by AV and is not needed for portable builds
if [ -f "$INSTALL_DIR/uninstall.exe" ]; then
    echo "Removing uninstall.exe (not needed for portable mode)..."
    rm "$INSTALL_DIR/uninstall.exe"
    # remove the build directory as requested
    rm -rf "$BUILD_DIR"
fi

# 5. Bundle Dependencies
# The build is static (see cmake/compile_definitions/windows.cmake), so no external DLLs 
# (libstdc++, libgcc, etc.) are needed. The executable is self-contained.
echo -e "\n\033[0;32mBundling additional scripts...\033[0m"
# Copy the install/uninstall scripts if they exist
if [ -f "portable_install.bat" ]; then
    echo "Copying portable_install.bat..."
    cp "portable_install.bat" "$INSTALL_DIR/"
fi
if [ -f "portable_uninstall.bat" ]; then
    echo "Copying portable_uninstall.bat..."
    cp "portable_uninstall.bat" "$INSTALL_DIR/"
fi

echo -e "\n\033[0;32mBuild complete!\033[0m"
echo -e "The self-contained portable build is located in: \033[0;36m$(pwd)/$INSTALL_DIR\033[0m"
