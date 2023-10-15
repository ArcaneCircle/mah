#!/bin/sh

case "$1" in
    "-h" | "--help")
        echo "usage: ${0##*/} [PACKAGE_NAME]"
        exit
        ;;
    "")
        PACKAGE_NAME=${PWD##*/} # '##*/' removes everything before the last slash and the last slash
        ;;
    *)
        PACKAGE_NAME=${1%.xdc} # '%.xdc' removes the extension and allows PACKAGE_NAME to be given with or without extension
        ;;
esac

rm *.xdc 2> /dev/null
cp icon.png manifest.toml dist/
cd dist
zip -9 --recurse-paths "../$PACKAGE_NAME.xdc" --exclude assets/app/ assets/app/* "./*.txt" "./*.md" -- *

echo "success, archive contents:"
unzip -l "../$PACKAGE_NAME.xdc"

# check package size
MAXSIZE=655360
size=$(wc -c < "../$PACKAGE_NAME.xdc")
if [ "$size" -ge $MAXSIZE ]; then
    echo "WARNING: package size exceeded the limit ($size > $MAXSIZE)"
fi
