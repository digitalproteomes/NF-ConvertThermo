#!/bin/bash

chmod g+rw *.mzXML
SUBMIT_PATH=`readlink -f *.raw | xargs -I [] dirname []`
ln *.mzXML "$SUBMIT_PATH"
