#!/bin/bash -e

yellow="\033[0;33m"
red="\033[0;31m"
nocolor="\033[0m"

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

get_script_path() {
    local _src="${BASH_SOURCE[0]}"
    while [[ -h "${_src}" ]]; do
        local _dir="$(cd -P "$( dirname "${_src}" )" && pwd)"
        local _src="$(readlink "${_src}")"
        if [[ "${_src}" != /* ]]; then _src="$_dir/$_src"; fi
    done
    echo $(cd -P "$(dirname "$_src")" && pwd)
}

cd_into_script_path() {
    local script_path=$(get_script_path)
    cd ${script_path}
}

info_msg() {
    echo -e "${yellow}[INFO] $@${nocolor}"
}

err_msg() {
    echo -e "${red}[ERROR] $@${nocolor}" >&2
}

usage() {
    err_msg "Usage:
$0 --tag master-d037ab9c
$0 --tag latest
"
}


### Main
info_msg "[${BASH_SOURCE[0]}] executed."

if ! command_exists docker; then
    err_msg "Install docker first.\n\
[MacOS] $ brew cask install docker\n\
[Linux] $ curl -fsSL https://get.docker.com | sh"
    exit 1
fi

while true; do
    if [[ $# -eq 0 ]]; then
        break
    fi

    case $1 in
        --tag)
            shift

            case $1 in (-*|"") usage; exit 1; esac
            tag="$1"
            shift; continue
            ;;
    esac
    shift
done


if [[ -z ${tag} ]]; then
    usage
    exit 1
fi

(
cd_into_script_path
cd ../..

tag_args="config-service daas5th/config-service:${tag}"
info_msg "[$ docker tag ${tag_args}]"
docker tag ${tag_args}

info_msg "[$ docker push ${tag_args}]"
push_args="daas5th/config-service:${tag}"
docker push ${push_args}
)

info_msg "[${BASH_SOURCE[0]}] Done."
