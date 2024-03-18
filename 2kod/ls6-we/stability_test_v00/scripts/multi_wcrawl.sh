#!/bin/bash
# run multiple wcrawl instances

#AUX_NAME="NMR_REF_RMS_Heavy"
#AUX_NAME="fit_m1_rms_heavy_m2"
#AUX_NAME="1_75_39_c2"
#AUX_NAME="M2Oe_M1He1"
AUX_NAME="tt_dist"
CPP_TEMP_ID="cpp_${AUX_NAME}"
ANALYSIS_DIR=/home1/09416/dty7/scratch/d1d2/2kod/ls6-we/stability_test_v00
CPUS=64

# TODO: could add nframes and analysis path vars to be seded 
# also prmtop

# copy and fill out new wcrawl_functions file
# this file currently has variables for 101 frames in segments and 1D dataset output
# using the 2nd column of cpptraj output (index 1)
cp -v scripts/wcrawl_functions_template.py wcrawl_functions_${AUX_NAME}.py
sed -i "s/WCRAWL_FUNCTIONS_AUX_NAME/${AUX_NAME}/" wcrawl_functions_${AUX_NAME}.py
sed -i "s/CPP_TEMP_ID/${CPP_TEMP_ID}/" wcrawl_functions_${AUX_NAME}.py

#NMR_REF=/ihome/lchong/dty7/bgfs-dty7/hiv1_capsid/2kod_std_sim/2kod_m01/02_min.pdb 
#XTAL_REF=/ihome/lchong/dty7/bgfs-dty7/hiv1_capsid/1a43_std_sim/v00/02_min.pdb 
#ALL=(6-75 94-163 36-49 124-137)
#MONO1=(6-75 36-49)
#MONO2=(94-163 124-137)

# make dir to store wcrawl associated files
mkdir -pv wcrawl/job_logs

# make accompanying cpptraj.temp file
cat << EOF > wcrawl/${CPP_TEMP_ID}.temp
parm TOP
trajin PARENT
trajin TRAJ
autoimage
#reference $NMR_REF name <st0>
#rms NMR_REF_RMS_HEAVY :6-75,94-163&!@H= ref <st0> out AUX_NAME.dat mass time 1
#rms fitting :6-75&!@H= ref <st0>
#rms RMS_M2 :94-163&!@H= nofit ref <st0> out AUX_NAME.dat mass time 1
#radgyr RoG :1-176 out AUX_NAME.dat mass nomax
#distance M1_M2 :32@OE1,OE2 :129@HE1 out AUX_NAME.dat
#distance M2_M1 :120@OE1,OE2 :41@HE1 out AUX_NAME.dat
#vector D1 :1-75@CA,C,O,N :39@CA,C,O,N 
#vector D2 :89-163@CA,C,O,N :127@CA,C,O,N 
#vectormath vec1 D1 vec2 D2 out AUX_NAME.dat name C2_Angle dotangle
distance T45-T133 :45&!@CA,C,O,N,H :133&!@CA,C,O,N,H out AUX_NAME.dat
go
quit
EOF

# make accompanying run_w_crawl.slurm file
cat << EOF > run_w_crawl_${AUX_NAME}.slurm
#!/bin/bash
#SBATCH --job-name=wcrawl_2kod_stability_v00_${AUX_NAME}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=${CPUS}
#SBATCH --output=wcrawl/job_logs/slurm_wcrawl_${AUX_NAME}.out
#SBATCH --error=wcrawl/job_logs/slurm_wcrawl_${AUX_NAME}.err
##SBATCH --time=12:00:00
#SBATCH --time=2:00:00
#SBATCH -p development
##SBATCH -p normal
#SBATCH -A MCB23004
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL

set -x

# Specify the analysis directory 
ANALYSIS_DIR=${ANALYSIS_DIR}

# change directory into the ANALYSIS_DIR.  
cd \${ANALYSIS_DIR} 

source env.sh || exit 1

# Do this if you are using one node (otherwise need work manager):
w_crawl \
  wcrawl_functions_${AUX_NAME}.calculate \
  -c wcrawl_functions_${AUX_NAME}.crawler \
  --verbose \
  --first-iter=9800 \
  --last-iter=10000 \
  --work-manager=processes \
  --n-workers=${CPUS} &&
#  --serial &&
#  --last-iter=10 \
#  --n-workers=${CPUS} &&

# clean up
rm -v wcrawl_functions_${AUX_NAME}.py

EOF

# transfer submission script to slurm queue
sbatch run_w_crawl_${AUX_NAME}.slurm
cat run_w_crawl_${AUX_NAME}.slurm
rm -v run_w_crawl_${AUX_NAME}.slurm

