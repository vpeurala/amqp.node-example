#!/usr/bin/env bash
set -ex;
PROJECT_ROOT=$(git rev-parse --show-toplevel);
docker build --file docker/Dockerfile --tag vpeurala/amqp-example:latest .
