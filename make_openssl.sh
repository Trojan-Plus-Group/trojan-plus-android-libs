#!/bin/bash
set -e
set -x

if [ ! -n "$1" ]; then
    echo "Please append android NDK home path with this script!";
    exit 1;
fi


# Set directory
SCRIPTPATH=`realpath .`
export ANDROID_NDK_HOME=`realpath $1`
OPENSSL_DIR=$SCRIPTPATH/openssl-OpenSSL_1_1_1g

# Find the toolchain for your build machine
#toolchains_path=$(python toolchains_path.py --ndk ${ANDROID_NDK_HOME})
toolchains_path=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64

# Configure the OpenSSL environment, refer to NOTES.ANDROID in OPENSSL_DIR
# Set compiler clang, instead of gcc by default
CC=clang

# Add toolchains bin directory to PATH
PATH=$toolchains_path/bin:$PATH

# Set the Android API levels
ANDROID_API=24

# Set the target architecture
# Can be
# android-arm android-arm64 android-armeabi android-mips android-mips64 android-x86
# android-x86_64 android64 android64-aarch64 android64-mips64 android64-x86_64
architectures=(
    android-arm
    android-arm64
    android-x86
    android-x86_64
)

android_architectures=(
    armeabi-v7a
    arm64-v8a
    x86
    x86_64
)

for i in "${!architectures[@]}"
do
    architecture=${architectures[$i]}
    android_architecture=${android_architectures[$i]}
    
    cd ${OPENSSL_DIR}
    
    ./Configure ${architecture} -D__ANDROID_API__=$ANDROID_API
    make -j4

    # Copy the outputs  
    if [ $i = 0 ]; then
        OUTPUT_INCLUDE=$SCRIPTPATH/output/include
        mkdir -p $OUTPUT_INCLUDE        
        cp -RL include/openssl $OUTPUT_INCLUDE
    fi

    OUTPUT_LIB=$SCRIPTPATH/output/lib/${android_architecture}
    mkdir -p $OUTPUT_LIB

    cp libcrypto.a $OUTPUT_LIB
    cp libssl.a $OUTPUT_LIB

    make clean
done