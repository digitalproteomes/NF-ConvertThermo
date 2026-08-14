process convertThermo {
    tag "$raw"
    errorStrategy { sleep(Math.pow(2, task.attempt) * 200 as long); return 'retry' }
    maxRetries 5

    input:
    file raw
    val conv_params


    output:
    file '*.mzXML'

    script:
    """
    unset DISPLAY
    wine /usr/local/bin/ReAdW.exe ${conv_params} $raw
    """
}


process convertThermoAndLink {
    tag "$raw"
    errorStrategy { sleep(Math.pow(2, task.attempt) * 200 as long); return 'retry' }
    maxRetries 5

    afterScript "source after_conversion.sh"

    input:
    file raw
    val conv_params


    output:
    file '*.mzXML'

    script:
    """
    unset DISPLAY
    wine /usr/local/bin/ReAdW.exe ${conv_params} $raw
    """
}


process convertMzxmlP {
    tag "$mzxml"
    errorStrategy { sleep(Math.pow(2, task.attempt) * 200 as long); return 'retry' }
    maxRetries 5

    input:
    file mzxml
    val conv_params_msconvert

    output:
    file '*.mzML'

    script:
    """
    unset DISPLAY
    /usr/local/pwiz/msconvert ${conv_params_msconvert} $mzxml
    """
}


process convertMzxmlAndLinkP {
    tag "$mzxml"
    errorStrategy { sleep(Math.pow(2, task.attempt) * 200 as long); return 'retry' }
    maxRetries 5

    afterScript "source after_conversion.sh"
    
    input:
    file mzxml
    val conv_params_msconvert

    output:
    file '*.mzML'

    script:
    """
    unset DISPLAY
    /usr/local/pwiz/msconvert ${conv_params_msconvert} $mzxml
    """
}


process patchWineprefixP {
    // This process creates a copy of wineprefix from the container to /tmp
    // The copied files will be owned by the user running the analysis, hence
    // removing  wine mismatched ownership issues.
    
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

    script:
    """
    rm -rf '$wineCopyFolder'
    """
}
