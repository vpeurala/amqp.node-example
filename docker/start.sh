#!/usr/bin/env bash
PROJECT_ROOT=$(git rev-parse --show-toplevel);

read -d '' USAGE <<END
Usage: $(basename $0) [options]

Create and start Docker container amqp-example, which runs RabbitMQ.

Options:
  -f    Force mode; if amqp-example container is already running, destroy and
        re-create it. The default behavior in the case that amqp-example
        container is already running is to do nothing.
  -h    Display this help message and exit.

END

FORCE=0;

while getopts ":fh" opt; do
  case ${opt} in
    f)
      echo "Force mode on.";
      FORCE=1;
      ;;
    h)
      echo "${USAGE}";
      exit 0;
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2;
      echo "${USAGE}" >&2;
      exit 1;
      ;;
  esac
done

CONTAINER_STATUS=$(docker inspect amqp-example | jq '.[0].State.Status');

if [ ${CONTAINER_STATUS} = '"running"' ]
then
  if [ ${FORCE} -eq 1 ]
  then
    cat <<END
Container amqp-example is already running with ID $(docker inspect amqp-example | jq '.[0].Id'),
but since you used force mode option (-f), it will be stopped, destroyed and re-created.
END
    docker container rm -f amqp-example > /dev/null;
    echo "Container $(docker inspect amqp-example | jq '.[0].Id') destroyed.";
  else
    echo "Container amqp-example is already running. Doing nothing.";
  fi
else
  docker container create --hostname amqp-example --name amqp-example --publish 4369:4369 --publish 5671:5671 --publish 5672:5672 --publish 15671:15671 --publish 15672:15672 --publish 25672:25672 vpeurala/amqp-example:latest;
  docker container start amqp-example;
fi
