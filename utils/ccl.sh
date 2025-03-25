#!/bin/bash
export CCL_KVS_MODE=mpi

export ZE_ENABLE_PCI_ID_DEVICE_ORDER=1 
export CCL_PROCESS_LAUNCHER=pmix # Required by Aurora mpich 
export PALS_PMI=pmix # Required by Aurora mpich 
export CCL_ATL_TRANSPORT=mpi # Required by Aurora mpich 
export TORCH_LLM_ALLREDUCE=1
export CCL_SYCL_ESIMD=1 
export CCL_ALLGATHERV_MEDIUM_SIZE_THRESHOLD=0 # Required by current oneCCL (MLSL-2881) 
export CCL_ENABLE_SYCL_KERNELS=1 
export CCL_WORKER_AFFINITY=5,13,21,29,37,45,57,65,73,81,89,97 

export CCL_BCAST=double_tree


export CCL_KVS_CONNECTION_TIMEOUT=600

export CCL_ZE_CACHE_OPEN_IPC_HANDLES_THRESHOLD=1024
export CCL_ALLREDUCE=topo

export MPI_PROVIDER=$FI_PROVIDER # FI_PROVIDER is set my MPICH module                                                                            
unset MPIR_CVAR_CH4_POSIX_COLL_SELECTION_TUNING_JSON_FILE
unset MPIR_CVAR_CH4_COLL_SELECTION_TUNING_JSON_FILE
unset MPIR_CVAR_COLL_SELECTION_TUNING_JSON_FILE
export NEOReadDebugKeys=1
export IGC_EnableLSCFenceUGMBeforeEOT=0

export CCL_ALLGATHERV_SCALEOUT=multi_bcast
export CCL_ALLGATHER_SCALEOUT=multi_bcast
export CCL_ALLREDUCE_SCALEOUT=rabenseifner
export CCL_BCAST_SCALEOUT=double_tree
export CCL_ATL_SYNC_COLL=1
export CCL_OP_SYNC=1

export FI_CXI_RX_MATCH_MODE=hybrid
export FI_MR_CACHE_MONITOR=disabled
export FI_CXI_DEFAULT_CQ_SIZE=1048576
export FI_CXI_OFLOW_BUF_SIZE=8388608
export FI_CXI_CQ_FILL_PERCENT=30
