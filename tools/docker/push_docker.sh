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

get_version() {
    echo $(mvn -q \
        -Dexec.executable=echo \
        -Dexec.args='${project.version}' \
        --non-recursive \
        exec:exec)
}

### Main
echo -e "${yellow}[INFO] [${BASH_SOURCE[0]}] executed.${nocolor}"

if ! command_exists docker; then
    echo -e "${red}[ERROR] Install docker first.\n\
[MacOS] $ brew cask install docker\n\
[Linux] $ curl -fsSL https://get.docker.com | sh${nocolor}"
    exit 1
fi

if ! command_exists mvn; then
    echo -e "${red}[ERROR] install maven first. \n\
[Mac] brew install maven \n\
[Centos] yum install -y maven \n\
[Ubuntu] apt-get install -y maven${nocolor}"
    exit 1;
fi

(
cd_into_script_path
./build_docker.sh
)

(
cd_into_script_path
cd ../..

echo -e "${yellow}[INFO] getting version...${nocolor}"
version=$(get_version)
echo -e "${yellow}[INFO] getting version done. [verison=$version]${nocolor}"

docker tag config-service kujyp/config-service:$version
docker push kujyp/config-service:$version
)

echo -e "${yellow}[INFO] [${BASH_SOURCE[0]}] Done.${nocolor}"
