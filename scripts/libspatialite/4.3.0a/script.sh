#!/usr/bin/env bash

MASON_NAME=libspatialite
MASON_VERSION=4.3.0a
MASON_LIB_FILE=lib/libspatialite.a

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        http://www.gaia-gis.it/gaia-sins/libspatialite-${MASON_VERSION}.tar.gz \
	48f89c81628f295eec9d239f5e2209a521da053d

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/${MASON_NAME}-${MASON_VERSION}
}

function mason_compile {
    export CXXFLAGS='-D_GLIBCXX_USE_CXX11_ABI=0'
    export CFLAGS="${CFLAGS:-} -O3 -DNDEBUG -DLIBXML_SCHEMAS_ENABLED -pthread -Wl,--no-as-needed -ldl -lm -lstdc++"

# export "CFLAGS="
# export "LDFLAGS=-L${MASON_ROOT}/.link/lib"
#	--disable-geosadvanced 
#	--disable-geos 


export "PKG_CONFIG_LIBDIR=${MASON_ROOT}/.link/lib/pkgconfig"

    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --with-pic \
        --disable-shared \
	--disable-freexl \
	--with-geosconfig=${MASON_ROOT}/.link/bin/geos-config \
        --disable-dependency-tracking



    V=1 VERBOSE=1 make install -j${MASON_CONCURRENCY}
}

function mason_cflags {
    echo -I${MASON_PREFIX}/include
}

function mason_ldflags {
    echo 
}

function mason_static_libs {
    echo ${MASON_PREFIX}/${MASON_LIB_FILE}
}

function mason_clean {
    make clean
}

mason_run "$@"
