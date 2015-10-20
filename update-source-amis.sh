#!/bin/bash -e

template="template.json"

distro=`jq -r '.builders[0].tags.Release' $template`
region=`jq -r '.builders[0].region' $template`

echo "distro=\"$distro\""
echo "region=\"$region\""

source_ami=`ubuntu-cloudimg-query server $region hvm ebs amd64 $distro`

echo "source_ami=\"$source_ami\""

# in-place (-i) may not be available
tmp=`mktemp`
jq ".variables.source_ami = \"$source_ami\"" $template > $tmp
mv $tmp $template
