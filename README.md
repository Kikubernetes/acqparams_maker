# acqparams_maker

### Summary

The [acqparams.txt](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup/TopupUsersGuide#:~:text=encode%20blips%20first.-,%2D%2Ddatain,-This%20parameter%20specifies) describes phase encoding direction and TotalReadoutTime of dwi. It is required to correct susceptibility distortion of epi using [FSL's topup](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup/TopupUsersGuide). Please see the FSL website for detail.

This shell script automatically creates acqparams.txt using json files which is made by dcm2niix.

DWI files of reversed encoding directions are required for topup.

If you want to run topup without file of reversed encoding direction, you may want to check [Synb0-DISCO](https://github.com/MASILab/Synb0-DISCO).

### Required software

FSL

### Instructions

1. Clone this repository.
2. Put your json files in this directory.
3. run the following command:

```
cd acqparams_maker
./acqparams_maker.sh dwi.json dwi_of_reversed_phase_encoding.json
   ```

4. You will be asked how many b0s you want to use for topup. You may choose from a minimum of one to a maximum of b0  volumes.
5. Note that when you will merge b0s for topup --imain, the order of files should be $1 first and $2 second.