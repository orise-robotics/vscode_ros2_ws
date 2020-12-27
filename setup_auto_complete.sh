#!/usr/bin/env bash

complete -W "$(docker ps -a --format {{.Names}})" ./setup_workspace.sh
