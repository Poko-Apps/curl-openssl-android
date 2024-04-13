#!/bin/bash -e

# change our dir to where our script is, and then print pwd
WORK_PATH=$(cd "$(dirname "$0")";pwd)
MIN_API=21
HOST_TAG=linux-x86_64
BUILD_DIR=${WORK_PATH}/build
OPENSSL_SRC_DIR=${WORK_PATH}/openssl-${OPENSSL_VERSION}
CURL_SRC_DIR=${WORK_PATH}/curl-${CURL_VERSION}

export ANDROID_NDK_ROOT=${WORK_PATH}/android-ndk-${ANDROID_NDK_VERSION}
TOOLCHAIN=${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/${HOST_TAG}
PATH=${TOOLCHAIN}/bin:$PATH


function build_openssl() {
    TARGET_HOST=$1
    OPENSSL_ARCH=$2
    INSTALL_DIR=${BUILD_DIR}/openssl-${OPENSSL_VERSION}/${ANDROID_ABI}
    mkdir -p ${INSTALL_DIR}
    
    ./Configure ${OPENSSL_ARCH} no-tests no-unit-test no-shared -static no-asm -D__ANDROID_API__=${MIN_API} --prefix=${INSTALL_DIR}
    make -j$(($(getconf _NPROCESSORS_ONLN) + 1))
    make install_sw
    #clean up
    rm -rf ${OPENSSL_SRC_DIR}
    rm -rf ${INSTALL_DIR}/bin
    rm -rf ${INSTALL_DIR}/share
    rm -rf ${INSTALL_DIR}/ssl
    rm -rf ${INSTALL_DIR}/lib/engines*
    rm -rf ${INSTALL_DIR}/lib/pkgconfig
    rm -rf ${INSTALL_DIR}/lib/ossl-modules
}

function build_curl() {
    export TARGET_HOST=$1
    export ANDROID_ARCH=${ANDROID_ABI}
    export AR=${TOOLCHAIN}/bin/llvm-ar
    export CC=${TOOLCHAIN}/bin/${TARGET_HOST}${MIN_API}-clang
    export AS=${CC}
    export CXX=${TOOLCHAIN}/bin/${TARGET_HOST}${MIN_API}-clang++
    export LD=${TOOLCHAIN}/bin/ld
    export RANLIB=${TOOLCHAIN}/bin/llvm-ranlib
    export STRIP=${TOOLCHAIN}/bin/llvm-strip
    
    INSTALL_DIR=${BUILD_DIR}/curl-${CURL_VERSION}/${ANDROID_ABI}
    mkdir -p ${INSTALL_DIR}
    
    ./configure --host=${TARGET_HOST} \
                --target=${TARGET_HOST} \
                --prefix=${INSTALL_DIR} \
                --with-openssl=${BUILD_DIR}/openssl-${OPENSSL_VERSION}/${ANDROID_ABI} \
                --with-pic --disable-shared

    make -j$(($(getconf _NPROCESSORS_ONLN) + 1))
    make install
    #clean up
    rm -rf ${CURL_SRC_DIR}
    rm -rf ${INSTALL_DIR}/bin
    rm -rf ${INSTALL_DIR}/share
    rm -rf ${INSTALL_DIR}/lib/pkgconfig
}




if [ "$ANDROID_ABI" == "armeabi-v7a" ]
then
    cd ${OPENSSL_SRC_DIR}
    build_openssl armv7a-linux-androideabi android-arm
    cd ${CURL_SRC_DIR}
    build_curl armv7a-linux-androideabi
    
elif [ "$ANDROID_ABI" == "arm64-v8a" ]
then
    cd ${OPENSSL_SRC_DIR}
    build_openssl aarch64-linux-android android-arm64
    cd ${CURL_SRC_DIR}
    build_curl aarch64-linux-android

elif [ "$ANDROID_ABI" == "x86" ]
then
    cd ${OPENSSL_SRC_DIR}
    build_openssl i686-linux-android android-x86
    cd ${CURL_SRC_DIR}
    build_curl i686-linux-android

elif [ "$ANDROID_ABI" == "x86_64" ]
then
    cd ${OPENSSL_SRC_DIR}
    build_openssl x86_64-linux-android android-x86_64
    cd ${CURL_SRC_DIR}
    build_curl x86_64-linux-android
else
    echo "Unsupported target ABI: $ANDROID_ABI"
    exit 1
fi