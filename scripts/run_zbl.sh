#!/bin/bash

# export CUDA_VISIBLE_DEVICES=0,1

llmc=/mnt/nvme0/zhangbilang/code/workspace/llmc
export PYTHONPATH=$llmc:$PYTHONPATH

task_name=awq_w2a16g64_fakequant_eval_general_llama2-70b_tp1_save_tp4_eval
config=${llmc}/configs/quantization/Awq/awq_w4a16_fakequant_eval_general.yml
# config=${llmc}/configs/quantization/RTN/rtn_w4a16_fakequant_eval.yml
nnodes=1
nproc_per_node=1


MASTER_ADDR=127.0.0.1
MASTER_PORT=$((10000 + RANDOM % 20000))

RANDOM=$(python -c 'import uuid; print(uuid.uuid4())')
task_id=$RANDOM

# nohup \
torchrun \
--nnodes $nnodes \
--nproc_per_node $nproc_per_node \
--rdzv_id $task_id \
--rdzv_backend c10d \
--rdzv_endpoint $MASTER_ADDR:$MASTER_PORT \
${llmc}/llmc/__main__.py --config $config --task_id $task_id \
# > ${task_name}.log 2>&1 &

# sleep 2
# ps aux | grep '__main__.py' | grep $task_id | awk '{print $2}' > ${task_name}.pid

# You can kill this program by 
# xargs kill -9 < xxx.pid
# xxx.pid is ${task_name}.pid file
