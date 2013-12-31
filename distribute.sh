#!/bin/sh -x

# Fix Local bug in Python / Mac
export LANG=
export LC_CTYPE=

# TODO - add appropriate error handling

#
# 1. Make the binaries
#
make

#
# 2. Compute the hashes
#

OS=`uname -s`

if [ "$OS" == "Linux" ]; then

    MD5_CMD=md5sum
    SHA_CMD=sha1sum

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

echo "MD5" > $OUT_FILE
$MD5_CMD $IN_FILES >> $OUT_FILE

echo "SHA256" >> $OUT_FILE
$SHA_CMD $IN_FILES >> $OUT_FILE

#
# 3. Upload to S3 bucket
# (AWS CLI must be configured - see http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
#

BUCKET=tsunami-udp
BUCKET_REGION="eu-west-1"
TSUNAMI_VERSION=`cat include/tsunami-cvs-buildnr.h  | grep TSUNAMI_CVS_BUILDNR | cut -f 2 -d "\""`
OS_VERSION=`uname -a | cut -f 3 -d " "`

KEY_PREFIX="$TSUNAMI_VERSION/$OS"_"$OS_VERSION"
aws s3 cp --region $BUCKET_REGION $OUT_FILE "s3://$BUCKET/$KEY_PREFIX/$OUT_FILE"
for FILE in $IN_FILES
do
  FILE_NAME=`echo $FILE | cut -f 2 -d "/"`
  aws s3 cp --region $BUCKET_REGION $FILE "s3://$BUCKET/$KEY_PREFIX/$FILE_NAME"
done
