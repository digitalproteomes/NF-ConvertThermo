#!/bin/bash

chmod -f g+rw *.mzXML
chmod -f g+rw *.mzML
SUBMIT_PATH=`readlink -f *.raw | xargs -I [] dirname []`
test -e *.mzXML && ln *.mzXML "$SUBMIT_PATH"
test -e *.mzML && ln *.mzML "$SUBMIT_PATH"
