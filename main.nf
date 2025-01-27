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
    log.info(" Conversion parameters:\t $params.conv_params")
    log.info("++++++++++========================================")

    convert(params.raw_folder,
	    params.conv_params,
	    params.monitor)

    if(params.mzml) {
	convertMzxmlW(convert.out.mzxml,
		      params.conv_params_msconvert)
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
    wine_folder = file('Results/MzML/wineprefix.txt').text.readLines()[0]
    
    log.info("++++++++++========================================")
    log.info("Removing wineprefix copy at:\t $wine_folder")
    log.info("++++++++++========================================")

    cleanPatchWineprefixW(wine_folder)
}
