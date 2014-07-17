#!/bin/bash
set -e
[ -z $EM_DIR ] && EM_DIR=~/src/emscripten
[ -z $PDCURSES_DIR ] && PDCURSES_DIR=~/src/PDCurses-3.4

do_config() {
    echo config
CPPFLAGS=-I$PDCURSES_DIR \
$EM_DIR/emconfigure ./configure \
  --disable-nls \

}

do_make() {
$EM_DIR/emmake make -j8
}

do_link() {
pushd web
cp ../src/typespeed typespeed.bc
# Use vim.js as filename to generate vim.js.mem
$EM_DIR/emcc typespeed.bc \
    -o typespeed.js \
    $PDCURSES_DIR/sdl1/libpdcurses.a \
    -Oz \
    -s ASYNCIFY=1 \
    -s EXPORTED_FUNCTIONS="['_main']" \
    --preload-file pdcfont.bmp \
    --embed-file usr \

popd
}

#do_config
do_make
do_link
