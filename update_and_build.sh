#!/bin/sh

cd alpine-vim-base
./build.sh

cd ../vim-pathogen
./build.sh

cd ../wrapper
./build.sh

cd ..

git submodule update --init --recursive
git submodule update --remote --merge
docker build -t benjamint/vim-bundle .

