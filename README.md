# CR_Test_Assessment

A pipeline for 2-step processing of functional MRI data consisting of motion correction and registration to a study template using ANTs and Python tools only. Basic quality metrics and visualisations are included for each step. All scripts were ran inside of a Docker container setup for this task. 

The run_preproc_all.sh script runs each stage in succession for all scans included and outputs a new folder for each scan with processed data and QC plots. 
