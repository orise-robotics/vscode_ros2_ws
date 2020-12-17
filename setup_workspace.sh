#!/usr/bin/env bash

usage() {
  printf "Usage: $0 CONTAINER_NAME\n"
  printf "Setup vscode workspace for specified container\n\n"
  printf "Options:\n"
  printf "  -h|--help\t\t Shows this help message\n"
  # printf "  -c|--container\t\t Container name\n"
  # printf "  -d|--distro\t\t ROS distro (assumes container name is 'orise-$ROS_DISTRO-devel'\n"

  exit 0
}

while [ -n "$1" ]; do
  case $1 in
  -h | --help) usage ;;
  -?*)
    echo "Unknown option '$1'" 1>&2
    exit 1
    ;;
  *)
    CONTAINER_NAME=$1
    break
    ;;
  esac
  shift
done

WORKING_DIR=$(docker inspect -f {{.Config.WorkingDir}} $CONTAINER_NAME)
ROS_DISTRO=$(docker exec $CONTAINER_NAME /bin/bash -c "printenv ROS_DISTRO")
COLCON_WORKSPACE_FOLDER=$(docker exec $CONTAINER_NAME /bin/bash -c "printenv COLCON_WORKSPACE_FOLDER")

COLCON_WORKSPACE_FOLDER=${COLCON_WORKSPACE_FOLDER:-$WORKING_DIR}

CONTAINER_CONFIG_FOLDER="$HOME/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers/nameConfigs"

if [ ! -d "${CONTAINER_CONFIG_FOLDER}" ]; then
    mkdir -p "${CONTAINER_CONFIG_FOLDER}"
fi

echo '{"userEnvProbe": "loginInteractiveShell", "remoteUser": "orise"}' > "$CONTAINER_CONFIG_FOLDER/$CONTAINER_NAME.json"

docker cp ros2.code-workspace $CONTAINER_NAME:$COLCON_WORKSPACE_FOLDER/
docker cp .vscode-format/ $CONTAINER_NAME:$COLCON_WORKSPACE_FOLDER/
