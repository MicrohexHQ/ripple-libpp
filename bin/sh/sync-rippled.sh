#!/bin/bash

# This script is a temporary workaround to keep rippled and ripple-libpp
# source code in sync until that source is removed from rippled and
# ripple-libpp becomes a dependency.

set -e

if [ $# == 1 ]
then
	rippled=$1
else
	echo "$(basename $0) <path to rippled source repo>" >&2
	exit 1
fi

# Don't do anything if there are local changes
#### git diff --exit-code


function buildtest
{
  # Build and test
  for dir in ./build/cmake/*
  do
    cmake "${dir}"
    cmake --build "${dir}"
    "${dir}"/ripplelibppdemo
    "${dir}"/ripplelibpptest --unittest
  done
}

# time buildtest

rsync -avPh --checksum --existing --del \
  --exclude=unity --exclude='*ripple-libpp*' --exclude='CMakeLists.txt' \
  ${rippled}/src/ src/

time buildtest


echo Success
