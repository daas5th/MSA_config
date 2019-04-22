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


### Main
echo -e "${yellow}[INFO] [${BASH_SOURCE[0]}] executed.${nocolor}"

(
cd_into_script_path
cd ..

if ! ls target/*.jar 1> /dev/null 2>&1; then
    echo -e "${red}[ERROR] A packaged jar file doesn't exist. \n\
$ mvn package${nocolor}"
    exit 1;
fi

java -jar target/*.jar
)
echo -e "${yellow}[INFO] [${BASH_SOURCE[0]}] Done.${nocolor}"
