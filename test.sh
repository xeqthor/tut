#!/bin/bash -eux
if [[ -z "${RUN_INTEGRATION:-}" ]]; then
    DOCKER_CMD="docker-compose -f docker-compose.yml -f docker-compose.test.yml -p gctest"
else
    DOCKER_CMD="docker-compose -f docker-compose.yml -f docker-compose.test.yml -f docker-compose.integrationtest.yml -p gctest"
fi

DOCKER_VOLUMES="-v $PWD:/app"
USER="${USER:-$(id -nu)}"
if [[ "$(uname)" == "Darwin" ]]; then
    USER_UID=1000
    USER_GID=1000
else
    USER_UID="$(id --user "$USER")"
    USER_GID="$(id --group "$USER")"
fi

if [[ -z "${NOBUILD:-}" ]]; then
    $DOCKER_CMD build \
                --build-arg "PROJECT_NAME=gc" \
                base pg
    $DOCKER_CMD build \
                --build-arg "LOCAL_USER=$USER" \
                --build-arg "LOCAL_UID=$USER_UID" \
                --build-arg "LOCAL_GID=$USER_GID" \
                test
fi
if [[ -z "$@" ]]; then
    if [[ -z "${RUN_INTEGRATION:-}" ]]; then
        set -- py.test --flake8
    else
        set -- py.test --flake8 --run-integration
    fi
fi
function cleanup {
    echo "Cleaning up ..."
    $DOCKER_CMD down && $DOCKER_CMD rm -fv
}
if [[ -z "${NOCLEAN:-}" ]]; then
    trap cleanup EXIT
    cleanup || echo "Already clean :-)"
fi

$DOCKER_CMD run $DOCKER_VOLUMES --rm --user=$USER test "$@"
