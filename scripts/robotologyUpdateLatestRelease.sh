#!/bin/bash

# Get the parent dir https://stackoverflow.com/a/246128

getParentDir () {
    SOURCE="${1}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
}

getParentDir "${BASH_SOURCE[0]}"

script_dir="$DIR"

getParentDir $script_dir

superbuild_root="$DIR"

subdirs="$superbuild_root/src"

latest_release_yaml_file="$superbuild_root/releases/2020.11.yaml"

updateLatestRelease () {
    cd $1
    # Extract package name
    package_name=`basename $1`
    # Extract latest tag
    latest_tag=`git describe --abbrev=0 --tags` 
    echo "${package_name}: ${latest_tag}" 
    # Update latest tag in latest-release.yaml file, 
    # using https://github.com/mikefarah/yq
    yq w -i ${latest_release_yaml_file} repositories.${package_name}.version ${latest_tag}
}

for subdir in ${subdirs}; do \
    if [ -d "${subdir}" ] ; then
        for i in ${subdir}/*/; do \
            updateLatestRelease $i
        done
    fi
done

