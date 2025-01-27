//////////////////////////
// Workflow definitions //
//////////////////////////


include {convertThermo;
	 convertMzxmlP;
	 patchWineprefixP;
	 cleanPatchWineprefixP} from './convertThermo_processes.nf'


workflow convert{
    take:
    raw_folder
    conv_params
    monitor

    main:
    if(monitor) {
	rawFiles = channel.watchPath("${raw_folder}/*.raw")
    }
    else {
	rawFiles = channel.fromPath("${raw_folder}/*.raw")
    }

    mzxml = convertThermo(rawFiles,
	  		  conv_params)

    emit:
    mzxml
}


workflow convertMzxmlW{
    take:
    mzxml
    conv_params_msconvert

    main:
    convertMzxmlP(mzxml,
		  conv_params_msconvert)
}


workflow patchWineprefixW {
    take:

    main:
    patchWineprefixP()
}


workflow cleanPatchWineprefixW {
    take:
    wineCopyFolder

    main:
    cleanPatchWineprefixP(wineCopyFolder)
}
