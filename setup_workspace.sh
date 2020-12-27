#!/usr/bin/env bash

usage() {
  printf "Usage: $0 [options] CONTAINER_NAME\n\n"
  printf "Setup vscode workspace for specified container\n\n"
  printf "Options:\n"
  printf "  -h|--help\t\t   Shows this help message\n"
  printf "  -u|--user DOCKER_USER\t   Docker container user [default: orise]\n"
}

DOCKER_USER="orise"

while [ -n "$1" ]; do
  case $1 in
  -h | --help)
    usage
    exit 0
    ;;
  -u | --user)
    shift
    DOCKER_USER=$1
    ;;
  -?*)
    echo "Unknown option '$1'" 1>&2
    exit 1
    ;;
  *)
    CONTAINER_NAME="$1"
    shift
    [[ ! -z "$@" ]] && echo -e "Invalid arguments: '$@'\n" && usage && exit 1
    break
    ;;
  esac
  shift
done

# Check CONTAINER_NAME
if [ -z "$CONTAINER_NAME" ]; then
  echo -e "CONTAINER_NAME not specified!\n"
  usage
  exit 1
fi

if [ -z $(docker ps -qa --filter name=^$CONTAINER_NAME$) ]; then
  echo "There is no container named '$CONTAINER_NAME'."
  exit 1
fi

if [ -z $(docker ps -qa --filter name=^$CONTAINER_NAME$ --filter status=running) ]; then
  echo "Container '$CONTAINER_NAME' is not running."
  exit 1
fi

WORKING_DIR=$(docker inspect -f {{.Config.WorkingDir}} $CONTAINER_NAME)
ROS_DISTRO=$(docker exec $CONTAINER_NAME /bin/bash -c "printenv ROS_DISTRO")
COLCON_WORKSPACE_FOLDER=$(docker exec $CONTAINER_NAME /bin/bash -c "printenv COLCON_WORKSPACE_FOLDER")

# Take container WORKING_DIR when $COLCON_WORKSPACE_FOLDER is not defined in the container
COLCON_WORKSPACE_FOLDER=${COLCON_WORKSPACE_FOLDER:-$WORKING_DIR}

CONTAINER_CONFIG_FOLDER="$HOME/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers/nameConfigs"

if [ ! -d "${CONTAINER_CONFIG_FOLDER}" ]; then
  mkdir -p "${CONTAINER_CONFIG_FOLDER}"
fi

# substitute docker user
substenv <.devcontainer.json >$CONTAINER_CONFIG_FOLDER/$CONTAINER_NAME.json

# copy config files to inside the container
docker cp ros2.code-workspace $CONTAINER_NAME:$COLCON_WORKSPACE_FOLDER/
docker cp .vscode-format/ $CONTAINER_NAME:$COLCON_WORKSPACE_FOLDER/
