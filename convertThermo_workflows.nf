//////////////////////////
// Workflow definitions //
//////////////////////////


include {convertThermo;
	 convertThermoAndLink;
	 convertMzxmlP;
	 convertMzxmlAndLinkP;
	 patchWineprefixP;
	 cleanPatchWineprefixP} from './convertThermo_processes.nf'


workflow convert{
    take:
    raw_folder
    conv_params
    monitor
    link_files

    main:
    if(monitor) {
	rawFiles = channel.watchPath("${raw_folder}/*.raw")
    }
    else {
	rawFiles = channel.fromPath("${raw_folder}/*.raw")
    }

    if(link_files) {
	mzxml = convertThermoAndLink(rawFiles,
	  			     conv_params)
    }
    else {
	mzxml = convertThermo(rawFiles,
	  		      conv_params)
    }

    emit:
    mzxml
}


workflow convertMzxmlW{
    take:
    mzxml
    conv_params_msconvert
    link_files

    main:
    if(link_files) {
	convertMzxmlAndLinkP(mzxml,
			     conv_params_msconvert)
    }
    else {
	convertMzxmlP(mzxml,
		      conv_params_msconvert)
    }
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
