#!/usr/bin/env bash

MASON_NAME=sqlite-autoconf
MASON_VERSION=3300100
MASON_LIB_FILE=lib/libsqlite3.a

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
	https://www.sqlite.org/2019/sqlite-autoconf-${MASON_VERSION}.tar.gz \
	5e8023be33acf0ea7838b974375781dd5f597184

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/${MASON_NAME}-${MASON_VERSION}
}

function mason_compile {
    export CFLAGS="${CFLAGS:-} -O3 -DNDEBUG"

    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --with-pic \
        --disable-shared \
        --disable-dependency-tracking

    V=1 VERBOSE=1 make install -j${MASON_CONCURRENCY}
}

function mason_cflags {
    echo -I${MASON_PREFIX}/include
}

function mason_ldflags {
    :
}

function mason_static_libs {
    echo ${MASON_PREFIX}/${MASON_LIB_FILE}
}

function mason_clean {
    make clean
}

mason_run "$@"
