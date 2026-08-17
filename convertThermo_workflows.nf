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

    emit:
    link_files ? convertThermoAndLink(rawFiles, conv_params) : convertThermo(rawFiles, conv_params)
}


workflow convertMzxmlW{
    take:
    mzxml
    conv_params_msconvert
    link_files

    main:
    if(link_files) {
	out_ch = convertMzxmlAndLinkP(mzxml,
			     conv_params_msconvert)
    }
    else {
	out_ch = convertMzxmlP(mzxml,
		      conv_params_msconvert)
    }
    emit:
    out = out_ch
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
