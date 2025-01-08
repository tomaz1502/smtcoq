#!/bin/sh

set -xe

cd ../

opam install . --deps-only

cd src

make -j
make install

cd extraction

make

cp smtcoq ../../bench
