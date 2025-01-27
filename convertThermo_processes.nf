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


process convertMzxmlP {
    tag "$mzxml"
    publishDir 'Results/MzML', mode: 'link'

    input:
    file mzxml
    val conv_params_msconvert

    output:
    file '*.mzML'

    script:
    "wine /usr/local/pwiz/msconvert ${conv_params_msconvert} $mzxml"
}


process patchWineprefixP {
    // This process creates a copy of wineprefix from the container to /tmp
    // The copied files will be owned by the user running the analysis, hence
    // removing  wine mismatched ownership issues.
    publishDir 'Results/Mzxml', mode: 'link'
    
    input:

    output:
    file 'wineprefix.txt'

    script:
    """
    ORIGINAL_PREFIX=\${WINEPREFIX}
    WINEPREFIX=\$(mktemp -d /tmp/wineprefixXXXX)
    export WINEPREFIX
    cp -r \$ORIGINAL_PREFIX/* \$WINEPREFIX
    echo \$WINEPREFIX > wineprefix.txt
    """
}


process cleanPatchWineprefixP {
    input:
    val wineCopyFolder

    output:

    script:
    """
    rm -rf '$wineCopyFolder'
    """
}
