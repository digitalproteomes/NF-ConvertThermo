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

    main:
    if(params.monitor) {
	rawFiles = channel.watchPath("${raw_folder}/*.raw")
    }
    else {
	rawFiles = channel.fromPath("${raw_folder}/*.raw")
    }

    emit:
    params.link_files ? convertThermoAndLink(rawFiles, params.conv_params) : convertThermo(rawFiles, params.conv_params)
}


workflow convertMzxmlW{
    take:
    mzxml

    main:
    if(params.link_files) {
	convertMzxmlAndLinkP(mzxml,
			     params.conv_params_msconvert)
    }
    else {
	convertMzxmlP(mzxml,
		      params.conv_params_msconvert)
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
