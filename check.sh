#!/bin/bash
# Check web site response time
# Cretad by Yevgeniy Goncharov, https:lab.sys-adm.in

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd); cd ${SCRIPT_PATH}

# Variables
# -------------------------------------------------------------------------------------------\
MAX_SITE_TIMEOUT=5

# Check web site response
# -------------------------------------------------------------------------------------------\

function is_site_available() {

    if /usr/bin/curl -sSf --max-time "${MAX_SITE_TIMEOUT}" "${1}" --insecure 2>/dev/null >/dev/null; then
        true
    else
        false
    fi
}

function check_response {
    # Check url is valid http:// or https://
    if [[ $1 != http://* ]] && [[ $1 != https://* ]]; then
        echo -e "Error: URL is not valid. Use http:// or https://"
        exit 1
    fi

    if is_site_available "${1}"; then
        echo -e "\nSite ${1} is available. Ok\n"
        echo -e "Checking..."
        curl -s -w 'Testing Website Response Time for: %{url_effective}\n\nLookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null $1

    else
        echo "Site ${1} is not available. Exit..."
        exit 1
    fi

}


# Main
# -------------------------------------------------------------------------------------------\

# Check pass arguments
if [ $# -eq 0 ]; then
  echo -e "Usage: $0 <URL>"
  exit 1
else
  check_response $1
fi