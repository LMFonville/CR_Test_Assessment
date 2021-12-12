#!/usr/bin/env python
import sys
import os
import numpy as np


if len(sys.argv)>1:
    ID = str(sys.argv[1])
else:
    print ("No input argument")
    exit

# specify path and file
inputdir='/data/Test_task/output/' + ID
mc_file=inputdir + '/MC_MOCOparams.csv'

# read csv file, use numpy for ease of use
mc_params = np.loadtxt(mc_file, delimiter=",", skiprows=1)
# ignore pre and post columns
mc_params = mc_params[:, 2:]
# transpose for ease of use in selecting each parameter
mc_params_t = np.transpose(mc_params)

# calculations are based on Github documentation and discussion
# https://github.com/ANTsX/ANTsR/blob/69d65b697b14af6f2edf9fbd096a84c5fbc4d944/R/antsrMotionCalculation.R#L171-L189
# https://github.com/ANTsX/ANTsPy/issues/71

# translational parameters
trans_x, trans_y, trans_z = mc_params_t[9:]
# rotational parameters
rot_x = np.arcsin(mc_params_t[6])
cos_rot_x = np.cos(rot_x)
rot_y = np.arctan2(mc_params_t[7] / cos_rot_x, mc_params_t[8] / cos_rot_x)
rot_z = np.arctan2(mc_params_t[3] / cos_rot_x, mc_params_t[0] / cos_rot_x)
rot_x=rot_x*360/(2*np.pi)
rot_y=rot_y*360/(2*np.pi)
rot_z=rot_z*360/(2*np.pi)
# convert rotations to translations projected onto a 50mm sphere
trans = np.vstack([trans_x, trans_y, trans_z])
rot = np.vstack([rot_x, rot_y, rot_z])
rottrans = (rot/360)*2*50*np.pi
transdata=np.vstack([trans, rottrans])
transD=transdata[:,1:] - transdata[:, :-1]
FD = np.hstack([0,np.sum(np.abs(transD), axis=0)])
motion_params=np.vstack([rot, trans, FD])
new_file=inputdir + '/motion_params.txt'
np.savetxt(new_file, np.transpose(motion_params), fmt='% .6f')
