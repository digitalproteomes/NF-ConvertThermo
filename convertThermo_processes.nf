process convertThermo {
    tag "$raw"
    publishDir 'Results/Mzxml', mode: 'link'

    afterScript "source ${projectDir}/bin/after_conversion.sh"

    input:
    file raw
    val conv_params


    output:
    file '*.mzXML'

    script:
    "wine /usr/local/bin/ReAdW.exe ${conv_params} $raw"
}
