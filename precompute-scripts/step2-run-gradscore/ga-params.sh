#!/bin/bash

JOB_TYPE=${JOB_TYPE:=ga-em-vs-lm}

export JOB_LOGPREFIX=${JOB_LOGPREFIX:=${LOGS_DIR}/${JOB_TYPE}}

export TOTAL_NEURONS=$((${TOTAL_NEURONS:=35000}))
export START_NEURON_INDEX=$((${START_NEURON_INDEX:=0}))
export NEURONS_PER_JOB=$((${NEURONS_PER_JOB:=200}))
export TOTAL_JOBS=$(((TOTAL_NEURONS - START_NEURON_INDEX) / NEURONS_PER_JOB + 1))

export PROCESSING_PARTITION_SIZE=${PROCESSING_PARTITION_SIZE:=100}
export TOP_RESULTS=300
export SAMPLES_PER_LINE=0

export FIRST_JOB=${FIRST_JOB:-1}
export LAST_JOB=${LAST_JOB:-${TOTAL_JOBS}}
export RUN_CMD=${RUN_CMD:=localRun}
