#!/bin/sh -x


OS=`uname -s`

if [ "$OS" == "Linux" ]; then

    MD5_CMD=md5sum
    SHA_CMD=sha256sum

else
    if [ "$OS" == "Darwin" ]; then

        MD5_CMD=md5
        SHA_CMD=shasum

    else

        echo "Unsupported platform, we currently support Linux and Mac OS X"
        exit -1
    fi
fi

IN_FILES='server/tsunamid client/tsunami'
OUT_FILE='hash.txt'

echo "MD5\n" > $OUT_FILE
$MD5_CMD $IN_FILES >> $OUT_FILE

echo "\nSHA256\n" >> $OUT_FILE
$SHA_CMD $IN_FILES >> $OUT_FILE

