process convertThermo {
    tag "$raw"
    errorStrategy { task.attempt <= 5 ? 'retry' : 'ignore' }
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
    errorStrategy { task.attempt <= 5 ? 'retry' : 'ignore' }
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
    errorStrategy { task.attempt <= 5 ? 'retry' : 'ignore' }
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
    errorStrategy { task.attempt <= 5 ? 'retry' : 'ignore' }
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

process waitForStableRaw {
    tag "${raw}"

    input:
    file raw

    output:
    file raw


    script:
    """
    set -euo pipefail

    target='${raw}'
    previous=''
    stable_count=0
    elapsed=0
    max_wait=7200

    while [ \$stable_count -lt 3 ]; do
        [ \$elapsed -ge \$max_wait ] && { echo "timeout waiting for \$target" >&2; exit 1; }
        current=\$(stat -L -c '%s %Y' "\$target")

        if [ "\$current" = "\$previous" ]; then
            stable_count=\$((stable_count + 1))
        else
            stable_count=0
            previous="\$current"
        fi

        sleep 10
        elapsed=\$((elapsed + 10))
    done
    """
}
