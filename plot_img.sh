#!/bin/bash

if [ $# -eq 0 ]; then
  echo "No input variables defined. Exiting."
  exit
fi

# Plot overlay of template on average aligned volume
ID=$1
# Specify paths
inputdir=/data/Test_task
outdir=${inputdir}/output/${ID}



mkdir -p ${outdir}/plots

# If no RGB overlay exists yet, make one
if [ ! -e ${inputdir}/template_masked_rgb.nii.gz ]; then
  ConvertScalarImageToRGB 3 ${inputdir}/output/template_masked.nii.gz ${inputdir}/output/template_masked_rgb.nii.gz none hot none 0 35 0 255
fi
# Check average aligned image exists as well
if [ ! -e ${outdir}/regRigid_MC_avg.nii.gz ]; then
  echo "No file found in ${outdir}."
  exit
fi

nSlices=`PrintHeader 005/raw_phMRIscan.nii.gz | grep Dimens | cut -d ',' -f 3 | cut -d ']' -f 1`
seqSlices=`echo $(seq 1 ${nSlices})`

# Overlay shows average timeseries with study template overlaid in red
# Only plot relevant slices
#CreateTiledMosaic -i ${outdir}/regRigid_MC_avg.nii.gz -r ${inputdir}/output/template_masked_rgb.nii.gz -x ${inputdir}/output/template_masked_rgb.nii.gz -t 1x7 -d z -a 0.3 -s 2x4x6x8x10x12x14 -o ${outdir}/plots/template_on_avg.png
# Plot all slices as figure size changes with number of slices
#CreateTiledMosaic -i ${outdir}/regRigid_MC_avg.nii.gz -r ${inputdir}/output/template_masked_rgb.nii.gz -x ${inputdir}/output/template_masked_rgb.nii.gz -t 3x6 -d z -a 0.3 -o ${outdir}/plots/template_on_avg.png

CreateTiledMosaic -i ${outdir}/regRigid_MC_avg.nii.gz -r ${inputdir}/output/template_masked_rgb.nii.gz -x ${inputdir}/output/template_masked_rgb.nii.gz -s -d z -a 0.3 -o ${outdir}/plots/template_on_avg.png
