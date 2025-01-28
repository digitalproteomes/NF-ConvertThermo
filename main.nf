nextflow.enable.dsl=2

include {convert;
	 convertMzxmlW;
	 patchWineprefixW;
	 cleanPatchWineprefixW} from './convertThermo_workflows.nf'

workflow {
    main:
    log.info("++++++++++========================================")
    log.info("Executing ConvertThermo workflow")
    log.info("")
    log.info("Parameters:")
    log.info(" RAW folder:\t $params.raw_folder")
    log.info(" MzXML conversion parameters:\t $params.conv_params")
    if(params.mzml) {
	log.info(" Will convert to MzML")
	log.info(" MzML conversion parameters:\t $params.conv_params_msconvert")
    }
    if(params.link_files) {
	log.info(" Linking converted files to original RAW file location.")
    }
    log.info("++++++++++========================================")

    convert(params.raw_folder,
	    params.conv_params,
	    params.monitor,
	    params.link_files)

    if(params.mzml) {
	convertMzxmlW(convert.out.mzxml,
		      params.conv_params_msconvert,
		      params.link_files)
    }
}


workflow wineprefix {
    main:
    log.info("++++++++++========================================")
    log.info("Patching wineprefix ownershnip")
    log.info("++++++++++========================================")

    patchWineprefixW()
}


workflow cleanWineprefix {
    main:
    wine_folder = file('Results/Mzxml/wineprefix.txt').text.readLines()[0]
    
    log.info("++++++++++========================================")
    log.info("Removing wineprefix copy at:\t $wine_folder")
    log.info("++++++++++========================================")

    cleanPatchWineprefixW(wine_folder)
}
