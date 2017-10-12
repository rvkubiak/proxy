#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -x

function usage() {
  echo "$0 \
    -b <GCS bucket for release artifacts> \
    -t <tag name to apply to artifacts> \
    -v <version to apply instead of tag>"
  exit 1
}

# Initialize variables
BUCKET="istio-release"
TAG_NAME=""
VERSION_OVERRIDE=""

# Handle command line args
while getopts b:t:v: arg ; do
  case "${arg}" in
    b) BUCKET="${OPTARG}";;
    t) TAG_NAME="${OPTARG}";;
    v) VERSION_OVERRIDE="${OPTARG}";;
    *) usage;;
  esac
done

if [ ! -z "${VERSION_OVERRIDE}" ] ; then
  version="${VERSION_OVERRIDE}"
elif [ ! -z "${TAG_NAME}" ] ; then
  version="${TAG_NAME}"
else
  echo "Either -t or -v is a required argument."
  usage
fi

script/push-debian.sh \
    -c opt \
    -v "${version}" \
    -p "gs://${BUCKET}/releases/${version}/deb"

