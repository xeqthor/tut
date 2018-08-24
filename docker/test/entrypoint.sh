#!/bin/bash -eu

if [[ -z "$@" ]]; then
    echo -e "\033[1;31mMust be given a command to run. This should not be possible as ./test.sh always passes something.\033[0m"
    exit 2
elif ! command -v -- "$1" &> /dev/null; then
    echo -e "\033[1;31mCommand '$1' does not exit. This script allows running anything in the container, not just pytest. Try using:\033[1;33m

    ./test.sh pytest $@\033[0m"
    exit 1
fi
echo -n 'Removing pyc files ... '
if django-admin clean_pyc -v1; then
    echo 'Done.'
else
    echo -e "\033[1;31mFailed to cleanup pyc files. You may have have problems running the code!\033[0m

\033[33mTo fix run this: \033[1;33msudo chown \$USER -R .\033[0m"
fi
exec holdup --timeout 10 tcp://pg:5432 -- "$@"
