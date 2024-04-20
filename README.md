# acqparams_maker

### Summary

The [acqparams.txt](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup/TopupUsersGuide#:~:text=encode%20blips%20first.-,%2D%2Ddatain,-This%20parameter%20specifies) describes phase encoding direction and TotalReadoutTime of dwi. It is required to correct susceptibility distortion of epi using [FSL's topup](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup/TopupUsersGuide). 

This script automatically creates acqparams.txt using json files which is made by [dcm2niix](https://github.com/rordenlab/dcm2niix).

DWI files of reversed encoding directions are required for topup.

If you want to run topup without a file of reversed encoding direction, you may want to check [Synb0-DISCO](https://github.com/MASILab/Synb0-DISCO).

### Prerequisite

DWI.json (from dcm2niix)

### Instructions

examples

```bash
# If you have only one phase encoding direction, this will make an acqparams.txt
# for Synb0-DISCO pipeline.
s_acqparams_maker dwi.json

# If you have reversed phase encoding directions, this will make an acqparams.txt
# for topup.
s_acqparams_maker dwi_AP.json dwi_PA.json

# If you want to use more than one b0 for each phase encoding directions
s_acqparams_maker dwi_AP.json dwi_PA.json 3 3 # 3 b0s for each direction
```
