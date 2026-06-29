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
    log.info(" Monitor mode:\t ${params.monitor.toBoolean() ? 'true' : 'false'}")
    log.info(" Converting to MzML:\t ${params.mzml.toBoolean() ? 'true' : 'false'}")
    log.info(" Linking converted files to original RAW file location:\t ${params.linkfiles.toBoolean() ? 'true' : 'false'}")
    log.info("++++++++++========================================")

    convert(params.raw_folder)
    
    if(params.mzml.toBoolean()) {
	convertMzxmlW(convert.out)
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
