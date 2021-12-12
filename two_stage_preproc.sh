#!/bin/bash

## 2-STEP PROCESSING OF FUNCTIONAL MRI DATA
# Motion Correction
# Alignment to study-template

# Specify input (parent script will have checked file)
# rewrite with flags for reusable interface
# -o is output dir, -t is template, -i is input scan
# add overwrite flag to speed up further?

if [ $# -eq 0 ]; then
  echo "No input variables defined. Exiting."
  exit
fi

while [ _$1 != _ ]; do
  if [ $1 = -o ]; then
    outdir=$2
    shift 2
  elif [ $1 = -t ]; then
    template=$2
    shift 2
  elif [ $1 = -i ]; then
    input=$2
    shift 2
  fi
done

echo "Data is: ${input}"
echo "Using template: ${template}"
echo "Storing outputs in: ${outdir}"

# MOTION CORRECTION
echo "Running Motion Correction"
mc_start=$(date +%s)

## Average the timeseries
antsMotionCorr  -d 3 -a ${input} -o ${outdir}/MC_avg.nii.gz

## Motion Correction
# Use global correlation metric and realign each volume to the average scan
antsMotionCorr -d 3 -o [${outdir}/MC_, ${outdir}/MC_phMRIscan.nii.gz, ${outdir}/MC_avg.nii.gz] \
-m GC[ ${outdir}/MC_avg.nii.gz, ${input}, 1 , 1 , Random, 0.05  ] \
-t Affine[ 0.1 ] -i 15 -u 1 -e 1 -s 0 -f 1 -n 10

mc_end=$(date +%s)
mc_duration=$(( mc_end - mc_start ))
echo "Motion correction finished. Time elapsed: ${mc_duration}"

# Below is not really needed, commented out
## Calculate Additional Motion Parameters
### Create quick and easy mask for stats calculations
#ThresholdImage 3 ${outdir}/MC_avg.nii.gz ${outdir}/MC_avg_mask.nii.gz Otsu 1
### Calculate mean and max displacement within mask as early indicator of how much each volume has to shift
#antsMotionCorrStats -x ${outdir}/MC_avg_mask.nii.gz \
#-m ${outdir}/MC_MOCOparams.csv \
#-o ${mc_prefix}_corrected.csv \
#-f -s

# WARP
echo "Start alignment to template"
reg_start=$(date +%s)

## Registration
# Quick alignment of scans using just rigid procedure
# order is [fixed, moving, parameters]
antsRegistration -d 3 -r [ ${template}, ${outdir}/MC_avg.nii.gz, 1] \
-t Rigid[0.1] \
-m MI[ ${template}, ${outdir}/MC_avg.nii.gz, 1, 32] \
-c 0 -f 4 -s 2 \
-o [${outdir}/regRigid_, ${outdir}/regRigid_MC_avg.nii.gz.nii.gz]

## Apply Warp to Timeseries
antsApplyTransforms -d 3 -e 3 \
-i ${outdir}/MC_phMRIscan.nii.gz \
-r ${template} \
-t ${outdir}/regRigid_0GenericAffine.mat \
-o ${outdir}/regRigid_MC_phMRIscan.nii.gz

reg_end=$(date +%s)
reg_duration=$(( reg_end - reg_start ))
echo "Alignment of timeseries has finished. Time elapsed: ${reg_duration}"
