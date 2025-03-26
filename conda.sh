#!/bin/bash
# This is the conda environment setup for Megatron-DeepSpeed code
export SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export BUILD=${BUILD:-"2025-03-25"}
export HTTP_PROXY=http://proxy.alcf.anl.gov:3128
export HTTPS_PROXY=http://proxy.alcf.anl.gov:3128
export http_proxy=http://proxy.alcf.anl.gov:3128
export https_proxy=http://proxy.alcf.anl.gov:3128
export PYTHONNOUSERSITE=1
export PPN=12
export CC=icx
export CXX=icpx

module load frameworks                        
export FI_PROVIDER="cxi,tcp;ofi_rxm"
export I_MPI_OFI_LIBRARY="/opt/cray/libfabric/1.20.1/lib64/libfabric.so.1" 
export ZE_FLAT_DEVICE_HIERARCHY=FLAT
export TRANSFER_PACKAGE=${TRANSFER_PACKAGE:-"0"}

if [[ $TRANSFER_PACKAGE -eq "0" ]]; then
    COPPER=${COPPER:-1}
else
    COPPER=${COPPER:-0}
fi

echo "Using environment from /flare/Aurora_deployment/AuroraGPT/build with copper=${COPPER}"

echo "TRANSFER_PACKAGE: ${TRANSFER_PACKAGE} ${TRANSFER}"
if [[ $TRANSFER_PACKAGE -eq "1" ]]; then
    export PBS_JOBSIZE=$(cat $PBS_NODEFILE | uniq | wc -l)    
    export DST_DIR=/tmp/
    echo "Transfer built python package ($BUILD): `date`"
    # To remove completely the dependency on Lustre, one can copy the following files to /tmp and do transfer from there. 
    mpiexec --no-vni --pmi=pmix -np $PBS_JOBSIZE --ppn 1 python ${SCRIPT_DIR}/utils/cache_soft.py \
	  --src $SCRIPT_DIR/conda.tar.gz \
	  --dst /tmp/conda.tar.gz --d
    
    export MD=${DST_DIR}/Megatron-DeepSpeed/
    echo "Transfer built python package ($BUILD): `date` Done"
    # Other environment setup
    source $DST_DIR/venvs/aurora_nre_models_frameworks-2024.2.1_u1/bin/activate
    source $DST_DIR/utils/ccl.sh
    export AGPT_ROOT=${DST_DIR}/
    # This should already been built
    #mpiexec --no-vni --pmi=pmix -np ${PBS_JOBSIZE} --ppn 1 $AGPT_ROOT/soft/interposer.sh $DST_DIR/build_helper.sh    
else
    echo "Using package on lustre"
    export AGPT_ROOT=$SCRIPT_DIR
    export DST_DIR=${AGPT_ROOT}
    source $DST_DIR/utils/ccl.sh
    export COPPER_TARGET_DIR=${DST_DIR}
    export MD=${AGPT_ROOT}/Megatron-DeepSpeed
    source $DST_DIR/venvs/aurora_nre_models_frameworks-2024.2.1_u1/bin/activate
    source $DST_DIR/utils/ccl.sh
    which python
    
    if [[ $COPPER -eq "1" ]]; then
        module load copper
        $DST_DIR/utils/launch_copper.sh
        export PYTHONPATH=/tmp/$USER/copper/$DST_DIR/venvs/aurora_nre_models_frameworks-2024.2.1_u1/lib/python3.10/site-packages/:$PYTHONPATH
        export PYTHONBASE=/tmp/$USER/copper/$DST_DIR/venvs/aurora_nre_models_frameworks-2024.2.1_u1
    else
        export PYTHONPATH=$DST_DIR/venvs/aurora_nre_models_frameworks-2024.2.1_u1/lib/python3.10/site-packages/:$PYTHONPATH
        export PYTHONBASE=$DST_DIR/venvs/aurora_nre_models_frameworks-2024.2.1_u1	
    fi
fi

echo "####### Python environment ###########"
which python
echo "--------------------------------------"

echo "####### Megatron-DeepSpeed ###########"
echo "Using Megatron-DeepSpeed code from $MD"
cd $MD
echo "Git commit: `git rev-parse HEAD`"
cd - 

IFS='.' read -ra ADDR <<< "$PBS_JOBID"
export JOBID=$ADDR
export PYTHONPATH=$MD:$PYTHONPATH
export TOKENIZER_MODEL=$AGPT_ROOT/utils/tokenizer.model
export DEEPSPEED_CONFIG_TEMPLATE=$AGPT_ROOT/utils/DEEPSPEED_CONFIG_TEMPLATE.json

echo ""
echo "================================================"
echo "Environment variables enabled"
echo "================================================"
echo "AGPT_ROOT: $AGPT_ROOT"
echo "TOKENIZER_MODEL: $TOKENIZER_MODEL"
echo "DEEPSPEED_CONFIG_TEMPLATE: $DEEPSPEED_CONFIG_TEMPLATE"
echo "Megatron-DeepSpeed Root (MD): $MD"
env >& env.dat
echo "------------------------------------------------"
echo "****CCL environment variables****"
echo "`grep CCL env.dat`"
echo "------------------------------------------------"
echo "****FI environment bariables****"
echo "`grep FI_ env.dat`"
echo "------------------------------------------------"
