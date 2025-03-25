#!/bin/bash
export MD=${MD:-"Megatron-DeepSpeed"}
cd ${MD}/megatron/data
make
cd -
