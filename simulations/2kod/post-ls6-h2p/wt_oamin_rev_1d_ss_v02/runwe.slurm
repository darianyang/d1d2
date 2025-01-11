#!/bin/bash
#SBATCH --job-name=00rev_wt_oamin_ssWE_D1D2
#SBATCH --output=job_logs/%j_slurm.out
#SBATCH --error=job_logs/%j_slurm.err
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=4
#SBATCH --cluster=gpu
#SBATCH --partition=a100_multi
#SBATCH --gres=gpu:4
#SBATCH --mem=16g
#SBATCH --time=24:00:00
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL,BEGIN

echo "START `date +"%Y"-%m-%dT%T` `date +"%s"`" 
echo "JobID:    ${SLURM_JOB_ID}"
echo "User:     ${USER}"
echo "Hostlist: ${SLURM_NODELIST}"
#-------------------------

# WE INIT & RUN

  source env.sh || exit 1

  cd $WEST_SIM_ROOT

  SERVER_INFO=$WEST_SIM_ROOT/west_zmq_info-$SLURM_JOBID.json

  if [ ! -f "west.h5" ] ; then
      source init.sh
  fi

# start server
  #_run --debug --work-manager=zmq \
  #w_run --verbose --work-manager=zmq \
#  w_run --work-manager=zmq \
#      --n-workers=0 \
#      --zmq-mode=master \
#      --zmq-write-host-info=$SERVER_INFO \
#      --zmq-comm-mode=ipc &> west-$SLURM_JOBID.log &
w_run --zmq-startup-timeout 3600 \
    --zmq-shutdown-timeout 360 \
    --zmq-timeout-factor 240 \
    --zmq-master-heartbeat 3 \
    --zmq-worker-heartbeat 120 \
    --work-manager=zmq \
    --n-workers=0 \
    --zmq-mode=master \
    --zmq-write-host-info=$SERVER_INFO \
    --zmq-comm-mode=ipc &> west-$SLURM_JOBID.log &
#    --zmq-comm-mode=ipc > west.log

  echo " -> Finished launching master."

# wait on master to create SERVER_INFO file
  for ((n=0; n<60; n++)); do
    if [ -e $SERVER_INFO ] ; then
        echo "== server info file $SERVER_INFO =="
        cat $SERVER_INFO
        break
    fi
    sleep 1
  done

  echo " -> Found SERVER_INFO file, launching clients."

# exit if host info file doesn't appear in one minute
  if ! [ -e $SERVER_INFO ] ; then
    echo 'server failed to start'
    exit 1
  fi

  echo " -> Found SERVER_INFO file, launching clients."

  scontrol show hostname $SLURM_NODELIST >& SLURM_NODELIST.log

# start clients on nodes, with the proper number of cores on each
  for node in $(scontrol show hostname $SLURM_NODELIST); do
    echo " -> Launching client on $node."
    export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH
    ssh -o StrictHostKeyChecking=no $node $PWD/node.sh \
        $PWD \
        $SLURM_JOBID \
        $node \
        $CUDA_VISIBLE_DEVICES \
          --verbose \
          --work-manager=zmq \
	      --n-workers=$SLURM_NTASKS_PER_NODE \
          --zmq-mode=client \
          --zmq-read-host-info=$SERVER_INFO \
          --zmq-comm-mode=ipc &> job_logs/node.log$$ &
  done
  echo " -> Launching Completed... ."

  wait

#-------------------------

echo "END `date +"%Y"-%m-%dT%T` `date +"%s"`" 

