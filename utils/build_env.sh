#!/bin/bash
# Please run this on a compute node
BUILD=2025-03-25
export WORKDIR=${WORKDIR:-"/flare/Aurora_deployment/AuroraGPT/build/$BUILD"}
export https_proxy=http://proxy.alcf.anl.gov:3128
export http_proxy=http://proxy.alcf.anl.gov:3128
[ -e $WORKDIR/venvs ] || (source <(curl 'https://raw.githubusercontent.com/saforem2/ezpz/refs/heads/main/src/ezpz/bin/utils.sh') && ezpz_setup_env)
export VENV=$WORKDIR/venvs/$(ls $WORKDIR/venvs/)
source $VENV/bin/activate
pip3 install --upgrade pip
pip3 install sentencepiece
pip3 install deepspeed
pip3 install git+https://github.com/saforem2/ezpz
pip3 install pydftracer==1.0.5
pip3 install schedulefree
git clone https://github.com/argonne-lcf/Megatron-DeepSpeed.git 
