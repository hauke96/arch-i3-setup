#!/bin/bash

set -e

ORIGINAL=$(realpath $1)
REPO_LOCATION="./configs$ORIGINAL"

echo "Create target folder  $(dirname $REPO_LOCATION)  if needed"
mkdir -p $(dirname $REPO_LOCATION)

echo "Move file from  $ORIGINAL  to  $REPO_LOCATION"
mv $ORIGINAL $REPO_LOCATION

echo "Create symlink  $ORIGINAL  ->  $(realpath $REPO_LOCATION)"
ln -s $(realpath $REPO_LOCATION) $ORIGINAL
