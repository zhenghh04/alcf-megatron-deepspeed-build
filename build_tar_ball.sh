#!/bin/bash
# This is to build a tarball
TARBALL=conda
BUILD=2025-03-25
tar -cvf $TARBALL.tar.gz utils Megatron-DeepSpeed venvs
cp -v $TARBALL.tar.gz /flare/Aurora_deployment/AuroraGPT/build/$BUILD/
