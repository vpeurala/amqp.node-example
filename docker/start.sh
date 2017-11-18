#!/usr/bin/env bash
set -ex;
PROJECT_ROOT=$(git rev-parse --show-toplevel);
docker container rm -f amqp-example || true;
docker container create --hostname amqp-example --name amqp-example --publish 4369:4369 --publish 5671:5671 --publish 5672:5672 --publish 15671:15671 --publish 15672:15672 --publish 25672:25672 vpeurala/amqp-example:latest
docker container start amqp-example