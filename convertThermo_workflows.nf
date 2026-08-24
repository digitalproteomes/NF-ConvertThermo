//////////////////////////
// Workflow definitions //
//////////////////////////


include {convertThermo;
	 convertThermoAndLink;
	 convertMzxmlP;
	 convertMzxmlAndLinkP;
	 patchWineprefixP;
	 cleanPatchWineprefixP;
	 waitForStableRaw} from './convertThermo_processes.nf'


workflow convert{
    take:
    raw_folder
    conv_params
    monitor
    link_files

    main:
    if(monitor) {
	rawFiles = channel.watchPath("${raw_folder}/*.raw")
	// When monitoring we should make sure that a file has
	// finished writing before starting conversion
	filesForConversion = waitForStableRaw(rawFiles)
    }
    else {
	rawFiles = channel.fromPath("${raw_folder}/*.raw")
	filesForConversion = rawFiles
    }
    
    emit:
    raw_files = rawFiles
    conv_out = link_files ? convertThermoAndLink(filesForConversion, conv_params) : convertThermo(filesForConversion, conv_params)
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

    main:
    patchWineprefixP()
}


workflow cleanPatchWineprefixW {
    take:
    wineCopyFolder

    main:
    cleanPatchWineprefixP(wineCopyFolder)
}
