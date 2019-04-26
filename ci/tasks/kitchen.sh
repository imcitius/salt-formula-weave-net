#!/usr/bin/env bash

set -uo pipefail
source $(dirname $0)/common.sh

# Start Docker
start_docker

# Print Ruby version for debugging
ruby -v

# Install dependencies into ./vendor
bundle install -j $(nproc) --path ./vendor --without kitchen

# Run the platform test
kitchen test ${PLATFORM}

# Stop Docker
stop_docker

# Done!
exit 0
