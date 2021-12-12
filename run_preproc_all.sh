#!/bin/bash

# Specify paths
inputdir=/data/Test_task
mkdir -p ${inputdir}/output
## TEMPLATE WAS MASKED TO IMPROVE REGISTRATION
## THE ASSIGNED MASK WAS FIRST REORIENTED USING IN ITK-SNAP

if [ ! -e ${inputdir}/output/template_masked.nii.gz ]; then
  ImageMath 3 ${inputdir}/output/template_masked.nii.gz m ${inputdir}/template.nii.gz ${inputdir}/template_mask_reorient.nii.gz
fi

template=${inputdir}/output/template_masked.nii.gz

# Find files
cd ${inputdir}

find . -type d -regex './[0-9]*' | cut -c 3,4,5 > ${inputdir}/all_ids.txt

# Loop through each ID
while read -r line
do
  echo "Running scan ID: $line"
  data=${inputdir}/${line}/raw_phMRIscan.nii.gz
  # Check if file exists
  if [ ! -e ${data} ]; then
    echo "No file found for ${line}."
    break
  fi
  # Check if file is right format by looking at number of timepoints
  nVolumes=`PrintHeader ${data} | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1`
  allDims=`PrintHeader ${data}  2`
  if [ "$nVolumes" -lt 2 ]; then
    echo "Data for scan ID: ${line} is not a timeseries."
    # skip rest of processing steps for this ID
    break
  fi
  echo "Data dimensions are: ${allDims}"
  # Create output folder
  mkdir -p ${inputdir}/output/${line}

  # Run preprocessing steps
  # requires input scan, template, outputfolder
  echo "Starting preprocessing for scan ID: $line"
  ${inputdir}/code/two_stage_preproc.sh -i $data -t $template -o ${inputdir}/output/${line}

  # Run calculation of motion parameters
  echo "Calculating motion parameters"
  python ${inputdir}/code/get_mc_params.py ${line}

  # Run some basic quality control

  # Plot overlay of template on aligned average scan to check registration quality
  echo "Plotting registration alignment using average scan and template"
  ${inputdir}/code/plot_img.sh ${line}

  # Plot movement parameters along with carpet plot following realignment to examine signal over time
  echo "Plotting summary graphs"
  python ${inputdir}/code/carpet_plot.py ${line}

  echo "Finished processing for scan ID: ${line}"

done < ${inputdir}/all_ids.txt
