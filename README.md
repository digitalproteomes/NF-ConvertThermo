# Nextflow workflow for converting Thermo RAW MS files to mzXML

This workflow converts all .raw files in a folder to mzXML using a dockerized version of ReAdW

## Usage
**IMPORTANT**
The docker container this workflow depends on cannot be pushed to dockerhub due to licensing terms of DLLs it contains.
Please make sure to build a local copy of the container according to the instructions in [this](https://github.com/PedrioliLab/docker-readw) repository before attempting to run the workflow.

The workflow takes two parameters:
- raw_folder: The name of the folder with the RAW files (default: Data)
- conv_params: Conversion parameters to be passed to ReAdW. The following are valid parameters:
```
 Options

  --centroid, -c: Centroid all scans (MS1 and MS2)
      meaningful only if data was acquired in profile mode;
      default: off
  [Advanced option, default OFF] --precursorFromFilterLine: only
      try to get the precursor MZ value from the Thermo
      "filterline" text; only use this if you have a good reason!
      Otherwise, the program first will try to obtain a more accurate
       mass from the "Monoisotopic M/Z:" "trailer value"
  --nocompress, -n: Do not use zlib for compressing peaks
      default: on
  --verbose, -v:   verbose
  --gzip, -g:   gzip the output file (independent of peak compression)
```

Example usage:

Convert all .raw files in the Data folder to mzXML files using default settings for ReAdW:
```bash
nextflow run digitalproteomes/NF-ConvertThermo
```

Convert all .raw files in MS_files folder to centroid non-zlib compressed mzXML files:
```bash
nextflow run digitalproteomes/NF-ConvertThermo --raw_folder MS_files --conv_params "-c -n"
```

At the end of the workflow the converted files will be found in the *Results/Mzxml/* folder.

By default the converted files will be owned by the user starting the workflow. If needed a different UID and GID can be specified in *nextflow.config* by passing them as LOCAL_USER_ID and LOCAL_GROUP_ID via *runOptions*.