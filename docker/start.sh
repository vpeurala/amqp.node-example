#!/usr/bin/env bash
set -ex;
PROJECT_ROOT=$(git rev-parse --show-toplevel);
docker container create --hostname amqp-example --name amqp-example vpeurala/amqp-example:latest
docker container start amqp-example
