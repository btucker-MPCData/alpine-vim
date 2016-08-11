#!/bin/sh

git submodule update --init --recursive
docker build -t benjamint/vim-bundle .

