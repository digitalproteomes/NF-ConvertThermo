process convertThermo {
    publishDir 'Results/Mzxml', mode: 'link'

    input:
    file raw from rawFiles

    output:
    file '*.mzXML'

    script:
    "wine /usr/local/bin/ReAdW.exe ${params.conv_params} $raw"
}
