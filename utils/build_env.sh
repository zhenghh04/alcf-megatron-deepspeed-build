#!/bin/bash
# Please run this on a compute node
# I would like to disable using the user library
export PYTHONNOUSERSITE=1
BUILD=${BUILD:-$(date +%Y-%m-%d)}
export WORKDIR=${WORKDIR:-"$PWD/build/$BUILD"}
mkdir -p $WORKDIR
export https_proxy=http://proxy.alcf.anl.gov:3128
export http_proxy=http://proxy.alcf.anl.gov:3128
export VIRTUAL_ENV=$WORKDIR/venvs
[ -e $WORKDIR/venvs ] || (source <(curl 'https://raw.githubusercontent.com/saforem2/ezpz/refs/heads/main/src/ezpz/bin/utils.sh') && VIRTUAL_ENV=$WORKDIR/venvs ezpz_setup_env)
source $VIRTUAL_ENV/bin/activate
pip3 install --upgrade pip
pip3 install sentencepiece
pip3 install deepspeed
pip3 install git+https://github.com/saforem2/ezpz
pip3 install pydftracer==1.0.5
pip3 install schedulefree
git clone https://github.com/argonne-lcf/Megatron-DeepSpeed.git 
