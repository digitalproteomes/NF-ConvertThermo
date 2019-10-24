if(params.help) {
    log.info""
    log.info"Thermo RAW to mzXML workflow"
    log.info"----------------------------"
    log.info""
    log.info"Options:"
    log.info "  --help:         show this message and exit"
    log.info "  --raw_folder:   the folder with the RAW files (default: $params.raw_folder)"
    log.info "  --conv_params:  conversion parameters for ReAdW (default: $params.conv_params)"
    log.info ""
    log.info "Results will be in Results/Mzxml/"
    log.info ""
    exit 1
}

rawFiles = file(params.raw_folder + '/*.raw')

process convertThermo {
    publishDir 'Results/Mzxml', mode: 'link'

    input:
    file raw from rawFiles

    output:
    file '*.mzXML'

    script:
    "wine /usr/local/bin/ReAdW.exe ${params.conv_params} $raw"
}

