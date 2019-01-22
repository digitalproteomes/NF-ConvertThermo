rawFiles = file(params.raw_folder + '/*.raw')

process convertThermo {
    publishDir 'Results/Mzxml'

    input:
    file raw from rawFiles

    output:
    file '*.mzXML'

    script:
    "/usr/local/bin/entrypoint.sh wine /usr/local/bin/ReAdW.exe ${params.conv_params} $raw"
}

