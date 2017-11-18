#!/usr/bin/env bash
set -ex;
PROJECT_ROOT=$(git rev-parse --show-toplevel);
docker exec -it amqp-example bash