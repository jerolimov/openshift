#!/bin/bash

set -e

major=4
minor=12
patch_from=0
patch_until=27

# downloaded from https://console.redhat.com/openshift/create/local
authfile=$HOME/Downloads/pull-secret.txt

for patch in `seq $patch_from $patch_until`;
do
	version="$major.$minor.$patch"
	console_image=$(oc adm release info --image-for=console quay.io/openshift-release-dev/ocp-release:$version-x86_64)

	echo "Check console $version: $console_image ..."

	podman image pull "$console_image" "--authfile=$authfile"
	podman run --rm -it "$console_image" find /opt/bridge/static/
	podman image rm "$console_image"

done
