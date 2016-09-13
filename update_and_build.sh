#!/bin/sh

git submodule update --init --recursive
git submodule update --remote --merge
docker build -t benjamint/vim-bundle .

