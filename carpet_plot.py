#!/usr/bin/env python
import sys
import os
import numpy as np
import nibabel as nb
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

if len(sys.argv)>1:
    ID = str(sys.argv[1])
else:
    print ("No input argument")
    exit

# Produce carpet plot of data

# specify path and file
infile='/data/Test_task/' + ID + '/raw_phMRIscan.nii.gz'
inputdir='/data/Test_task/output/' + ID
mcfile=inputdir + '/motion_params.txt'
outdir=inputdir + '/plots'
if not os.path.exists(outdir):
    os.makedirs(outdir)

# Load motion data
mc_params = np.loadtxt(mcfile)
fd = mc_params[:,6]
# Plot motion parameters
fig, axes = plt.subplots(1,2, figsize=(12,4))
axes[0].plot(mc_params[:,0], 'r') # X
axes[0].plot(mc_params[:,1], 'b') # Y
axes[0].plot(mc_params[:,2], 'g') # Z
axes[0].set_title('Rotations (degrees)')
axes[0].set_xlim(0, mc_params.shape[0])
axes[0].set_xticks(np.arange(0, mc_params.shape[0], step=10))
axes[0].grid(True)
axes[1].plot(mc_params[:,3], 'r') # X
axes[1].plot(mc_params[:,4], 'b') # Y
axes[1].plot(mc_params[:,5], 'g') # Z
axes[1].set_title('Translations (mm)')
axes[1].set_xlim(0, mc_params.shape[0])
axes[1].set_xticks(np.arange(0, mc_params.shape[0], step=10))
axes[1].grid(True)
red_patch = mpatches.Patch(color='r', label='X')
blue_patch = mpatches.Patch(color='b', label='Y')
green_patch = mpatches.Patch(color='g', label='Z')
#fig.legend(handles=[red_patch, blue_patch, green_patch])
fig.legend(loc='lower right', bbox_to_anchor=(0.9, 0.1), handles=[red_patch, blue_patch, green_patch])
fig.tight_layout()
fig.savefig(outdir + "/motion_plot.jpg")

# Load imaging data
img = nb.load(infile)
data=img.get_fdata()
# flatten into 2D array with voxels on y-axis and time on x-axis
n_vox = np.prod(data.shape[0:3])
# should flatten each 2D slice along axis 0, then along axis 1
flatimg = data.reshape(n_vox, data.shape[3])
gs = flatimg.mean(axis=0)
# Plot carpet plot with global signal
fig, axes = plt.subplots(3,1, figsize=(16,9), gridspec_kw={'height_ratios': [1, 1, 2]})
# global signal
axes[0].plot(gs, 'r')
axes[0].set_title('Global Signal')
axes[0].set_xlim(0, data.shape[3])
axes[0].set_xticks(np.arange(0, data.shape[3], step=10))
axes[0].grid(True)
# framewise displacement
axes[1].plot(fd)
axes[1].set_title('Framewise Displacement')
axes[1].set_xlim(0, data.shape[3])
axes[1].set_xticks(np.arange(0, data.shape[3], step=10))
axes[1].grid(True)
# carpet plot
axes[2].imshow(flatimg, aspect='auto', cmap='gray')
axes[2].set_xlim(0, data.shape[3])
axes[2].set_xticks(np.arange(0, data.shape[3], step=10))
fig.tight_layout()
fig.savefig(outdir + "/carpet_plot.jpg")
